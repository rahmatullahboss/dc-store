import { NextResponse } from "next/server";
import { getCategories, getFeaturedCategories } from "@/lib/queries/categories";

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

export async function GET(request: Request) {
  try {
    const { searchParams } = new URL(request.url);
    const featured = searchParams.get("featured") === "true";
    const limit = parseInt(searchParams.get("limit") || "10", 10);

    let categories;
    
    if (featured) {
      categories = await getFeaturedCategories(limit);
    } else {
      categories = await getCategories();
    }

    // Transform to match mobile app expected format
    const transformedCategories = categories.map((cat) => ({
      id: cat.id,
      name: cat.name,
      slug: cat.slug,
      description: cat.description,
      image: cat.image,
      parentId: cat.parentId,
      productCount: cat.productCount,
      sortOrder: cat.sortOrder,
      isActive: cat.isActive,
      isFeatured: cat.productCount > 10, // Consider featured if has > 10 products
      createdAt: cat.createdAt,
    }));

    return NextResponse.json(
      { 
        categories: transformedCategories,
        data: transformedCategories, // Alternative key for compatibility
        total: transformedCategories.length,
      },
      { headers: corsHeaders }
    );
  } catch (error) {
    console.error("Error fetching categories:", error);
    return NextResponse.json(
      { error: "Failed to fetch categories", categories: [], data: [] },
      { status: 500, headers: corsHeaders }
    );
  }
}
