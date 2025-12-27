import { NextRequest, NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { wishlist } from "@/db/schema";
import { eq, and } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

// DELETE - Remove product from wishlist
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ productId: string }> }
) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { productId } = await params;

    if (!productId) {
      return NextResponse.json(
        { error: "Product ID is required" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    await db
      .delete(wishlist)
      .where(
        and(
          eq(wishlist.userId, session.user.id),
          eq(wishlist.productId, productId)
        )
      );

    return NextResponse.json({
      success: true,
      message: "Removed from wishlist",
    });
  } catch (error) {
    console.error("Error removing from wishlist:", error);
    return NextResponse.json(
      { error: "Failed to remove from wishlist" },
      { status: 500 }
    );
  }
}
