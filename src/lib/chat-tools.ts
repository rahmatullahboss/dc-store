import { z } from "zod";
import { tool } from "ai";
import { getDatabase } from "@/lib/cloudflare";
import { orders, supportTickets } from "@/db/schema";
import { eq, desc } from "drizzle-orm";
import { nanoid } from "nanoid";

// Tool types for chat
export type ChatToolsContext = {
  userId: string | null;
  userName: string | null;
  userPhone: string | null;
  userEmail: string | null;
};

// Generate unique ticket number
function generateTicketNumber(): string {
  const date = new Date();
  const dateStr = date.toISOString().slice(0, 10).replace(/-/g, "");
  const random = Math.random().toString(36).substring(2, 6).toUpperCase();
  return `TKT-${dateStr}-${random}`;
}

// Format order status in Bengali/English
function formatOrderStatus(status: string, isBengali: boolean): string {
  const statusMap: Record<string, { bn: string; en: string }> = {
    pending: { bn: "অপেক্ষমাণ", en: "Pending" },
    confirmed: { bn: "নিশ্চিত", en: "Confirmed" },
    processing: { bn: "প্রসেসিং", en: "Processing" },
    shipped: { bn: "শিপড", en: "Shipped" },
    delivered: { bn: "ডেলিভার্ড", en: "Delivered" },
    cancelled: { bn: "বাতিল", en: "Cancelled" },
    refunded: { bn: "রিফান্ড", en: "Refunded" },
  };
  return statusMap[status]?.[isBengali ? "bn" : "en"] || status;
}

