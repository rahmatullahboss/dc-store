import { NextRequest, NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { orders } from "@/db/schema";
import { eq, and } from "drizzle-orm";
import { headers } from "next/headers";
import type { OrderItem, Address } from "@/db/schema";

export const dynamic = "force-dynamic";

// GET - Generate invoice HTML for an order
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { id: orderId } = await params;

    if (!orderId) {
      return NextResponse.json(
        { error: "Order ID is required" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    // Fetch order (only if it belongs to the user)
    const order = await db.query.orders.findFirst({
      where: and(
        eq(orders.id, orderId),
        eq(orders.userId, session.user.id)
      ),
    });

    if (!order) {
      return NextResponse.json(
        { error: "Order not found" },
        { status: 404 }
      );
    }

    const items = order.items as OrderItem[];
    const shippingAddress = order.shippingAddress as Address | null;

    // Generate invoice HTML
    const invoiceHtml = generateInvoiceHtml(order, items, shippingAddress);

    // Return as HTML for print/PDF
    return new NextResponse(invoiceHtml, {
      headers: {
        "Content-Type": "text/html; charset=utf-8",
      },
    });
  } catch (error) {
    console.error("Error generating invoice:", error);
    return NextResponse.json(
      { error: "Failed to generate invoice" },
      { status: 500 }
    );
  }
}

function generateInvoiceHtml(
  order: typeof orders.$inferSelect,
  items: OrderItem[],
  shippingAddress: Address | null
): string {
  const formatDate = (date: Date | null) => {
    if (!date) return "N/A";
    return new Date(date).toLocaleDateString("en-US", {
      year: "numeric",
      month: "long",
      day: "numeric",
    });
  };

  const formatCurrency = (amount: number) => {
    return `৳${amount.toLocaleString("en-US", { minimumFractionDigits: 2 })}`;
  };

  return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Invoice - ${order.orderNumber}</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      line-height: 1.6;
      color: #333;
      background: #fff;
      padding: 40px;
      max-width: 800px;
      margin: 0 auto;
    }
    .header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 40px;
      border-bottom: 2px solid #f97316;
      padding-bottom: 20px;
    }
    .logo {
      font-size: 28px;
      font-weight: bold;
      color: #f97316;
    }
    .invoice-info {
      text-align: right;
    }
    .invoice-number {
      font-size: 24px;
      font-weight: bold;
      color: #333;
    }
    .invoice-date {
      color: #666;
      margin-top: 5px;
    }
    .addresses {
      display: flex;
      justify-content: space-between;
      margin-bottom: 40px;
    }
    .address-block {
      width: 45%;
    }
    .address-block h3 {
      font-size: 14px;
      color: #666;
      margin-bottom: 10px;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .address-block p {
      margin-bottom: 5px;
    }
    .items-table {
      width: 100%;
      border-collapse: collapse;
      margin-bottom: 30px;
    }
    .items-table th {
      background: #f8f8f8;
      padding: 12px;
      text-align: left;
      font-weight: 600;
      border-bottom: 2px solid #ddd;
    }
    .items-table td {
      padding: 12px;
      border-bottom: 1px solid #eee;
    }
    .items-table .qty {
      text-align: center;
    }
    .items-table .price {
      text-align: right;
    }
    .summary {
      margin-left: auto;
      width: 300px;
    }
    .summary-row {
      display: flex;
      justify-content: space-between;
      padding: 8px 0;
      border-bottom: 1px solid #eee;
    }
    .summary-row.total {
      border-bottom: none;
      border-top: 2px solid #333;
      font-size: 18px;
      font-weight: bold;
      padding-top: 15px;
      margin-top: 10px;
    }
    .footer {
      margin-top: 60px;
      text-align: center;
      color: #666;
      font-size: 14px;
      border-top: 1px solid #eee;
      padding-top: 20px;
    }
    .status-badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      text-transform: uppercase;
      background: #dcfce7;
      color: #166534;
    }
    @media print {
      body {
        padding: 20px;
      }
      .no-print {
        display: none;
      }
    }
  </style>
</head>
<body>
  <div class="header">
    <div>
      <div class="logo">DC Store</div>
      <p style="color: #666; margin-top: 5px;">Your Trusted Shopping Partner</p>
    </div>
    <div class="invoice-info">
      <div class="invoice-number">Invoice #${order.orderNumber}</div>
      <div class="invoice-date">${formatDate(order.createdAt)}</div>
      <div style="margin-top: 10px;">
        <span class="status-badge">${order.status?.toUpperCase() || "PENDING"}</span>
      </div>
    </div>
  </div>

  <div class="addresses">
    <div class="address-block">
      <h3>Bill To</h3>
      <p><strong>${order.customerName}</strong></p>
      ${order.customerEmail ? `<p>${order.customerEmail}</p>` : ""}
      <p>${order.customerPhone}</p>
    </div>
    <div class="address-block">
      <h3>Ship To</h3>
      ${shippingAddress ? `
        <p><strong>${shippingAddress.name}</strong></p>
        <p>${shippingAddress.address}</p>
        <p>${shippingAddress.city}${shippingAddress.postalCode ? `, ${shippingAddress.postalCode}` : ""}</p>
        <p>${shippingAddress.country}</p>
        <p>${shippingAddress.phone}</p>
      ` : "<p>Same as billing address</p>"}
    </div>
  </div>

  <table class="items-table">
    <thead>
      <tr>
        <th>Item</th>
        <th class="qty">Qty</th>
        <th class="price">Price</th>
        <th class="price">Total</th>
      </tr>
    </thead>
    <tbody>
      ${items.map((item) => `
        <tr>
          <td>${item.name}</td>
          <td class="qty">${item.quantity}</td>
          <td class="price">${formatCurrency(item.price)}</td>
          <td class="price">${formatCurrency(item.total)}</td>
        </tr>
      `).join("")}
    </tbody>
  </table>

  <div class="summary">
    <div class="summary-row">
      <span>Subtotal</span>
      <span>${formatCurrency(order.subtotal)}</span>
    </div>
    ${order.discount && order.discount > 0 ? `
      <div class="summary-row">
        <span>Discount</span>
        <span>-${formatCurrency(order.discount)}</span>
      </div>
    ` : ""}
    <div class="summary-row">
      <span>Shipping</span>
      <span>${order.shippingCost === 0 ? "Free" : formatCurrency(order.shippingCost || 0)}</span>
    </div>
    ${order.tax && order.tax > 0 ? `
      <div class="summary-row">
        <span>Tax</span>
        <span>${formatCurrency(order.tax)}</span>
      </div>
    ` : ""}
    <div class="summary-row total">
      <span>Total</span>
      <span>${formatCurrency(order.total)}</span>
    </div>
  </div>

  <div class="footer">
    <p>Thank you for shopping with DC Store!</p>
    <p style="margin-top: 10px;">Payment Method: ${order.paymentMethod || "Cash on Delivery"}</p>
    <p style="margin-top: 20px; font-size: 12px; color: #999;">
      This is a computer-generated invoice. No signature required.
    </p>
  </div>

  <div class="no-print" style="text-align: center; margin-top: 40px;">
    <button onclick="window.print()" style="
      background: #f97316;
      color: white;
      border: none;
      padding: 12px 30px;
      font-size: 16px;
      border-radius: 8px;
      cursor: pointer;
    ">
      Print Invoice / Save as PDF
    </button>
  </div>
</body>
</html>
  `;
}
