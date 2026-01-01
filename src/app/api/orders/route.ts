import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { orders, sessions, products } from "@/db/schema";
import type { OrderItem, Address } from "@/db/schema";
import { eq, sql } from "drizzle-orm";
import { nanoid } from "nanoid";
import { headers } from "next/headers";
import { sendOrderConfirmationEmail } from "@/lib/email";
import { serverEvents } from "@/lib/facebook-capi";

// Using default runtime for OpenNext compatibility

interface CreateOrderRequest {
  items: OrderItem[];
  subtotal: number;
  shippingCost: number;
  total: number;
  customerName: string;
  customerPhone: string;
  customerEmail?: string | null;
  shippingAddress: Address;
  notes?: string | null;
  paymentMethod: string;
  paymentStatus?: string;
}

export async function POST(request: Request) {
  try {
    const body: CreateOrderRequest = await request.json();

    // Validate required fields
    if (!body.items?.length || !body.customerName || !body.customerPhone || !body.shippingAddress) {
      return NextResponse.json(
        { error: "Missing required fields" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    // Validate stock availability for all items before creating order
    for (const item of body.items) {
      const product = await db
        .select({ quantity: products.quantity, name: products.name })
        .from(products)
        .where(eq(products.id, item.productId))
        .then((rows) => rows[0]);

      if (!product) {
        return NextResponse.json(
          { error: `Product not found: ${item.name || item.productId}` },
          { status: 404 }
        );
      }

      if ((product.quantity ?? 0) < item.quantity) {
        return NextResponse.json(
          {
            error: "Insufficient stock",
            details: {
              productName: product.name,
              requested: item.quantity,
              available: product.quantity ?? 0,
            },
          },
          { status: 400 }
        );
      }
    }

    // Get current user session - check Bearer token first (mobile app), then cookie (web)
    let userId: string | null = null;
    
    // First try Bearer token (for mobile app)
    const authHeader = request.headers.get("authorization");
    if (authHeader?.startsWith("Bearer ")) {
      const token = authHeader.slice(7);
      const session = await db
        .select()
        .from(sessions)
        .where(eq(sessions.token, token))
        .then((rows) => rows[0]);

      if (session && new Date(session.expiresAt) >= new Date()) {
        userId = session.userId;
      }
    }
    
    // Fallback to cookie-based session (for web)
    if (!userId) {
      try {
        const auth = await getAuth();
        const headersList = await headers();
        const session = await auth.api.getSession({ headers: headersList });
        if (session?.user?.id) {
          userId = session.user.id;
        }
      } catch {
        // User is not logged in, proceed with guest checkout
      }
    }

    // Generate order number
    const orderNumber = `DC${Date.now().toString().slice(-8)}${Math.random().toString(36).slice(-4).toUpperCase()}`;
    const orderId = nanoid();

    // Determine payment status and order status
    const paymentStatus = body.paymentStatus || "pending";
    // For paid orders (Stripe), set status to confirmed; for COD, set to pending
    const orderStatus = paymentStatus === "paid" ? "confirmed" : "pending";

    // Create order with userId
    const newOrder = {
      id: orderId,
      orderNumber,
      userId, // Link order to user if logged in
      status: orderStatus as "pending" | "confirmed",
      paymentStatus: paymentStatus as "pending" | "paid" | "failed",
      paymentMethod: body.paymentMethod || "cod",
      subtotal: body.subtotal,
      discount: 0,
      shippingCost: body.shippingCost,
      tax: 0,
      total: body.total,
      currency: "BDT",
      customerName: body.customerName,
      customerEmail: body.customerEmail || null,
      customerPhone: body.customerPhone,
      shippingAddress: body.shippingAddress,
      billingAddress: body.shippingAddress,
      notes: body.notes || null,
      items: body.items,
    };

    await db.insert(orders).values(newOrder);

    // Reduce stock for each product in the order
    for (const item of body.items) {
      await db
        .update(products)
        .set({
          quantity: sql`MAX(COALESCE(${products.quantity}, 0) - ${item.quantity}, 0)`,
          updatedAt: new Date(),
        })
        .where(eq(products.id, item.productId));
    }

    console.log(`Stock reduced for order: ${orderNumber}, items: ${body.items.length}`);

    // Send Facebook Conversions API Purchase event (server-side tracking)
    try {
      const nameParts = body.customerName.split(" ");
      await serverEvents.purchase({
        orderId: orderNumber,
        value: body.total,
        contentIds: body.items.map((item) => item.productId),
        numItems: body.items.reduce((sum, item) => sum + item.quantity, 0),
        userData: {
          email: body.customerEmail || undefined,
          phone: body.customerPhone,
          firstName: nameParts[0],
          lastName: nameParts.slice(1).join(" ") || undefined,
          city: body.shippingAddress.city,
          state: body.shippingAddress.state,
          country: body.shippingAddress.country || "BD",
          externalId: userId || undefined,
          clientIpAddress: request.headers.get("x-forwarded-for") || request.headers.get("x-real-ip") || undefined,
          clientUserAgent: request.headers.get("user-agent") || undefined,
        },
        eventSourceUrl: request.headers.get("referer") || undefined,
      });
    } catch (capiError) {
      // Don't fail the order if CAPI fails
      console.error("Facebook CAPI error:", capiError);
    }

    // Send order confirmation email
    if (body.customerEmail) {
      try {
        const emailResult = await sendOrderConfirmationEmail({
          orderNumber,
          customerName: body.customerName,
          customerEmail: body.customerEmail,
          customerPhone: body.customerPhone,
          items: body.items,
          subtotal: body.subtotal,
          shippingCost: body.shippingCost,
          total: body.total,
          shippingAddress: body.shippingAddress,
          paymentMethod: body.paymentMethod || 'cod',
        });
        if (!emailResult.success) {
          console.warn(`Email send failed for order ${orderNumber}: ${emailResult.error}`);
        }
      } catch (err) {
        console.error(`Email error for order ${orderNumber}:`, err);
      }
    }

    console.log(`Order created: ${orderNumber}`);

    return NextResponse.json({
      success: true,
      order: {
        id: orderId,
        orderNumber,
      },
    });
  } catch (error) {
    console.error("Error creating order:", error);
    return NextResponse.json(
      { error: "Failed to create order" },
      { status: 500 }
    );
  }
}