// Create AI tools for customer support
export function createChatTools(context: ChatToolsContext, locale: string = "en") {
  const isBengali = locale === "bn";

  return {
    // Tool 1: Get customer's recent orders
    getCustomerOrders: tool({
      description: isBengali
        ? "Customer এর সাম্প্রতিক orders দেখায়। শুধুমাত্র logged-in user দের জন্য কাজ করে।"
        : "Shows customer's recent orders. Only works for logged-in users.",
      inputSchema: z.object({
        limit: z
          .number()
          .min(1)
          .max(10)
          .default(5)
          .describe("Number of orders to fetch (max 10)"),
      }),
      execute: async ({ limit }) => {
        if (!context.userId) {
          return {
            success: false,
            message: isBengali
              ? "আপনার orders দেখতে প্রথমে login করুন।"
              : "Please login to view your orders.",
          };
        }

        try {
          const db = await getDatabase();
          const userOrders = await db
            .select({
              id: orders.id,
              orderNumber: orders.orderNumber,
              status: orders.status,
              total: orders.total,
              currency: orders.currency,
              itemCount: orders.items,
              createdAt: orders.createdAt,
            })
            .from(orders)
            .where(eq(orders.userId, context.userId))
            .orderBy(desc(orders.createdAt))
            .limit(limit);

          if (userOrders.length === 0) {
            return {
              success: true,
              message: isBengali
                ? "আপনার কোনো order নেই।"
                : "You don't have any orders yet.",
              orders: [],
            };
          }

          const formattedOrders = userOrders.map((order) => ({
            orderNumber: order.orderNumber,
            status: formatOrderStatus(order.status || "pending", isBengali),
            total: `${order.currency || "BDT"} ${order.total}`,
            itemCount: Array.isArray(order.itemCount) ? order.itemCount.length : 0,
            date: order.createdAt
              ? new Date(order.createdAt).toLocaleDateString(isBengali ? "bn-BD" : "en-US")
              : "N/A",
          }));

          return {
            success: true,
            message: isBengali
              ? `আপনার সাম্প্রতিক ${formattedOrders.length}টি order:`
              : `Your recent ${formattedOrders.length} orders:`,
            orders: formattedOrders,
          };
        } catch (error) {
          console.error("Error fetching orders:", error);
          return {
            success: false,
            message: isBengali
              ? "Orders লোড করতে সমস্যা হয়েছে।"
              : "Failed to load orders.",
          };
        }
      },
    }),

    // Tool 2: Get specific order status
    getOrderStatus: tool({
      description: isBengali
        ? "নির্দিষ্ট order এর status দেখায়। Order number দিয়ে খুঁজে।"
        : "Shows status of a specific order by order number.",
      inputSchema: z.object({
        orderNumber: z
          .string()
          .describe("The order number to check, e.g., ORD-2024-XXXXX"),
      }),
      execute: async ({ orderNumber }) => {
        if (!context.userId) {
          return {
            success: false,
            message: isBengali
              ? "Order status দেখতে প্রথমে login করুন।"
              : "Please login to check order status.",
          };
        }

        try {
          const db = await getDatabase();
          const [order] = await db
            .select({
              id: orders.id,
              orderNumber: orders.orderNumber,
              status: orders.status,
              paymentStatus: orders.paymentStatus,
              total: orders.total,
              currency: orders.currency,
              shippingAddress: orders.shippingAddress,
              items: orders.items,
              createdAt: orders.createdAt,
              userId: orders.userId,
            })
            .from(orders)
            .where(eq(orders.orderNumber, orderNumber.toUpperCase()))
            .limit(1);

          if (!order) {
            return {
              success: false,
              message: isBengali
                ? `Order #${orderNumber} পাওয়া যায়নি।`
                : `Order #${orderNumber} not found.`,
            };
          }

          // Privacy check: Only show order if it belongs to the user
          if (order.userId !== context.userId) {
            return {
              success: false,
              message: isBengali
                ? "এই order টি আপনার নয়।"
                : "This order does not belong to you.",
            };
          }

          const shippingAddr = order.shippingAddress as { city?: string; address?: string } | null;

          return {
            success: true,
            order: {
              orderNumber: order.orderNumber,
              status: formatOrderStatus(order.status || "pending", isBengali),
              paymentStatus: order.paymentStatus,
              total: `${order.currency || "BDT"} ${order.total}`,
              itemCount: Array.isArray(order.items) ? order.items.length : 0,
              shippingCity: shippingAddr?.city || "N/A",
              orderDate: order.createdAt
                ? new Date(order.createdAt).toLocaleDateString(isBengali ? "bn-BD" : "en-US")
                : "N/A",
            },
          };
        } catch (error) {
          console.error("Error fetching order status:", error);
          return {
            success: false,
            message: isBengali
              ? "Order status লোড করতে সমস্যা হয়েছে।"
              : "Failed to load order status.",
          };
        }
      },
    }),

    // Tool 3: Create support ticket
    createSupportTicket: tool({
      description: isBengali
        ? "Customer complaint বা সমস্যার জন্য support ticket তৈরি করে।"
        : "Creates a support ticket for customer complaints or issues.",
      inputSchema: z.object({
        category: z
          .enum([
            "order_issue",
            "payment_issue",
            "delivery_issue",
            "product_issue",
            "refund_request",
            "other",
          ])
          .describe(
            "Category of the issue: order_issue, payment_issue, delivery_issue, product_issue, refund_request, or other"
          ),
        subject: z
          .string()
          .min(5)
          .max(200)
          .describe("Brief subject/title of the issue"),
        description: z
          .string()
          .min(10)
          .max(1000)
          .describe("Detailed description of the issue"),
        orderId: z
          .string()
          .optional()
          .describe("Related order ID if applicable"),
      }),
      execute: async ({ category, subject, description, orderId }) => {
        // Allow both logged-in users and guests with phone to create tickets
        const customerName = context.userName || "Guest";
        const customerPhone = context.userPhone;
        const customerEmail = context.userEmail;

        if (!customerPhone && !context.userId) {
          return {
            success: false,
            message: isBengali
              ? "Ticket তৈরি করতে আপনার phone number বা login প্রয়োজন।"
              : "Please provide your phone number or login to create a ticket.",
          };
        }

        try {
          const db = await getDatabase();
          const ticketNumber = generateTicketNumber();
          const ticketId = nanoid();

          // If orderId provided, verify it belongs to the user
          let validOrderId: string | null = null;
          if (orderId && context.userId) {
            const [order] = await db
              .select({ id: orders.id, userId: orders.userId })
              .from(orders)
              .where(eq(orders.id, orderId))
              .limit(1);

            if (order && order.userId === context.userId) {
              validOrderId = order.id;
            }
          }

          await db.insert(supportTickets).values({
            id: ticketId,
            ticketNumber,
            userId: context.userId,
            orderId: validOrderId,
            category,
            subject,
            description,
            status: "open",
            priority: category === "refund_request" ? "high" : "medium",
            customerName,
            customerEmail,
            customerPhone,
          });

          const categoryLabels: Record<string, { bn: string; en: string }> = {
            order_issue: { bn: "অর্ডার সমস্যা", en: "Order Issue" },
            payment_issue: { bn: "পেমেন্ট সমস্যা", en: "Payment Issue" },
            delivery_issue: { bn: "ডেলিভারি সমস্যা", en: "Delivery Issue" },
            product_issue: { bn: "প্রোডাক্ট সমস্যা", en: "Product Issue" },
            refund_request: { bn: "রিফান্ড অনুরোধ", en: "Refund Request" },
            other: { bn: "অন্যান্য", en: "Other" },
          };

          return {
            success: true,
            ticketNumber,
            category: categoryLabels[category]?.[isBengali ? "bn" : "en"] || category,
            message: isBengali
              ? `আপনার ticket সফলভাবে তৈরি হয়েছে! Ticket Number: ${ticketNumber}। আমাদের টিম শীঘ্রই আপনার সাথে যোগাযোগ করবে।`
              : `Your ticket has been created successfully! Ticket Number: ${ticketNumber}. Our team will contact you soon.`,
          };
        } catch (error) {
          console.error("Error creating ticket:", error);
          return {
            success: false,
            message: isBengali
              ? "Ticket তৈরি করতে সমস্যা হয়েছে। পরে আবার চেষ্টা করুন।"
              : "Failed to create ticket. Please try again later.",
          };
        }
      },
    }),
  };
}
