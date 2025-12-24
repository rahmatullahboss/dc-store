import { NextResponse } from "next/server";
import { getProducts, getProductCategories } from "@/lib/queries";

export const dynamic = "force-dynamic";

export async function GET() {
  try {
    const [products, categoryIds] = await Promise.all([
      getProducts(),
      getProductCategories(),
    ]);

    return NextResponse.json({
      products,
      categories: categoryIds,
    });
  } catch (error) {
    console.error("Error fetching products for search:", error);
    return NextResponse.json(
      { error: "Failed to fetch products", products: [], categories: [] },
      { status: 500 }
    );
  }
}
