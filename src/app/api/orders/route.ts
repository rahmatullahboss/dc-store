import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { orders } from "@/db/schema";
import type { OrderItem, Address } from "@/db/schema";
import { nanoid } from "nanoid";
import { headers } from "next/headers";
import { sendOrderConfirmationEmail } from "@/lib/email";

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

    // Get current user session if logged in
    let userId: string | null = null;
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

    // Send order confirmation email (non-blocking)
    console.log(`[Email] Attempting to send confirmation for order ${orderNumber} to ${body.customerEmail || 'NO EMAIL'}`);
    
    if (body.customerEmail) {
      try {
        console.log('[Email] Calling sendOrderConfirmationEmail...');
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
        console.log('[Email] sendOrderConfirmationEmail result:', emailResult);
      } catch (err) {
        console.error('[Email] Failed to send email:', err);
      }
    } else {
      console.log('[Email] No customer email provided, skipping email');
    }

    console.log(`Order created: ${orderNumber} for ${body.customerEmail || body.customerPhone}`);

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
