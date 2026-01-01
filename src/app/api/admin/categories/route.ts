import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { categories, products } from "@/db/schema";
import { eq } from "drizzle-orm";
import { headers } from "next/headers";
import { nanoid } from "nanoid";

export const dynamic = "force-dynamic";

// GET - List categories
export async function GET() {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();

    const categoryList = await db
      .select({
        id: categories.id,
        name: categories.name,
        slug: categories.slug,
        description: categories.description,
        isActive: categories.isActive,
        sortOrder: categories.sortOrder,
        productsCount: db.$count(products, eq(products.categoryId, categories.id)),
      })
      .from(categories)
      .orderBy(categories.sortOrder, categories.name);

    return NextResponse.json({ categories: categoryList });
  } catch (error) {
    console.error("Categories list error:", error);
    return NextResponse.json({ error: "Failed to fetch categories" }, { status: 500 });
  }
}

// POST - Create category
export async function POST(request: Request) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await request.json() as { name: string; description?: string };
    const db = await getDatabase();

    const id = nanoid();
    const slug = body.name.toLowerCase().replace(/[^a-z0-9]+/g, "-");

    await db.insert(categories).values({
      id,
      name: body.name,
      slug,
      description: body.description || null,
      isActive: true,
      sortOrder: 0,
    });

    return NextResponse.json({ success: true, id });
  } catch (error) {
    console.error("Create category error:", error);
    return NextResponse.json({ error: "Failed to create category" }, { status: 500 });
  }
}
