import { createOpenRouter } from "@openrouter/ai-sdk-provider";
import { streamText, convertToModelMessages, type UIMessage } from "ai";
import { siteConfig, formatPrice } from "@/lib/config";
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

function generateSystemPrompt(productList: string) {
  return `You are a helpful customer support assistant for "${siteConfig.name}" e-commerce store.

LANGUAGE: Use Bengali when user writes in Bengali, otherwise English.
GREETING: Greet with "সালাম" or "আসসালামু আলাইকুম" - NEVER use "নমস্কার"

##MANDATORY PRODUCT FORMAT##
When showing ANY product, you MUST output it in this EXACT format:
[PRODUCT:slug:name:price:category:inStock:imageUrl]

⚠️ CRITICAL: Copy the EXACT slug from the product list below. NEVER:
- Guess or make up slugs
- Modify slugs (no adding/removing characters)
- Use product names as slugs
- Create slugs from product names

##AVAILABLE PRODUCTS - USE ONLY THESE EXACT SLUGS##
${productList}

##RULES##
1. When user asks "ki ache", "product dekhan", "show products", or similar - show 3-5 products using [PRODUCT:...] format
2. ONLY recommend products from the list above - NEVER invent products
3. COPY slugs EXACTLY as shown - any modification will break the link!
4. After showing products, ask if they want to see more or need help

##EXAMPLE##
User: "কি কি প্রোডাক্ট আছে?"
Assistant: আমাদের কিছু জনপ্রিয় প্রোডাক্ট দেখুন:

[PRODUCT:exact-slug-from-list:Product Name:999:Category:true:/image.jpg]

আরো দেখতে চাইলে বলুন! 😊

##ORDERING##
- You CANNOT take orders directly
- Tell customers: "অর্ডার করতে প্রোডাক্ট কার্ডে ক্লিক করুন, Add to Cart করুন!"
- NEVER ask for customer info or confirm orders

##STORE INFO##
- Store: ${siteConfig.name}
- Delivery: Inside and outside Dhaka
- Payment: bKash, Nagad, Cash on Delivery
- Contact: ${siteConfig.phone}`;
}

export async function POST(req: Request) {
  const { messages }: { messages: UIMessage[] } = await req.json();

  // Fetch real products from database
  const realProducts = await fetchProducts();
  
  const productListStr = realProducts.length > 0
    ? realProducts
         .map(
          (p) =>
            `SLUG="${p.slug}" | ${p.name} | ${formatPrice(p.price)} | ${p.category} | ${
              p.inStock ? "In Stock" : "Out"
            } | ${p.image}`
        )
        .join("\n")
    : "No products available at the moment.";

  const systemPrompt = generateSystemPrompt(productListStr);
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
      model: openrouter("google/gemini-2.0-flash-001"),
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

