import { createOpenRouter } from "@openrouter/ai-sdk-provider";
import { streamText, convertToModelMessages, type UIMessage } from "ai";
import { siteConfig } from "@/lib/config";
import { getDatabase } from "@/lib/cloudflare";
import { products } from "@/db/schema";
import { eq } from "drizzle-orm";

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

function generateSystemPrompt(productList: string, locale: string = "en") {
  const isBengali = locale === "bn";

  return `You are a customer support assistant for "${siteConfig.name}" e-commerce store.

LANGUAGE: ${isBengali ? "Bengali (Bangla). Use English only if user asks in English or for technical terms." : "English. Use Bengali only if user asks in Bengali."}
GREETING: ${isBengali ? 'Use "আসসালামু আলাইকুম"' : 'Use "Hello" or "Hi"'}. Never use "Namaskar".

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

## EXAMPLE RESPONSE
User: "${isBengali ? "কি কি আছে?" : "What do you have?"}"
You: ${isBengali ? "আমাদের কিছু প্রোডাক্ট দেখুন:" : "Here are some of our products:"}

[PRODUCT:premium-headphones:Premium Headphones:4999:Electronics:true:/placeholder.svg]
[PRODUCT:classic-watch:Classic Watch:2999:Accessories:true:/placeholder.svg]

${isBengali ? "আরো দেখতে চাইলে বলুন! 😊" : "Let me know if you want to see more! 😊"}

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

  const systemPrompt = generateSystemPrompt(productListStr, locale || "en");
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
    const openrouter = createOpenRouter({
      apiKey: openrouterKey,
    });
    const result = streamText({
      model: openrouter("xiaomi/mimo-v2-flash:free"),
      system: systemPrompt,
      messages: enhancedMessages,
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

