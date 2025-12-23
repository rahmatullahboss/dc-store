import { NextResponse } from "next/server";
import { getDatabase } from "@/lib/cloudflare";
import { orders } from "@/db/schema";
import type { OrderItem, Address } from "@/db/schema";
import { nanoid } from "nanoid";

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

    // Generate order number
    const orderNumber = `DC${Date.now().toString().slice(-8)}${Math.random().toString(36).slice(-4).toUpperCase()}`;
    const orderId = nanoid();

    // Create order
    const newOrder = {
      id: orderId,
      orderNumber,
      status: "pending" as const,
      paymentStatus: "pending" as const,
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
