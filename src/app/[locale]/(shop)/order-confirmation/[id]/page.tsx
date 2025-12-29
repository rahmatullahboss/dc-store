import Link from "next/link";
import { CheckCircle2, Package, Truck, MapPin, CreditCard, ArrowRight, Home } from "lucide-react";
import { Button } from "@/components/ui/button";
import { getDatabase } from "@/lib/cloudflare";
import { orders } from "@/db/schema";
import { eq } from "drizzle-orm";
import { formatPrice } from "@/lib/config";
import { notFound } from "next/navigation";
import Image from "next/image";

import { getTranslations } from "next-intl/server";
import { siteConfig } from "@/lib/config";

// Force dynamic rendering for Cloudflare context
export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "OrderConfirmation" });
  
  return {
    title: `${t("title")} | ${siteConfig.name}`,
    description: t("subtitle"),
  };
}

interface OrderConfirmationPageProps {
  params: Promise<{ id: string }>;
}

export default async function OrderConfirmationPage({ params }: OrderConfirmationPageProps) {
  const { id, locale } = await params as { id: string; locale: string };
  const t = await getTranslations({ locale, namespace: "OrderConfirmation" });
  
  const db = await getDatabase();
  const order = await db.query.orders.findFirst({
    where: eq(orders.id, id),
  });

  if (!order) {
    notFound();
  }

  const estimatedDelivery = new Date();
  estimatedDelivery.setDate(estimatedDelivery.getDate() + 5);

  return (
    <div className="min-h-screen bg-background relative overflow-hidden">
      {/* Confetti Background Effect */}
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute top-10 left-10 w-4 h-4 bg-amber-400 rounded-full opacity-60 animate-bounce" style={{ animationDelay: "0.1s" }} />
        <div className="absolute top-20 right-20 w-3 h-3 bg-rose-400 rounded-full opacity-50 animate-bounce" style={{ animationDelay: "0.3s" }} />
        <div className="absolute top-40 left-1/4 w-5 h-5 bg-blue-400 rounded-full opacity-40 animate-bounce" style={{ animationDelay: "0.5s" }} />
        <div className="absolute top-32 right-1/3 w-4 h-4 bg-green-400 rounded-full opacity-50 animate-bounce" style={{ animationDelay: "0.7s" }} />
        <div className="absolute top-16 left-1/2 w-3 h-3 bg-purple-400 rounded-full opacity-60 animate-bounce" style={{ animationDelay: "0.9s" }} />
      </div>

      <div className="container mx-auto px-4 py-8 md:py-16 relative z-10">
        <div className="max-w-2xl mx-auto">
          {/* Success Animation */}
          <div className="text-center mb-8">
            <div className="inline-flex items-center justify-center w-24 h-24 bg-gradient-to-r from-green-400 to-emerald-500 rounded-full mb-6 shadow-xl shadow-green-200">
              <CheckCircle2 className="h-12 w-12 text-white" />
            </div>
            <h1 className="text-3xl md:text-4xl font-bold mb-2">
              <span className="bg-primary bg-clip-text text-transparent">
                {t("title")}
              </span>
            </h1>
            <p className="text-muted-foreground text-lg">
              {t("subtitle")}
            </p>
          </div>

          {/* Order Number */}
          <div className="bg-card rounded-2xl p-6 shadow-lg border border-border mb-6">
            <div className="flex items-center justify-between mb-4">
              <span className="text-muted-foreground">{t("orderNumber")}</span>
              <span className="text-lg font-bold text-foreground">#{order.orderNumber}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-muted-foreground">{t("orderDate")}</span>
              <span className="font-medium text-foreground">
                {new Date(order.createdAt!).toLocaleDateString("en-US", {
                  year: "numeric",
                  month: "long",
                  day: "numeric",
                })}
              </span>
            </div>
          </div>

          {/* Order Items */}
          <div className="bg-card rounded-2xl p-6 shadow-lg border border-border mb-6">
            <div className="flex items-center gap-3 mb-4">
              <div className="p-2 bg-primary rounded-lg text-white">
                <Package className="h-5 w-5" />
              </div>
              <h2 className="text-lg font-bold text-foreground">{t("summary")}</h2>
            </div>

            <div className="space-y-4 mb-6">
              {order.items?.map((item, index) => (
                <div key={index} className="flex gap-3">
                  <div className="relative h-16 w-16 flex-shrink-0 overflow-hidden rounded-lg bg-muted">
                    {item.image ? (
                      <Image
                        src={item.image}
                        alt={item.name}
                        fill
                        className="object-cover"
                      />
                    ) : (
                      <div className="flex h-full items-center justify-center text-muted-foreground">
                        <Package className="h-6 w-6" />
                      </div>
                    )}
                  </div>
                  <div className="flex-1 min-w-0">
                    <h4 className="text-sm font-medium text-foreground line-clamp-1">
                      {item.name}
                    </h4>
                    <p className="text-sm text-muted-foreground">{t("qty", { count: item.quantity })}</p>
                    <p className="text-sm font-bold text-primary">
                      {formatPrice(item.price * item.quantity)}
                    </p>
                  </div>
                </div>
              ))}
            </div>

            <div className="border-t pt-4 space-y-2">
              <div className="flex justify-between text-muted-foreground">
                <span>{t("subtotal")}</span>
                <span>{formatPrice(order.subtotal)}</span>
              </div>
              <div className="flex justify-between text-muted-foreground">
                <span>{t("shipping")}</span>
                <span>{order.shippingCost === 0 ? t("free") : formatPrice(order.shippingCost || 0)}</span>
              </div>
              <div className="flex justify-between text-lg font-bold text-foreground pt-2 border-t">
                <span>{t("total")}</span>
                <span className="text-primary">{formatPrice(order.total)}</span>
              </div>
            </div>
          </div>

          {/* Shipping & Payment Info */}
          <div className="grid sm:grid-cols-2 gap-4 mb-6">
            <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
              <div className="flex items-center gap-3 mb-4">
                <div className="p-2 bg-blue-100 rounded-lg text-blue-600">
                  <MapPin className="h-5 w-5" />
                </div>
                <h3 className="font-bold text-foreground">{t("shippingAddress")}</h3>
              </div>
              <div className="text-muted-foreground text-sm space-y-1">
                <p className="font-medium text-foreground">{order.customerName}</p>
                <p>{order.shippingAddress?.address}</p>
                <p>{order.shippingAddress?.city}, {order.shippingAddress?.state}</p>
                <p>{order.customerPhone}</p>
              </div>
            </div>

            <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
              <div className="flex items-center gap-3 mb-4">
                <div className="p-2 bg-green-100 rounded-lg text-green-600">
                  <CreditCard className="h-5 w-5" />
                </div>
                <h3 className="font-bold text-foreground">{t("payment")}</h3>
              </div>
              <div className="text-muted-foreground text-sm space-y-2">
                {order.paymentMethod === "stripe" ? (
                  <>
                    <div className="inline-flex items-center gap-2 bg-green-100 text-green-800 px-3 py-1.5 rounded-full text-sm font-medium">
                      💳 {t("methods.card")}
                    </div>
                    <p className="text-muted-foreground">{t("methods.stripe")}</p>
                  </>
                ) : (
                  <>
                    <div className="inline-flex items-center gap-2 bg-amber-100 text-amber-800 px-3 py-1.5 rounded-full text-sm font-medium">
                      💵 {t("methods.cod")}
                    </div>
                    <p className="text-muted-foreground">{t("methods.payOnDelivery")}</p>
                  </>
                )}
              </div>
            </div>
          </div>

          {/* Estimated Delivery */}
          <div className="bg-gradient-to-r from-amber-50 to-rose-50 rounded-2xl p-6 border border-amber-100 mb-8">
            <div className="flex items-center gap-3 mb-2">
              <Truck className="h-6 w-6 text-primary" />
              <h3 className="font-bold text-foreground">{t("estimatedDelivery.title")}</h3>
            </div>
            <p className="text-lg font-bold text-primary">
              {estimatedDelivery.toLocaleDateString(locale === "bn" ? "bn-BD" : "en-US", {
                weekday: "long",
                month: "long",
                day: "numeric",
              })}
            </p>
            <p className="text-sm text-muted-foreground mt-1">
              {t("estimatedDelivery.desc")}
            </p>
          </div>

          {/* Action Buttons */}
          <div className="flex flex-col sm:flex-row gap-4 w-full">
            <Button 
              size="lg"
              className="w-full sm:flex-1 bg-primary hover:from-amber-600 hover:to-rose-600 text-white rounded-full"
              asChild
            >
              <Link href="/orders">
                {t("actions.track")} <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </Button>
            <Button 
              size="lg"
              variant="outline"
              className="w-full sm:flex-1 rounded-full"
              asChild
            >
              <Link href="/">
                <Home className="mr-2 h-4 w-4" />
                {t("actions.continue")}
              </Link>
            </Button>
          </div>

          {/* Email Notice */}
          <p className="text-center text-sm text-muted-foreground mt-6">
            {t("emailNotice")}
          </p>
        </div>
      </div>
    </div>
  );
}
