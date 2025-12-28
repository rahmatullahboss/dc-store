import { NextRequest, NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { wishlist, products, sessions } from "@/db/schema";
import { eq, and } from "drizzle-orm";
import { headers } from "next/headers";
import { nanoid } from "nanoid";

export const dynamic = "force-dynamic";

// Helper to get user ID from Bearer token or session cookie
async function getUserId(request: NextRequest): Promise<string | null> {
  // First try Bearer token (for mobile app)
  const authHeader = request.headers.get("authorization");
  if (authHeader?.startsWith("Bearer ")) {
    const token = authHeader.slice(7);
    const db = await getDatabase();

    const session = await db
      .select()
      .from(sessions)
      .where(eq(sessions.token, token))
      .then((rows) => rows[0]);

    if (session && new Date(session.expiresAt) >= new Date()) {
      return session.userId;
    }
  }

  // Fallback to cookie-based session (for web)
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (session?.user) {
      return session.user.id;
    }
  } catch {
    // Ignore cookie session errors
  }

  return null;
}

// GET - Fetch user's wishlist with product details
export async function GET(request: NextRequest) {
  try {
    const userId = await getUserId(request);

    if (!userId) {
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
      .where(eq(wishlist.userId, userId));

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
export async function POST(request: NextRequest) {
  try {
    const userId = await getUserId(request);

    if (!userId) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = (await request.json()) as { productId?: string };
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
      .where(and(eq(wishlist.userId, userId), eq(wishlist.productId, productId)))
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
      userId,
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
