import { createGroq } from "@ai-sdk/groq";
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
      .limit(30);

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
    // Return empty array if database fetch fails
    return [];
  }
}

function generateSystemPrompt(productList: string) {
  return `You are a helpful customer support assistant for "${siteConfig.name}" e-commerce store.

LANGUAGE: Use Bengali when user writes in Bengali, otherwise English.
GREETING: Greet with "সালাম" or "আসসালামু আলাইকুম" - NEVER use "নমস্কার"

##MANDATORY PRODUCT FORMAT##
When showing ANY product, you MUST ALWAYS output it in this EXACT format:
[PRODUCT:id:name:price:category:inStock:imageUrl]

Example output:
[PRODUCT:prod-1:Premium Headphones:4999:Electronics:true:/images/headphones.jpg]

##AVAILABLE PRODUCTS (USE ONLY THESE)##
${productList}

##RULES##
1. When user asks "ki ache", "product dekhan", "ki ki ache", or similar - you MUST show 3-5 products using the [PRODUCT:...] format
2. NEVER describe products in plain text - ALWAYS use the [PRODUCT:...] format
3. Pick relevant products from the list above
4. After showing products, ask if they want to see more or need help

##ORDERING##
- You CANNOT take orders directly
- Tell customers: "অর্ডার করতে উপরে প্রোডাক্ট কার্ডে ক্লিক করুন, Add to Cart করুন এবং Checkout এ যান!"
- NEVER ask for customer info or confirm orders

##STORE INFO##
- Store: ${siteConfig.name}
- Delivery: Inside and outside Dhaka
- Payment: bKash, Nagad, Cash on Delivery
- Contact: ${siteConfig.phone}
- Processing: 1-2 business days`;
}

export async function POST(req: Request) {
  const { messages }: { messages: UIMessage[] } = await req.json();

  // Fetch real products from database
  const realProducts = await fetchProducts();
  
  const productListStr = realProducts.length > 0
    ? realProducts
        .map(
          (p) =>
            `- ID:${p.id} | ${p.name} | ${formatPrice(p.price)} | ${p.category} | ${
              p.inStock ? "In Stock" : "Out"
            } | ${p.image}`
        )
        .join("\n")
    : "No products available at the moment.";

  const systemPrompt = generateSystemPrompt(productListStr);
  const enhancedMessages = await convertToModelMessages(messages);

  const groqKey = process.env.GROQ_API_KEY;

  if (!groqKey) {
    return new Response(
      JSON.stringify({
        error: "Chat service unavailable. GROQ_API_KEY not configured.",
      }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }

  try {
    const groq = createGroq({ apiKey: groqKey });
    const result = streamText({
      model: groq("llama-3.3-70b-versatile"),
      system: systemPrompt,
      messages: enhancedMessages,
    });
    return result.toUIMessageStreamResponse();
  } catch (error) {
    console.error("Groq API error:", error);
    return new Response(
      JSON.stringify({ error: "Chat service error. Please try again." }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
}
