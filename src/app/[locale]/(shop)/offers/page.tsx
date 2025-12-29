import Link from "next/link";
import { Zap, Tag, Gift, Package, Truck, ArrowRight, Percent } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { siteConfig } from "@/lib/config";
import { OfferCard } from "./offer-card";

import { useTranslations } from "next-intl";
import { getTranslations } from "next-intl/server";

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Offers" });
  
  return {
    title: `${t("meta.title")} | ${siteConfig.name}`,
    description: t("meta.description"),
  };
}

// Demo offers data
const demoOffers = [
  {
    id: "1",
    name: "Winter Flash Sale",
    type: "flash_sale" as const,
    description: "Up to 50% off on selected electronics and gadgets. Limited time only!",
    discountType: "percent" as const,
    discountValue: 50,
    startDate: new Date("2024-12-20"),
    endDate: new Date("2024-12-31"),
    badge: "HOT",
    highlightColor: "#ef4444",
    products: [
      { id: "1", name: "Premium Headphones", price: 4999 },
      { id: "2", name: "Smart Watch", price: 12999 },
    ],
  },
  {
    id: "2",
    name: "Buy 2 Get 1 Free",
    type: "buy_x_get_y" as const,
    description: "Buy any 2 fashion items and get 1 absolutely free!",
    discountType: "free_item" as const,
    startDate: new Date("2024-12-15"),
    endDate: new Date("2025-01-15"),
    badge: "BOGO",
    highlightColor: "#a855f7",
  },
  {
    id: "3",
    name: "New User Special",
    type: "promo_banner" as const,
    description: "Get 20% off on your first order. Use code: WELCOME20",
    discountType: "percent" as const,
    discountValue: 20,
    startDate: new Date("2024-12-01"),
    endDate: new Date("2025-01-31"),
    badge: "NEW",
    highlightColor: "#3b82f6",
  },
  {
    id: "4",
    name: "Free Shipping Week",
    type: "free_shipping" as const,
    description: "Free delivery on all orders above ৳1000. No code needed!",
    minOrderValue: 1000,
    startDate: new Date("2024-12-20"),
    endDate: new Date("2024-12-27"),
    highlightColor: "#f59e0b",
  },
  {
    id: "5",
    name: "Electronics Category Sale",
    type: "category_sale" as const,
    description: "All electronics items are 30% off this week!",
    discountType: "percent" as const,
    discountValue: 30,
    startDate: new Date("2024-12-22"),
    endDate: new Date("2024-12-29"),
    category: "Electronics",
    highlightColor: "#3b82f6",
  },
  {
    id: "6",
    name: "Bundle & Save",
    type: "bundle" as const,
    description: "Get headphones + smartwatch bundle at 40% off!",
    discountType: "percent" as const,
    discountValue: 40,
    startDate: new Date("2024-12-18"),
    endDate: new Date("2025-01-05"),
    badge: "BUNDLE",
    highlightColor: "#22c55e",
  },
];



