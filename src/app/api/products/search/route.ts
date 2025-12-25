import { NextResponse } from "next/server";
import { getProducts, getProductCategories } from "@/lib/queries";

export const dynamic = "force-dynamic";

// CORS headers for mobile app access
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

export async function OPTIONS() {
  return NextResponse.json({}, { headers: corsHeaders });
}

export async function GET() {
  try {
    const [products, categoryIds] = await Promise.all([
      getProducts(),
      getProductCategories(),
    ]);

    return NextResponse.json(
      {
        products,
        categories: categoryIds,
      },
      { headers: corsHeaders }
    );
  } catch (error) {
    console.error("Error fetching products for search:", error);
    return NextResponse.json(
      { error: "Failed to fetch products", products: [], categories: [] },
      { status: 500, headers: corsHeaders }
    );
  }
}
