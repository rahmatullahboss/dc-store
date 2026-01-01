import { createOpenRouter } from "@openrouter/ai-sdk-provider";
import { streamText, convertToModelMessages, type UIMessage, stepCountIs } from "ai";
import { siteConfig } from "@/lib/config";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { products, users } from "@/db/schema";
import { eq } from "drizzle-orm";
import { headers } from "next/headers";
import { createChatTools, type ChatToolsContext } from "@/lib/chat-tools";

// Using default runtime for OpenNext compatibility
export const dynamic = "force-dynamic";


// Fetch real products from database
async function fetchProducts() {
  try {
    const db = await getDatabase();
    const dbProducts = await db
      .select({
        id: products.id,
        name: products.name,
        slug: products.slug,
        price: products.price,
        categoryId: products.categoryId,
        quantity: products.quantity,
        featuredImage: products.featuredImage,
      })
      .from(products)
      .where(eq(products.isActive, true))
      .limit(50);

    return dbProducts.map(p => ({
      id: p.id,
      name: p.name,
      slug: p.slug,
      price: p.price,
      category: p.categoryId || "General",
      inStock: (p.quantity || 0) > 0,
      image: p.featuredImage || "/placeholder.svg",
    }));
  } catch (error) {
    console.error("Error fetching products for chat:", error);
    return [];
  }
}

// Get authenticated user info
async function getAuthenticatedUser(): Promise<ChatToolsContext> {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });
    
    if (session?.user) {
      // Fetch additional user info
      const db = await getDatabase();
      const [userProfile] = await db
        .select({
          phone: users.phone,
        })
        .from(users)
        .where(eq(users.id, session.user.id))
        .limit(1);

      return {
        userId: session.user.id,
        userName: session.user.name || null,
        userEmail: session.user.email || null,
        userPhone: userProfile?.phone || null,
      };
    }
  } catch (error) {
    console.error("Error getting authenticated user:", error);
  }
  
  return {
    userId: null,
    userName: null,
    userEmail: null,
    userPhone: null,
  };
}

function generateSystemPrompt(productList: string, locale: string = "en", userContext: ChatToolsContext) {
  const isBengali = locale === "bn";
  const isLoggedIn = !!userContext.userId;

  const orderCapabilities = isLoggedIn
    ? isBengali
      ? `
## ORDER & SUPPORT CAPABILITIES (LOGGED IN USER)
আপনি একজন logged-in customer "${userContext.userName || 'User'}" এর সাথে কথা বলছেন।

আপনি এই কাজগুলো করতে পারেন:
1. **Orders দেখানো**: Customer যদি orders দেখতে চায়, getCustomerOrders tool ব্যবহার করুন
2. **Order Status**: নির্দিষ্ট order এর status জানতে getOrderStatus tool ব্যবহার করুন
3. **Support Ticket**: Complaint বা সমস্যা হলে createSupportTicket tool ব্যবহার করুন

যখন customer বলে:
- "আমার orders দেখাও" / "কি অর্ডার করেছি" → getCustomerOrders ব্যবহার করুন
- "Order #XXX এর status কি?" → getOrderStatus ব্যবহার করুন
- "সমস্যা আছে" / "complaint" / "রিফান্ড চাই" → createSupportTicket ব্যবহার করুন

Tool result পাওয়ার পর response সুন্দরভাবে format করুন।`
      : `
## ORDER & SUPPORT CAPABILITIES (LOGGED IN USER)
You are chatting with a logged-in customer "${userContext.userName || 'User'}".

You can perform these actions:
1. **Show Orders**: Use getCustomerOrders tool when customer wants to see orders
2. **Order Status**: Use getOrderStatus tool to check specific order status
3. **Support Ticket**: Use createSupportTicket tool for complaints or issues

When customer says:
- "show my orders" / "what did I order" → Use getCustomerOrders
- "status of order #XXX" → Use getOrderStatus
- "I have a problem" / "complaint" / "refund" → Use createSupportTicket

Format the tool results nicely in your response.`
    : isBengali
      ? `
## ORDER & SUPPORT CAPABILITIES (GUEST USER)
এই user logged in নয়।

- Orders দেখতে বা order status জানতে বলুন: "দয়া করে login করুন আপনার orders দেখতে।"
- Support ticket এর জন্য guest ও তৈরি করতে পারে যদি phone number দেয়।`
      : `
## ORDER & SUPPORT CAPABILITIES (GUEST USER)
This user is not logged in.

- For orders or order status, say: "Please login to view your orders."
- Guests can still create support tickets if they provide phone number.`;

  return `You are a customer support assistant for "${siteConfig.name}" e-commerce store.

LANGUAGE: ${isBengali ? "Bengali (Bangla). Use English only if user asks in English or for technical terms." : "English. Use Bengali only if user asks in Bengali."}
GREETING: ${isBengali ? 'Use "আসসালামু আলাইকুম"' : 'Use "Hello" or "Hi"'}. Never use "Namaskar".

${orderCapabilities}

## PRODUCT DISPLAY FORMAT (MANDATORY)
When showing products, you MUST use this EXACT format - no exceptions:
[PRODUCT:slug:name:price:category:inStock:imageUrl]

Example with real data:
[PRODUCT:premium-headphones:Premium Headphones:4999:Electronics:true:/placeholder.svg]

## AVAILABLE PRODUCTS
${productList}

## CRITICAL RULES
1. When user asks about products ("ki ache", "show products", "কি আছে", etc) - you MUST respond with 3-5 [PRODUCT:...] tags
2. Use the EXACT slug from the product list - DO NOT modify or invent slugs
3. Price should be a NUMBER only (no ৳ or BDT symbol inside the tag)
4. For imageUrl, use the image path exactly as shown in the product list
5. ALWAYS include product tags when recommending products - NEVER just describe them in text

## TOOL USAGE RULES
1. When showing orders from getCustomerOrders, format as a nice list with order numbers, status, and totals
2. When showing order status from getOrderStatus, include all relevant details
3. When a ticket is created via createSupportTicket, confirm with the ticket number prominently

## ORDERING
- Tell customers: "${isBengali ? 'প্রোডাক্ট কার্ডে ক্লিক করুন এবং Add to Cart করুন!' : 'Click the product card and Add to Cart!'}"
- Never take orders directly in chat

## STORE INFO
- Store: ${siteConfig.name}
- Delivery: Dhaka & outside
- Payment: bKash, Nagad, COD
- Contact: ${siteConfig.phone}`;
}

