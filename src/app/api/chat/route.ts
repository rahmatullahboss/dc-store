import { createGroq } from "@ai-sdk/groq";
import { streamText, convertToModelMessages, type UIMessage } from "ai";
import { siteConfig, formatPrice } from "@/lib/config";

// Using default runtime for OpenNext compatibility

// Demo products for chat context (in real app, fetch from D1)
const demoProducts = [
  {
    id: "1",
    name: "Premium Wireless Headphones",
    price: 4999,
    category: "Electronics",
    inStock: true,
  },
  {
    id: "2",
    name: "Smart Watch Series X",
    price: 12999,
    category: "Electronics",
    inStock: true,
  },
  {
    id: "3",
    name: "Designer Leather Bag",
    price: 8499,
    category: "Fashion",
    inStock: true,
  },
  {
    id: "4",
    name: "Running Sneakers Pro",
    price: 6999,
    category: "Sports",
    inStock: true,
  },
  {
    id: "5",
    name: "Vintage Camera",
    price: 15999,
    category: "Electronics",
    inStock: true,
  },
  {
    id: "6",
    name: "Minimalist Desk Lamp",
    price: 2499,
    category: "Home",
    inStock: true,
  },
];

function generateSystemPrompt() {
  const productList = demoProducts
    .map(
      (p) =>
        `- ID:${p.id} | ${p.name} | ${formatPrice(p.price)} | ${p.category} | ${
          p.inStock ? "In Stock" : "Out"
        }`
    )
    .join("\n");

  return `You are a helpful customer support assistant for "${siteConfig.name}" e-commerce store.

LANGUAGE: Use Bengali when user writes in Bengali, otherwise English.
GREETING: Greet with "সালাম" or "আসসালামু আলাইকুম" - NEVER use "নমস্কার"

##MANDATORY PRODUCT FORMAT##
When showing ANY product, you MUST ALWAYS output it in this EXACT format:
[PRODUCT:id:name:price:category:inStock:imageUrl]

Example output:
[PRODUCT:1:Premium Headphones:4999:Electronics:true:/images/headphones.jpg]

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

  const systemPrompt = generateSystemPrompt();
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
