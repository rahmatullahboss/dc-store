import { NextResponse } from "next/server";
import { revalidatePath } from "next/cache";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { products } from "@/db/schema";
import { eq } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

// GET - Get single product
export async function GET(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();
    const product = await db.query.products.findFirst({
      where: eq(products.id, id),
    });

    if (!product) {
      return NextResponse.json({ error: "Product not found" }, { status: 404 });
    }

    return NextResponse.json({ product });
  } catch (error) {
    console.error("Get product error:", error);
    return NextResponse.json({ error: "Failed to fetch product" }, { status: 500 });
  }
}

// PATCH - Update product
export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await request.json() as Record<string, unknown>;
    const db = await getDatabase();

    // Get the current product to know its slug for revalidation
    const existingProduct = await db.query.products.findFirst({
      where: eq(products.id, id),
    });

    await db
      .update(products)
      .set({
        ...body,
        updatedAt: new Date(),
      })
      .where(eq(products.id, id));

    // Revalidate product pages for instant updates
    revalidatePath("/");
    revalidatePath("/products");
    if (existingProduct?.slug) {
      revalidatePath(`/products/${existingProduct.slug}`);
    }
    // Also revalidate the new slug if it was changed
    if (body.slug && body.slug !== existingProduct?.slug) {
      revalidatePath(`/products/${body.slug}`);
    }

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Update product error:", error);
    return NextResponse.json({ error: "Failed to update product" }, { status: 500 });
  }
}

// DELETE - Delete product
export async function DELETE(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();
    
    // Get the product slug before deleting for cache revalidation
    const existingProduct = await db.query.products.findFirst({
      where: eq(products.id, id),
    });
    
    await db.delete(products).where(eq(products.id, id));

    // Revalidate product pages for instant updates
    revalidatePath("/");
    revalidatePath("/products");
    if (existingProduct?.slug) {
      revalidatePath(`/products/${existingProduct.slug}`);
    }

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Delete product error:", error);
    return NextResponse.json({ error: "Failed to delete product" }, { status: 500 });
  }
}

