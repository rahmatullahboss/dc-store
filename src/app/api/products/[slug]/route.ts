
import { NextResponse } from "next/server";
import { getProductBySlug } from "@/lib/queries/products";
import { getDatabase } from "@/lib/cloudflare";
import { products } from "@/db/schema";
import { eq } from "drizzle-orm";

// CORS headers for mobile app access
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

export async function OPTIONS() {
  return NextResponse.json({}, { headers: corsHeaders });
}

export async function GET(
  request: Request,
  { params }: { params: Promise<{ slug: string }> }
) {
  try {
    const { slug } = await params;
    
    // First try strictly by slug using the existing query function
    let product = await getProductBySlug(slug);

    // If not found, try by ID (since mobile api might be sending ID)
    if (!product) {
       const db = await getDatabase();
       const result = await db.query.products.findFirst({
         where: eq(products.id, slug),
         with: {
            category: true,
         }
       });
       if (result) {
         product = result;
       }
    }

    if (!product) {
      return NextResponse.json(
        { error: "Product not found" },
        { status: 404, headers: corsHeaders }
      );
    }

    // Return in the format expected by mobile app (and web)
    return NextResponse.json({
      product: product,
    }, { headers: corsHeaders });
  } catch (error) {
    console.error("Error fetching product:", error);
    return NextResponse.json(
      { error: "Internal Server Error" },
      { status: 500, headers: corsHeaders }
    );
  }
}
