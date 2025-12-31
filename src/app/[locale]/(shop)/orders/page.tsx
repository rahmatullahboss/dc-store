"use client";

import { useState, useEffect } from "react";
import { Link } from "@/i18n/routing";
import Image from "next/image";
import { Package, ShoppingBag, Eye, Clock, Truck, CheckCircle, XCircle, ArrowRight, Loader2, RefreshCw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { formatPrice } from "@/lib/config";
import { useSession } from "@/lib/auth-client";
import { useRouter } from "next/navigation";
import { useTranslations } from "next-intl";

interface OrderItem {
  productId: string;
  name: string;
  price: number;
  quantity: number;
  image?: string;
}

interface Order {
  id: string;
  orderNumber: string;
  status: string;
  total: number;
  items: OrderItem[];
  paymentMethod: string;
  createdAt: string;
}

const filterTabs = ["all", "pending", "processing", "shipped", "delivered", "cancelled"];

export default function MyOrdersPage() {
  const t = useTranslations("OrdersPage");
  const { data: session, isPending: isSessionLoading } = useSession();
  const router = useRouter();
  const [orders, setOrders] = useState<Order[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [activeFilter, setActiveFilter] = useState("all");

  const statusConfig = {
    pending: { label: t("status.pending"), color: "bg-yellow-100 text-yellow-800", icon: Clock },
    confirmed: { label: t("status.confirmed"), color: "bg-blue-100 text-blue-800", icon: CheckCircle },
    processing: { label: t("status.processing"), color: "bg-purple-100 text-purple-800", icon: Package },
    shipped: { label: t("status.shipped"), color: "bg-indigo-100 text-indigo-800", icon: Truck },
    delivered: { label: t("status.delivered"), color: "bg-green-100 text-green-800", icon: CheckCircle },
    cancelled: { label: t("status.cancelled"), color: "bg-red-100 text-red-800", icon: XCircle },
    refunded: { label: t("status.refunded"), color: "bg-muted text-foreground", icon: XCircle },
  };

  useEffect(() => {
    async function fetchOrders() {
      if (!session?.user) return;
      
      setIsLoading(true);
      try {
        const res = await fetch("/api/user/orders");
        if (res.ok) {
          const data = await res.json() as { orders: Order[] };
          setOrders(data.orders || []);
        }
      } catch (error) {
        console.error("Failed to fetch orders:", error);
      } finally {
        setIsLoading(false);
      }
    }

    if (session?.user) {
      fetchOrders();
    } else if (!isSessionLoading) {
      router.push("/login?redirect=/orders");
    }
  }, [session, isSessionLoading, router]);

  // Filter orders based on active tab
  const filteredOrders = activeFilter === "all" 
    ? orders 
    : orders.filter(order => order.status.toLowerCase() === activeFilter.toLowerCase());

  if (isSessionLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!session?.user) {
    return null; // Will redirect
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex items-center justify-between mb-8">
          <div>
            <h1 className="text-2xl md:text-3xl font-bold text-foreground mb-2">
              {t("title")}
            </h1>
            <p className="text-muted-foreground">
              {t("subtitle")}
            </p>
          </div>
          <Button 
            variant="outline" 
            size="sm" 
            onClick={() => window.location.reload()}
            className="gap-2"
          >
            <RefreshCw className="h-4 w-4" />
            {t("refresh")}
          </Button>
        </div>

        {/* Filter Tabs */}
        <div className="flex items-center gap-2 overflow-x-auto pb-4 mb-6">
          {filterTabs.map((tab) => (
            <Badge
              key={tab}
              variant={activeFilter === tab ? "default" : "outline"}
              className={`cursor-pointer whitespace-nowrap px-4 py-2 transition-all ${
                activeFilter === tab
                  ? "bg-primary text-white border-0"
                  : "hover:bg-muted"
              }`}
              onClick={() => setActiveFilter(tab)}
            >
              {t(`filters.${tab}` as const)}
              {tab !== "all" && (
                <span className="ml-1 text-xs opacity-70">
                  ({orders.filter(o => o.status.toLowerCase() === tab.toLowerCase()).length})
                </span>
              )}
            </Badge>
          ))}
        </div>

        {/* Loading State */}
        {isLoading ? (
          <div className="bg-card rounded-2xl p-12 shadow-lg border border-border text-center">
            <Loader2 className="h-12 w-12 animate-spin text-primary mx-auto mb-4" />
            <p className="text-muted-foreground">{t("loading")}</p>
          </div>
        ) : filteredOrders.length === 0 ? (
          /* Empty State */
          <div className="bg-card rounded-2xl p-12 shadow-lg border border-border text-center">
            <div className="p-6 bg-gradient-to-br from-amber-100 to-rose-100 rounded-full inline-block mb-6">
              <ShoppingBag className="h-12 w-12 text-primary" />
            </div>
            <h2 className="text-xl font-bold text-foreground mb-2">
              {activeFilter === "all" ? t("empty.title") : t("empty.titleFiltered", { status: t(`filters.${activeFilter}` as const) })}
            </h2>
            <p className="text-muted-foreground mb-6">
              {activeFilter === "all" 
                ? t("empty.desc")
                : t("empty.descFiltered", { status: t(`filters.${activeFilter}` as const) })
              }
            </p>
            {activeFilter === "all" ? (
              <Button 
                className="bg-primary hover:from-amber-600 hover:to-rose-600 text-white rounded-full"
                asChild
              >
                <Link href="/products">
                  {t("empty.action")} <ArrowRight className="ml-2 h-4 w-4" />
                </Link>
              </Button>
            ) : (
              <Button 
                variant="outline"
                onClick={() => setActiveFilter("all")}
              >
                {t("empty.viewAll")}
              </Button>
            )}
          </div>
        ) : (
          /* Orders List */
          <div className="space-y-4">
            {filteredOrders.map((order) => {
              const status = statusConfig[order.status as keyof typeof statusConfig] || statusConfig.pending;
              const StatusIcon = status.icon;
              const firstItem = order.items?.[0];
              const itemCount = order.items?.length || 0;

              return (
                <div
                  key={order.id}
                  className="bg-card rounded-2xl p-4 md:p-6 shadow-lg border border-border hover:shadow-xl transition-shadow"
                >
                  <div className="flex flex-col md:flex-row gap-4">
                    {/* Order Image Preview */}
                    <div className="relative h-20 w-20 md:h-24 md:w-24 flex-shrink-0 rounded-xl bg-muted overflow-hidden">
                      {firstItem?.image ? (
                        <Image
                          src={firstItem.image}
                          alt={firstItem.name}
                          fill
                          className="object-cover"
                        />
                      ) : (
                        <div className="flex h-full items-center justify-center text-muted-foreground">
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
                          <h3 className="font-bold text-foreground">
                            {t("card.orderNumber", { number: order.orderNumber })}
                          </h3>
                          <p className="text-sm text-muted-foreground">
                            {new Date(order.createdAt).toLocaleDateString("en-US", {
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

                      <div className="flex flex-wrap gap-4 text-sm text-muted-foreground mb-4">
                        <span>
                          <strong className="text-foreground">{t("card.items", { count: itemCount })}</strong>
                        </span>
                        <span>
                          {t("card.total")} <strong className="text-primary">{formatPrice(order.total)}</strong>
                        </span>
                        <span>
                          {t("card.payment")} <strong className="text-foreground">
                            {order.paymentMethod === "cod" ? t("card.cod") : order.paymentMethod}
                          </strong>
                        </span>
                      </div>

                      {/* Items Preview */}
                      <div className="text-sm text-muted-foreground line-clamp-1">
                        {order.items?.map((item, i) => (
                          <span key={i}>
                            {item.name} x{item.quantity}
                            {i < (order.items?.length || 0) - 1 ? ", " : ""}
                          </span>
                        ))}
                      </div>
                    </div>

                    {/* Action Buttons */}
                    <div className="flex md:flex-col gap-2 md:items-end md:justify-center">
                      <Button variant="outline" size="sm" className="gap-2" asChild>
                        <Link href={`/orders/${order.id}`}>
                          <Eye className="h-4 w-4" />
                          {t("card.viewDetails")}
                        </Link>
                      </Button>
                      {order.status === "shipped" && (
                        <Button 
                          size="sm" 
                          className="gap-2 bg-primary text-white border-0"
                          asChild
                        >
                          <Link href={`/track-order?order=${order.orderNumber}`}>
                            <Truck className="h-4 w-4" />
                            {t("card.track")}
                          </Link>
                        </Button>
                      )}
                      {order.status === "delivered" && (
                        <Button variant="outline" size="sm" className="gap-2" asChild>
                          <Link href={`/orders/${order.id}?reorder=true`}>
                            <RefreshCw className="h-4 w-4" />
                            {t("card.reorder")}
                          </Link>
                        </Button>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>
        )}

        {/* Order Count Summary */}
        {orders.length > 0 && (
          <div className="mt-6 text-center text-sm text-muted-foreground">
            {t("summary", { shown: filteredOrders.length, total: orders.length })}
          </div>
        )}

        {/* Help Section */}
        <div className="mt-12 bg-gradient-to-r from-amber-50 to-rose-50 rounded-2xl p-6 md:p-8">
          <h2 className="text-lg font-bold text-foreground mb-2">{t("help.title")}</h2>
          <p className="text-muted-foreground mb-4">
            {t("help.desc")}
          </p>
          <div className="flex flex-wrap gap-3">
            <Button variant="outline" className="rounded-full" asChild>
              <Link href="tel:+8801570260118">📞 {t("help.call")}</Link>
            </Button>
            <Button 
              variant="outline" 
              className="rounded-full"
              onClick={() => window.dispatchEvent(new CustomEvent("open-chatbot"))}
            >
              💬 {t("help.chat")}
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