export async function POST(req: Request) {
  const body = await req.json();
  const { messages: rawMessages, locale } = body as { messages: unknown[], locale?: string };

  // Convert simple {role, content} format (from mobile) to UIMessage format if needed
  const messages: UIMessage[] = rawMessages.map((msg: unknown, index: number) => {
    const m = msg as { id?: string; role: string; content?: string; parts?: unknown[] };
    
    // If already in UIMessage format with parts, use as-is
    if (m.parts && Array.isArray(m.parts)) {
      return m as UIMessage;
    }
    
    // Convert simple format to UIMessage format
    return {
      id: m.id || `msg-${index}-${Date.now()}`,
      role: m.role as 'user' | 'assistant' | 'system',
      parts: [{ type: 'text' as const, text: m.content || '' }],
    };
  });

  // Get authenticated user context
  const userContext = await getAuthenticatedUser();

  // Fetch real products from database
  const realProducts = await fetchProducts();
  
  const productListStr = realProducts.length > 0
    ? realProducts
         .map(
          (p) =>
            `- slug="${p.slug}" | name="${p.name}" | price=${p.price} | category="${p.category}" | inStock=${p.inStock} | image="${p.image}"`
        )
        .join("\n")
    : "No products available.";

  const systemPrompt = generateSystemPrompt(productListStr, locale || "en", userContext);
  const enhancedMessages = await convertToModelMessages(messages);

  const openrouterKey = process.env.OPENROUTER_API_KEY;

  if (!openrouterKey) {
    return new Response(
      JSON.stringify({
        error: "Chat service unavailable. OPENROUTER_API_KEY not configured.",
      }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }

  try {
    // Create AI tools with user context
    const chatTools = createChatTools(userContext, locale || "en");

    const openrouter = createOpenRouter({
      apiKey: openrouterKey,
    });
    
    const result = streamText({
      model: openrouter("google/gemini-2.0-flash-001"),
      system: systemPrompt,
      messages: enhancedMessages,
      tools: chatTools,
      stopWhen: stepCountIs(5), // Allow up to 5 tool call steps
    });
    
    return result.toUIMessageStreamResponse();
  } catch (error) {
    console.error("OpenRouter API error:", error);
    return new Response(
      JSON.stringify({ error: "Chat service error. Please try again." }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
}
