"use client";

import { useState } from "react";
import { Link } from "@/i18n/routing";
import { Search, Package, Truck, CheckCircle, Clock, MapPin, ArrowRight, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import type { Order, OrderItem } from "@/db/schema";
import { useTranslations } from "next-intl";

// Timeline status order
const timelineStatuses = ["pending", "confirmed", "processing", "shipped", "delivered"];

export default function TrackOrderClient() {
  const t = useTranslations("TrackOrder");
  const [orderNumber, setOrderNumber] = useState("");
  const [isSearching, setIsSearching] = useState(false);
  const [foundOrder, setFoundOrder] = useState<Order | null>(null);
  const [error, setError] = useState("");

  const statusConfig: Record<string, { label: string; icon: typeof Package; color: string }> = {
    pending: { label: t("status.pending"), icon: Package, color: "text-blue-500" },
    confirmed: { label: t("status.confirmed"), icon: CheckCircle, color: "text-green-500" },
    processing: { label: t("status.processing"), icon: Clock, color: "text-primary" },
    shipped: { label: t("status.shipped"), icon: Truck, color: "text-purple-500" },
    delivered: { label: t("status.delivered"), icon: CheckCircle, color: "text-green-600" },
    cancelled: { label: t("status.cancelled"), icon: Package, color: "text-red-500" },
    refunded: { label: t("status.refunded"), icon: Package, color: "text-muted-foreground" },
  };

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    
    if (!orderNumber.trim()) {
      setError(t("form.error.required"));
      return;
    }

    setIsSearching(true);

    try {
      const response = await fetch(`/api/orders/track?orderNumber=${encodeURIComponent(orderNumber.trim())}`);
      const data = await response.json() as { order?: Order; error?: string };

      if (response.ok && data.order) {
        setFoundOrder(data.order);
        setError("");
      } else {
        setFoundOrder(null);
        setError(data.error || t("form.error.notFound"));
      }
    } catch {
      setFoundOrder(null);
      setError(t("form.error.failed"));
    } finally {
      setIsSearching(false);
    }
  };

  // Build timeline from order status
  const getTimeline = (order: Order) => {
    const currentStatusIndex = timelineStatuses.indexOf(order.status || "pending");
    
    return timelineStatuses.map((status, index) => ({
      status,
      completed: index <= currentStatusIndex,
      date: index <= currentStatusIndex ? order.createdAt : null,
    }));
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="w-16 h-16 mx-auto bg-primary rounded-full flex items-center justify-center mb-4">
            <Truck className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-2xl sm:text-3xl font-bold text-foreground mb-2">{t("title")}</h1>
          <p className="text-muted-foreground max-w-md mx-auto">
            {t("subtitle")}
          </p>
        </div>

        {/* Search Form */}
        <Card className="max-w-xl mx-auto mb-8 bg-card/80 backdrop-blur">
          <CardContent className="pt-6">
            <form onSubmit={handleSearch} className="flex gap-3">
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  placeholder={t("form.placeholder")}
                  value={orderNumber}
                  onChange={(e) => setOrderNumber(e.target.value)}
                  className="pl-10"
                />
              </div>
              <Button
                type="submit"
                className="bg-primary text-white"
                disabled={isSearching}
              >
                {isSearching ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  t("form.button")
                )}
              </Button>
            </form>
            {error && (
              <p className="text-sm text-red-500 mt-2">{error}</p>
            )}
          </CardContent>
        </Card>

        {/* Order Details */}
        {foundOrder && (
          <div className="max-w-4xl mx-auto space-y-6">
            {/* Order Status */}
            <Card className="bg-card/80 backdrop-blur">
              <CardHeader>
                <div className="flex items-center justify-between flex-wrap gap-4">
                  <div>
                    <CardTitle className="text-xl">{foundOrder.orderNumber}</CardTitle>
                    <CardDescription>
                      {t("timeline.placedOn", { date: foundOrder.createdAt ? new Date(foundOrder.createdAt).toLocaleDateString() : "N/A" })}
                    </CardDescription>
                  </div>
                  <Badge className={`${statusConfig[foundOrder.status || "pending"].color} bg-opacity-10 border-0 text-sm px-4 py-1`}>
                    {statusConfig[foundOrder.status || "pending"].label}
                  </Badge>
                </div>
              </CardHeader>
              <CardContent>
                {/* Timeline */}
                <div className="relative">
                  {getTimeline(foundOrder).map((step, index) => {
                    const config = statusConfig[step.status];
                    const Icon = config.icon;
                    const isLast = index === timelineStatuses.length - 1;

                    return (
                      <div key={step.status} className="flex gap-4 pb-8 last:pb-0">
                        {/* Icon */}
                        <div className="relative">
                          <div
                            className={`w-10 h-10 rounded-full flex items-center justify-center ${
                              step.completed
                                ? "bg-primary"
                                : "bg-muted"
                            }`}
                          >
                            <Icon className={`w-5 h-5 ${step.completed ? "text-white" : "text-muted-foreground"}`} />
                          </div>
                          {/* Line */}
                          {!isLast && (
                            <div
                              className={`absolute left-1/2 top-10 w-0.5 h-full -translate-x-1/2 ${
                                step.completed ? "bg-amber-400" : "bg-muted"
                              }`}
                            />
                          )}
                        </div>

                        {/* Content */}
                        <div className="flex-1 pb-4">
                          <p className={`font-medium ${step.completed ? "text-foreground" : "text-muted-foreground"}`}>
                            {config.label}
                          </p>
                          {step.completed && step.date ? (
                            <p className="text-sm text-muted-foreground">
                              {new Date(step.date).toLocaleDateString()}
                            </p>
                          ) : (
                            <p className="text-sm text-muted-foreground">{t("timeline.pending")}</p>
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>
              </CardContent>
            </Card>

            {/* Order Summary & Shipping */}
            <div className="grid md:grid-cols-2 gap-6">
              {/* Items */}
              <Card className="bg-card/80 backdrop-blur">
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2">
                    <Package className="h-5 w-5 text-primary" />
                    {t("details.items")}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    {(foundOrder.items as OrderItem[])?.map((item, index) => (
                      <div key={index} className="flex justify-between text-sm">
                        <span className="text-muted-foreground">
                          {item.name} × {item.quantity}
                        </span>
                        <span className="font-medium">৳{item.price.toLocaleString()}</span>
                      </div>
                    ))}
                    <div className="border-t pt-3 mt-3">
                      <div className="flex justify-between text-sm">
                        <span className="text-muted-foreground">{t("details.subtotal")}</span>
                        <span>৳{foundOrder.subtotal.toLocaleString()}</span>
                      </div>
                      <div className="flex justify-between text-sm">
                        <span className="text-muted-foreground">Shipping</span>
                        <span>৳{foundOrder.shippingCost?.toLocaleString() || 0}</span>
                      </div>
                      {foundOrder.discount && foundOrder.discount > 0 && (
                        <div className="flex justify-between text-sm text-green-600">
                          <span>{t("details.discount")}</span>
                          <span>-৳{foundOrder.discount.toLocaleString()}</span>
                        </div>
                      )}
                      <div className="flex justify-between font-bold mt-2">
                        <span>{t("details.total")}</span>
                        <span>৳{foundOrder.total.toLocaleString()}</span>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* Shipping Address */}
              <Card className="bg-card/80 backdrop-blur">
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2">
                    <MapPin className="h-5 w-5 text-primary" />
                    {t("details.shipping")}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-2 text-sm text-muted-foreground">
                    <p className="font-medium text-foreground">{foundOrder.customerName}</p>
                    {foundOrder.shippingAddress && (
                      <>
                        <p>{(foundOrder.shippingAddress as { address?: string }).address}</p>
                        <p>{(foundOrder.shippingAddress as { city?: string }).city}</p>
                      </>
                    )}
                    <p>{foundOrder.customerPhone}</p>
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* Actions */}
            <div className="flex justify-center gap-4">
              <Link href="/orders">
                <Button variant="outline" className="gap-2">
                  {t("actions.viewOrders")}
                  <ArrowRight className="h-4 w-4" />
                </Button>
              </Link>
              <Link href="/products">
                <Button className="bg-primary text-white gap-2">
                  {t("actions.continueShopping")}
                </Button>
              </Link>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
