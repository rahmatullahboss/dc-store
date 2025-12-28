import { NextRequest, NextResponse } from "next/server";
import { getDatabase } from "@/lib/cloudflare";
import { carts, products, sessions } from "@/db/schema";
import { eq } from "drizzle-orm";
import { nanoid } from "nanoid";

// Helper to get user from session token
async function getUserFromToken(request: NextRequest) {
  const authHeader = request.headers.get("authorization");
  if (!authHeader?.startsWith("Bearer ")) {
    return null;
  }

  const token = authHeader.slice(7);
  const db = await getDatabase();

  const session = await db
    .select()
    .from(sessions)
    .where(eq(sessions.token, token))
    .then((rows) => rows[0]);

  if (!session || new Date(session.expiresAt) < new Date()) {
    return null;
  }

  return session.userId;
}

/**
 * GET /api/cart - Get user's cart
 */
export async function GET(request: NextRequest) {
  try {
    const userId = await getUserFromToken(request);

    if (!userId) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();

    // Get or create cart for user
    let cart = await db
      .select()
      .from(carts)
      .where(eq(carts.userId, userId))
      .then((rows) => rows[0]);

    if (!cart) {
      // Create empty cart
      const cartId = nanoid();
      await db.insert(carts).values({
        id: cartId,
        userId,
        items: [],
        createdAt: new Date(),
        updatedAt: new Date(),
      });

      cart = {
        id: cartId,
        userId,
        sessionId: null,
        items: [],
        createdAt: new Date(),
        updatedAt: new Date(),
      };
    }

    // Get product details for cart items
    const cartItems = cart.items || [];
    const enrichedItems = await Promise.all(
      cartItems.map(async (item) => {
        const product = await db
          .select()
          .from(products)
          .where(eq(products.id, item.productId))
          .then((rows) => rows[0]);

        return {
          id: `${item.productId}-${item.variantId || "default"}`,
          productId: item.productId,
          productName: product?.name || item.name,
          productImage: product?.featuredImage || item.image || "",
          price: item.price,
          quantity: item.quantity,
          variantId: item.variantId,
          maxQuantity: product?.quantity || 999,
        };
      })
    );

    // Calculate totals
    const subtotal = enrichedItems.reduce(
      (sum, item) => sum + item.price * item.quantity,
      0
    );

    return NextResponse.json({
      cart: {
        id: cart.id,
        items: enrichedItems,
        subtotal,
        shippingCost: subtotal > 0 ? 60 : 0,
        discount: 0,
        total: subtotal + (subtotal > 0 ? 60 : 0),
        itemCount: enrichedItems.reduce((sum, item) => sum + item.quantity, 0),
      },
    });
  } catch (error) {
    console.error("Get cart error:", error);
    return NextResponse.json(
      { error: "Failed to get cart" },
      { status: 500 }
    );
  }
}

/**
 * POST /api/cart/items - Add item to cart
 */
export async function POST(request: NextRequest) {
  try {
    const userId = await getUserFromToken(request);

    if (!userId) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = (await request.json()) as {
      productId?: string;
      quantity?: number;
      variantId?: string;
    };
    const { productId, quantity = 1, variantId } = body;

    if (!productId) {
      return NextResponse.json(
        { error: "Product ID is required" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    // Get product details
    const product = await db
      .select()
      .from(products)
      .where(eq(products.id, productId))
      .then((rows) => rows[0]);

    if (!product) {
      return NextResponse.json({ error: "Product not found" }, { status: 404 });
    }

    // Get or create cart
    let cart = await db
      .select()
      .from(carts)
      .where(eq(carts.userId, userId))
      .then((rows) => rows[0]);

    if (!cart) {
      const cartId = nanoid();
      await db.insert(carts).values({
        id: cartId,
        userId,
        items: [],
        createdAt: new Date(),
        updatedAt: new Date(),
      });

      cart = await db
        .select()
        .from(carts)
        .where(eq(carts.id, cartId))
        .then((rows) => rows[0]);
    }

    // Update cart items
    const currentItems = cart!.items || [];
    const existingItemIndex = currentItems.findIndex(
      (item) =>
        item.productId === productId &&
        (item.variantId || null) === (variantId || null)
    );

    if (existingItemIndex >= 0) {
      currentItems[existingItemIndex].quantity += quantity;
    } else {
      currentItems.push({
        productId,
        variantId,
        name: product.name,
        price: product.price,
        quantity,
        image: product.featuredImage || undefined,
      });
    }

    // Save updated cart
    await db
      .update(carts)
      .set({ items: currentItems, updatedAt: new Date() })
      .where(eq(carts.id, cart!.id));

    return NextResponse.json({ success: true, message: "Item added to cart" });
  } catch (error) {
    console.error("Add to cart error:", error);
    return NextResponse.json(
      { error: "Failed to add item to cart" },
      { status: 500 }
    );
  }
}

/**
 * DELETE /api/cart - Clear cart
 */
export async function DELETE(request: NextRequest) {
  try {
    const userId = await getUserFromToken(request);

    if (!userId) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();

    await db
      .update(carts)
      .set({ items: [], updatedAt: new Date() })
      .where(eq(carts.userId, userId));

    return NextResponse.json({ success: true, message: "Cart cleared" });
  } catch (error) {
    console.error("Clear cart error:", error);
    return NextResponse.json(
      { error: "Failed to clear cart" },
      { status: 500 }
    );
  }
}
