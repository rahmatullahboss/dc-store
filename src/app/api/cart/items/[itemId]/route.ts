import { NextRequest, NextResponse } from "next/server";
import { getDatabase } from "@/lib/cloudflare";
import { carts, sessions } from "@/db/schema";
import { eq } from "drizzle-orm";

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
 * PATCH /api/cart/items/[itemId] - Update cart item quantity
 */
export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ itemId: string }> }
) {
  try {
    const userId = await getUserFromToken(request);

    if (!userId) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { itemId } = await params;
    const body = (await request.json()) as { quantity?: number };
    const { quantity } = body;

    if (typeof quantity !== "number" || quantity < 0) {
      return NextResponse.json(
        { error: "Invalid quantity" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    const cart = await db
      .select()
      .from(carts)
      .where(eq(carts.userId, userId))
      .then((rows) => rows[0]);

    if (!cart) {
      return NextResponse.json({ error: "Cart not found" }, { status: 404 });
    }

    // Parse itemId to get productId and variantId
    const [productId, variantId] = itemId.split("-");

    let currentItems = cart.items || [];

    if (quantity === 0) {
      // Remove item
      currentItems = currentItems.filter(
        (item) =>
          !(
            item.productId === productId &&
            (item.variantId || "default") === (variantId || "default")
          )
      );
    } else {
      // Update quantity
      const itemIndex = currentItems.findIndex(
        (item) =>
          item.productId === productId &&
          (item.variantId || "default") === (variantId || "default")
      );

      if (itemIndex >= 0) {
        currentItems[itemIndex].quantity = quantity;
      }
    }

    await db
      .update(carts)
      .set({ items: currentItems, updatedAt: new Date() })
      .where(eq(carts.id, cart.id));

    return NextResponse.json({
      success: true,
      message: quantity === 0 ? "Item removed" : "Quantity updated",
    });
  } catch (error) {
    console.error("Update cart item error:", error);
    return NextResponse.json(
      { error: "Failed to update cart item" },
      { status: 500 }
    );
  }
}

/**
 * DELETE /api/cart/items/[itemId] - Remove item from cart
 */
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ itemId: string }> }
) {
  try {
    const userId = await getUserFromToken(request);

    if (!userId) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { itemId } = await params;
    const db = await getDatabase();

    const cart = await db
      .select()
      .from(carts)
      .where(eq(carts.userId, userId))
      .then((rows) => rows[0]);

    if (!cart) {
      return NextResponse.json({ error: "Cart not found" }, { status: 404 });
    }

    // Parse itemId
    const [productId, variantId] = itemId.split("-");

    const currentItems = (cart.items || []).filter(
      (item) =>
        !(
          item.productId === productId &&
          (item.variantId || "default") === (variantId || "default")
        )
    );

    await db
      .update(carts)
      .set({ items: currentItems, updatedAt: new Date() })
      .where(eq(carts.id, cart.id));

    return NextResponse.json({ success: true, message: "Item removed" });
  } catch (error) {
    console.error("Remove cart item error:", error);
    return NextResponse.json(
      { error: "Failed to remove cart item" },
      { status: 500 }
    );
  }
}