export default function OffersPage() {
  const t = useTranslations("Offers");
  // Group offers by type
  const flashSales = demoOffers.filter((o) => o.type === "flash_sale");
  const categorySales = demoOffers.filter((o) => o.type === "category_sale");
  const bogoDeals = demoOffers.filter((o) => o.type === "buy_x_get_y");
  const bundles = demoOffers.filter((o) => o.type === "bundle");
  const freeShipping = demoOffers.filter((o) => o.type === "free_shipping");
  const promoBanners = demoOffers.filter((o) => o.type === "promo_banner");

  return (
    <div className="min-h-screen bg-background">
      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Hero Section */}
        <div className="bg-primary rounded-2xl p-8 md:p-12 mb-8 text-white relative overflow-hidden">
          {/* Decorative elements */}
          <div className="absolute inset-0 overflow-hidden pointer-events-none">
            <div className="absolute -top-20 -right-20 w-60 h-60 bg-card/10 rounded-full blur-3xl" />
            <div className="absolute -bottom-20 -left-20 w-60 h-60 bg-card/10 rounded-full blur-3xl" />
          </div>
          
          <div className="relative z-10">
            <h1 className="text-3xl md:text-5xl font-bold mb-3">{t("hero.title")}</h1>
            <p className="text-white/90 text-lg md:text-xl mb-6 max-w-2xl">
              {t("hero.subtitle")}
            </p>
            <div className="flex flex-wrap gap-2">
              <Badge className="bg-card/20 text-white border-0 text-sm px-4 py-1">
                {t("hero.badges.flash")}
              </Badge>
              <Badge className="bg-card/20 text-white border-0 text-sm px-4 py-1">
                {t("hero.badges.bogo")}
              </Badge>
              <Badge className="bg-card/20 text-white border-0 text-sm px-4 py-1">
                {t("hero.badges.bundle")}
              </Badge>
              <Badge className="bg-card/20 text-white border-0 text-sm px-4 py-1">
                {t("hero.badges.shipping")}
              </Badge>
            </div>
          </div>
        </div>

        {/* Flash Sales */}
        {flashSales.length > 0 && (
          <section className="mb-10">
            <div className="flex items-center gap-3 mb-6">
              <div className="p-2 bg-red-500 rounded-lg text-white">
                <Zap className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-foreground">{t("sections.flash.title")}</h2>
                <p className="text-sm text-muted-foreground">
                  {t("sections.flash.desc")}
                </p>
              </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {flashSales.map((offer) => (
                <OfferCard key={offer.id} offer={offer} />
              ))}
            </div>
          </section>
        )}

        {/* BOGO Deals */}
        {bogoDeals.length > 0 && (
          <section className="mb-10">
            <div className="flex items-center gap-3 mb-6">
              <div className="p-2 bg-purple-500 rounded-lg text-white">
                <Gift className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-foreground">{t("sections.bogo.title")}</h2>
                <p className="text-sm text-muted-foreground">{t("sections.bogo.desc")}</p>
              </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {bogoDeals.map((offer) => (
                <OfferCard key={offer.id} offer={offer} />
              ))}
            </div>
          </section>
        )}

        {/* Category Sales */}
        {categorySales.length > 0 && (
          <section className="mb-10">
            <div className="flex items-center gap-3 mb-6">
              <div className="p-2 bg-blue-500 rounded-lg text-white">
                <Tag className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-foreground">{t("sections.category.title")}</h2>
                <p className="text-sm text-muted-foreground">{t("sections.category.desc")}</p>
              </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {categorySales.map((offer) => (
                <OfferCard key={offer.id} offer={offer} />
              ))}
            </div>
          </section>
        )}

        {/* Bundle Deals */}
        {bundles.length > 0 && (
          <section className="mb-10">
            <div className="flex items-center gap-3 mb-6">
              <div className="p-2 bg-green-500 rounded-lg text-white">
                <Package className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-foreground">{t("sections.bundle.title")}</h2>
                <p className="text-sm text-muted-foreground">{t("sections.bundle.desc")}</p>
              </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {bundles.map((offer) => (
                <OfferCard key={offer.id} offer={offer} />
              ))}
            </div>
          </section>
        )}

        {/* Free Shipping */}
        {freeShipping.length > 0 && (
          <section className="mb-10">
            <div className="flex items-center gap-3 mb-6">
              <div className="p-2 bg-primary rounded-lg text-white">
                <Truck className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-foreground">{t("sections.shipping.title")}</h2>
                <p className="text-sm text-muted-foreground">{t("sections.shipping.desc")}</p>
              </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {freeShipping.map((offer) => (
                <OfferCard key={offer.id} offer={offer} />
              ))}
            </div>
          </section>
        )}

        {/* Promo Banners (New User Deals etc.) */}
        {promoBanners.length > 0 && (
          <section className="mb-10">
            <div className="flex items-center gap-3 mb-6">
              <div className="p-2 bg-pink-500 rounded-lg text-white">
                <Percent className="w-5 h-5" />
              </div>
              <div>
                <h2 className="text-xl font-bold text-foreground">{t("sections.promo.title")}</h2>
                <p className="text-sm text-muted-foreground">{t("sections.promo.desc")}</p>
              </div>
            </div>

            <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
              {promoBanners.map((offer) => (
                <OfferCard key={offer.id} offer={offer} />
              ))}
            </div>
          </section>
        )}

        {/* No offers fallback */}
        {demoOffers.length === 0 && (
          <div className="text-center py-16 bg-card rounded-xl shadow-sm">
            <div className="w-20 h-20 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
              <Gift className="w-10 h-10 text-muted-foreground" />
            </div>
            <h2 className="text-xl font-semibold text-foreground mb-2">{t("empty.title")}</h2>
            <p className="text-muted-foreground mb-6">{t("empty.desc")}</p>
            <Link href="/products">
              <Button className="bg-primary text-white">
                {t("empty.cta")}
              </Button>
            </Link>
          </div>
        )}

        {/* CTA Section */}
        <div className="mt-12 text-center">
          <Link href="/products">
            <Button
              size="lg"
              className="bg-primary hover:from-amber-600 hover:to-rose-600 text-white rounded-full px-8 gap-2"
            >
              {t("cta")}
              <ArrowRight className="w-4 h-4" />
            </Button>
          </Link>
        </div>
      </div>
    </div>
  );
}
