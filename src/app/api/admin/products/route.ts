import { NextResponse } from "next/server";
import { revalidatePath } from "next/cache";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { products, categories } from "@/db/schema";
import { eq, like, and, desc } from "drizzle-orm";
import { headers } from "next/headers";
import { nanoid } from "nanoid";

export const dynamic = "force-dynamic";

// GET - List all products
export async function GET(request: Request) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const search = searchParams.get("search") || "";
    const category = searchParams.get("category") || "";
    const status = searchParams.get("status") || "";

    const db = await getDatabase();

    const whereConditions = [];
    if (search) {
      whereConditions.push(like(products.name, `%${search}%`));
    }
    if (category) {
      whereConditions.push(eq(products.categoryId, category));
    }
    if (status === "active") {
      whereConditions.push(eq(products.isActive, true));
    } else if (status === "inactive") {
      whereConditions.push(eq(products.isActive, false));
    }

    const productList = await db
      .select({
        id: products.id,
        name: products.name,
        slug: products.slug,
        price: products.price,
        compareAtPrice: products.compareAtPrice,
        quantity: products.quantity,
        featuredImage: products.featuredImage,
        isActive: products.isActive,
        isFeatured: products.isFeatured,
        categoryId: products.categoryId,
        categoryName: categories.name,
        createdAt: products.createdAt,
      })
      .from(products)
      .leftJoin(categories, eq(products.categoryId, categories.id))
      .where(whereConditions.length > 0 ? and(...whereConditions) : undefined)
      .orderBy(desc(products.createdAt));

    return NextResponse.json({ products: productList });
  } catch (error) {
    console.error("Products list error:", error);
    return NextResponse.json({ error: "Failed to fetch products" }, { status: 500 });
  }
}

// POST - Create new product
export async function POST(request: Request) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await request.json() as {
      name: string;
      slug?: string;
      description?: string;
      shortDescription?: string;
      price: number;
      compareAtPrice?: number;
      costPrice?: number;
      sku?: string;
      barcode?: string;
      quantity?: number;
      lowStockThreshold?: number;
      trackQuantity?: boolean;
      categoryId?: string;
      images?: string[];
      featuredImage?: string;
      isActive?: boolean;
      isFeatured?: boolean;
      weight?: number;
      weightUnit?: "kg" | "g" | "lb" | "oz";
      metaTitle?: string;
      metaDescription?: string;
    };
    const db = await getDatabase();

    const id = nanoid();
    const slug = body.slug || body.name.toLowerCase().replace(/[^a-z0-9]+/g, "-");

    await db.insert(products).values({
      id,
      name: body.name,
      slug,
      description: body.description || null,
      shortDescription: body.shortDescription || null,
      price: body.price,
      compareAtPrice: body.compareAtPrice || null,
      costPrice: body.costPrice || null,
      sku: body.sku || null,
      barcode: body.barcode || null,
      quantity: body.quantity || 0,
      lowStockThreshold: body.lowStockThreshold || 5,
      trackQuantity: body.trackQuantity ?? true,
      categoryId: body.categoryId || null,
      images: body.images || [],
      featuredImage: body.featuredImage || null,
      isActive: body.isActive ?? true,
      isFeatured: body.isFeatured ?? false,
      weight: body.weight || null,
      weightUnit: body.weightUnit || "kg",
      metaTitle: body.metaTitle || null,
      metaDescription: body.metaDescription || null,
    });

    // Revalidate product pages for instant updates
    revalidatePath("/");
    revalidatePath("/products");

    return NextResponse.json({ success: true, id });
  } catch (error) {
    console.error("Create product error:", error);
    return NextResponse.json({ error: "Failed to create product" }, { status: 500 });
  }
}

