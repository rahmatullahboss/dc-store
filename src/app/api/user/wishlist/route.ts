import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { wishlist, products } from "@/db/schema";
import { eq, and } from "drizzle-orm";
import { headers } from "next/headers";
import { nanoid } from "nanoid";

export const dynamic = "force-dynamic";

// GET - Fetch user's wishlist with product details
export async function GET() {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();

    const wishlistItems = await db
      .select({
        id: wishlist.id,
        productId: wishlist.productId,
        createdAt: wishlist.createdAt,
        product: {
          id: products.id,
          name: products.name,
          slug: products.slug,
          price: products.price,
          compareAtPrice: products.compareAtPrice,
          featuredImage: products.featuredImage,
          images: products.images,
          quantity: products.quantity,
          isActive: products.isActive,
        },
      })
      .from(wishlist)
      .innerJoin(products, eq(wishlist.productId, products.id))
      .where(eq(wishlist.userId, session.user.id));

    return NextResponse.json({
      items: wishlistItems.map((item) => ({
        ...item,
        createdAt: item.createdAt?.toISOString(),
        product: {
          ...item.product,
          inStock: (item.product.quantity ?? 0) > 0,
        },
      })),
      count: wishlistItems.length,
    });
  } catch (error) {
    console.error("Error fetching wishlist:", error);
    return NextResponse.json(
      { error: "Failed to fetch wishlist" },
      { status: 500 }
    );
  }
}

// POST - Add product to wishlist
export async function POST(request: Request) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await request.json() as { productId?: string };
    const { productId } = body;

    if (!productId) {
      return NextResponse.json(
        { error: "Product ID is required" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    // Check if already in wishlist
    const existing = await db
      .select()
      .from(wishlist)
      .where(
        and(
          eq(wishlist.userId, session.user.id),
          eq(wishlist.productId, productId)
        )
      )
      .limit(1);

    if (existing.length > 0) {
      return NextResponse.json(
        { error: "Product already in wishlist", id: existing[0].id },
        { status: 409 }
      );
    }

    // Add to wishlist
    const newItem = {
      id: nanoid(),
      userId: session.user.id,
      productId,
    };

    await db.insert(wishlist).values(newItem);

    return NextResponse.json({
      success: true,
      id: newItem.id,
      message: "Added to wishlist",
    });
  } catch (error) {
    console.error("Error adding to wishlist:", error);
    return NextResponse.json(
      { error: "Failed to add to wishlist" },
      { status: 500 }
    );
  }
}
