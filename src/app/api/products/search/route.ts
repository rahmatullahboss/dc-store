import { NextRequest, NextResponse } from "next/server";
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

export async function GET(request: NextRequest) {
  try {
    const searchParams = request.nextUrl.searchParams;
    const query = searchParams.get("q")?.toLowerCase().trim();
    const categoryId = searchParams.get("category");
    const featured = searchParams.get("featured");

    const [allProducts, categoryIds] = await Promise.all([
      getProducts(),
      getProductCategories(),
    ]);

    let filteredProducts = allProducts;

    // Filter by search query
    if (query && query.length > 0) {
      filteredProducts = filteredProducts.filter(
        (product) =>
          product.name.toLowerCase().includes(query) ||
          product.description?.toLowerCase().includes(query) ||
          product.slug?.toLowerCase().includes(query)
      );
    }

    // Filter by category
    if (categoryId) {
      filteredProducts = filteredProducts.filter(
        (product) => product.categoryId === categoryId
      );
    }

    // Filter by featured
    if (featured === "true") {
      filteredProducts = filteredProducts.filter(
        (product) => product.isFeatured === true
      );
    }

    return NextResponse.json(
      {
        products: filteredProducts,
        categories: categoryIds,
        total: filteredProducts.length,
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
