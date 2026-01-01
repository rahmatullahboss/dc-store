import { NextResponse } from "next/server";
import { getDatabase } from "@/lib/cloudflare";
import { coupons } from "@/db/schema";
import { eq } from "drizzle-orm";

/**
 * POST /api/coupons/validate - Validate a coupon code
 * Request: { code: string, cartTotal: number }
 * Response: { valid: boolean, discount: number, ... }
 */
export async function POST(request: Request) {
  try {
    const body = await request.json() as { code?: string; cartTotal?: number };
    const { code, cartTotal = 0 } = body;

    if (!code) {
      return NextResponse.json(
        { valid: false, error: "Coupon code is required" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    // Find coupon by code (case-insensitive)
    const coupon = await db
      .select()
      .from(coupons)
      .where(eq(coupons.code, code.toUpperCase()))
      .then((rows) => rows[0]);

    if (!coupon) {
      return NextResponse.json({
        valid: false,
        error: "Invalid coupon code",
      });
    }

    // Check if coupon is active
    if (!coupon.isActive) {
      return NextResponse.json({
        valid: false,
        error: "This coupon is no longer active",
      });
    }

    // Check start date
    if (coupon.startsAt && new Date() < new Date(coupon.startsAt)) {
      return NextResponse.json({
        valid: false,
        error: "This coupon is not yet active",
      });
    }

    // Check expiry date
    if (coupon.expiresAt && new Date() > new Date(coupon.expiresAt)) {
      return NextResponse.json({
        valid: false,
        error: "This coupon has expired",
      });
    }

    // Check usage limit
    if (coupon.usageLimit && (coupon.usedCount ?? 0) >= coupon.usageLimit) {
      return NextResponse.json({
        valid: false,
        error: "This coupon has reached its usage limit",
      });
    }

    // Check minimum order amount
    if (coupon.minOrderAmount && cartTotal < coupon.minOrderAmount) {
      return NextResponse.json({
        valid: false,
        error: `Minimum order amount is ৳${coupon.minOrderAmount}`,
        minOrderAmount: coupon.minOrderAmount,
      });
    }

    // Calculate discount
    let discount = 0;
    if (coupon.discountType === "percentage") {
      discount = (cartTotal * coupon.discountValue) / 100;
      // Apply max discount cap if set
      if (coupon.maxDiscount && discount > coupon.maxDiscount) {
        discount = coupon.maxDiscount;
      }
    } else {
      // Fixed discount
      discount = coupon.discountValue;
    }

    // Discount cannot exceed cart total
    if (discount > cartTotal) {
      discount = cartTotal;
    }

    return NextResponse.json({
      valid: true,
      couponId: coupon.id,
      code: coupon.code,
      description: coupon.description,
      discountType: coupon.discountType,
      discountValue: coupon.discountValue,
      discount: Math.round(discount * 100) / 100, // Rounded to 2 decimal places
      newTotal: Math.round((cartTotal - discount) * 100) / 100,
    });
  } catch (error) {
    console.error("Coupon validation error:", error);
    return NextResponse.json(
      { valid: false, error: "Failed to validate coupon" },
      { status: 500 }
    );
  }
}
