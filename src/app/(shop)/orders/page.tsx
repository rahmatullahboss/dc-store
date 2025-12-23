import Link from "next/link";
import Image from "next/image";
import { Package, ShoppingBag, Eye, Clock, Truck, CheckCircle, XCircle, ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { getDatabase } from "@/lib/cloudflare";
import { getAuth } from "@/lib/cloudflare";
import { orders } from "@/db/schema";
import { eq, desc } from "drizzle-orm";
import { formatPrice } from "@/lib/config";
import { headers } from "next/headers";
import { redirect } from "next/navigation";

// Force dynamic rendering for Cloudflare context
export const dynamic = "force-dynamic";

const statusConfig = {
  pending: { label: "Pending", color: "bg-yellow-100 text-yellow-800", icon: Clock },
  confirmed: { label: "Confirmed", color: "bg-blue-100 text-blue-800", icon: CheckCircle },
  processing: { label: "Processing", color: "bg-purple-100 text-purple-800", icon: Package },
  shipped: { label: "Shipped", color: "bg-indigo-100 text-indigo-800", icon: Truck },
  delivered: { label: "Delivered", color: "bg-green-100 text-green-800", icon: CheckCircle },
  cancelled: { label: "Cancelled", color: "bg-red-100 text-red-800", icon: XCircle },
  refunded: { label: "Refunded", color: "bg-gray-100 text-gray-800", icon: XCircle },
};

export const metadata = {
  title: "My Orders",
  description: "View your order history",
};

export default async function MyOrdersPage() {
  const auth = await getAuth();
  const headersList = await headers();
  const session = await auth.api.getSession({ headers: headersList });

  if (!session?.user) {
    redirect("/login?redirect=/orders");
  }

  const db = await getDatabase();
  const userOrders = await db.query.orders.findMany({
    where: eq(orders.userId, session.user.id),
    orderBy: [desc(orders.createdAt)],
  });

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-stone-100">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-2xl md:text-3xl font-bold text-gray-800 mb-2">
            My Orders
          </h1>
          <p className="text-gray-600">
            Track and manage your orders
          </p>
        </div>

        {/* Filter Tabs */}
        <div className="flex items-center gap-2 overflow-x-auto pb-4 mb-6">
          {["All", "Pending", "Processing", "Shipped", "Delivered", "Cancelled"].map((tab) => (
            <Badge
              key={tab}
              variant={tab === "All" ? "default" : "outline"}
              className={`cursor-pointer whitespace-nowrap px-4 py-2 ${
                tab === "All"
                  ? "bg-gradient-to-r from-amber-500 to-rose-500 text-white border-0"
                  : "hover:bg-gray-100"
              }`}
            >
              {tab}
            </Badge>
          ))}
        </div>

        {/* Orders List */}
        {userOrders.length === 0 ? (
          <div className="bg-white rounded-2xl p-12 shadow-lg border border-gray-100 text-center">
            <div className="p-6 bg-gradient-to-br from-amber-100 to-rose-100 rounded-full inline-block mb-6">
              <ShoppingBag className="h-12 w-12 text-amber-600" />
            </div>
            <h2 className="text-xl font-bold text-gray-800 mb-2">No orders yet</h2>
            <p className="text-gray-600 mb-6">
              Start shopping to see your orders here
            </p>
            <Button 
              className="bg-gradient-to-r from-amber-500 to-rose-500 hover:from-amber-600 hover:to-rose-600 text-white rounded-full"
              asChild
            >
              <Link href="/products">
                Start Shopping <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </Button>
          </div>
        ) : (
          <div className="space-y-4">
            {userOrders.map((order) => {
              const status = statusConfig[order.status as keyof typeof statusConfig] || statusConfig.pending;
              const StatusIcon = status.icon;
              const firstItem = order.items?.[0];
              const itemCount = order.items?.length || 0;

              return (
                <div
                  key={order.id}
                  className="bg-white rounded-2xl p-4 md:p-6 shadow-lg border border-gray-100 hover:shadow-xl transition-shadow"
                >
                  <div className="flex flex-col md:flex-row gap-4">
                    {/* Order Image Preview */}
                    <div className="relative h-20 w-20 md:h-24 md:w-24 flex-shrink-0 rounded-xl bg-gray-100 overflow-hidden">
                      {firstItem?.image ? (
                        <Image
                          src={firstItem.image}
                          alt={firstItem.name}
                          fill
                          className="object-cover"
                        />
                      ) : (
                        <div className="flex h-full items-center justify-center text-gray-400">
                          <Package className="h-8 w-8" />
                        </div>
                      )}
                      {itemCount > 1 && (
                        <div className="absolute bottom-1 right-1 bg-black/70 text-white text-xs px-2 py-0.5 rounded-full">
                          +{itemCount - 1}
                        </div>
                      )}
                    </div>

                    {/* Order Info */}
                    <div className="flex-1 min-w-0">
                      <div className="flex flex-col md:flex-row md:items-start md:justify-between gap-2 mb-3">
                        <div>
                          <h3 className="font-bold text-gray-800">
                            Order #{order.orderNumber}
                          </h3>
                          <p className="text-sm text-gray-500">
                            {new Date(order.createdAt!).toLocaleDateString("en-US", {
                              year: "numeric",
                              month: "short",
                              day: "numeric",
                            })}
                          </p>
                        </div>
                        <Badge className={`${status.color} gap-1 self-start`}>
                          <StatusIcon className="h-3 w-3" />
                          {status.label}
                        </Badge>
                      </div>

                      <div className="flex flex-wrap gap-4 text-sm text-gray-600 mb-4">
                        <span>
                          <strong className="text-gray-800">{itemCount}</strong> items
                        </span>
                        <span>
                          Total: <strong className="text-amber-600">{formatPrice(order.total)}</strong>
                        </span>
                        <span>
                          Payment: <strong className="text-gray-800">
                            {order.paymentMethod === "cod" ? "Cash on Delivery" : order.paymentMethod}
                          </strong>
                        </span>
                      </div>

                      {/* Items Preview */}
                      <div className="text-sm text-gray-600 line-clamp-1">
                        {order.items?.map((item, i) => (
                          <span key={i}>
                            {item.name} x{item.quantity}
                            {i < (order.items?.length || 0) - 1 ? ", " : ""}
                          </span>
                        ))}
                      </div>
                    </div>

                    {/* Action Button */}
                    <div className="flex md:flex-col gap-2 md:items-end md:justify-center">
                      <Button variant="outline" size="sm" className="gap-2">
                        <Eye className="h-4 w-4" />
                        View Details
                      </Button>
                      {order.status === "shipped" && (
                        <Button size="sm" className="gap-2 bg-gradient-to-r from-amber-500 to-rose-500 text-white border-0">
                          <Truck className="h-4 w-4" />
                          Track
                        </Button>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* Help Section */}
        <div className="mt-12 bg-gradient-to-r from-amber-50 to-rose-50 rounded-2xl p-6 md:p-8">
          <h2 className="text-lg font-bold text-gray-800 mb-2">Need Help?</h2>
          <p className="text-gray-600 mb-4">
            Have questions about your order? We&apos;re here to help!
          </p>
          <div className="flex flex-wrap gap-3">
            <Button variant="outline" className="rounded-full">
              📞 Call Support
            </Button>
            <Button variant="outline" className="rounded-full">
              💬 Chat with Us
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
