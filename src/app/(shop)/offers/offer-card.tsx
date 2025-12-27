"use client";

import Link from "next/link";
import { ArrowRight, Zap, Tag, Gift, Package, Truck, Percent } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { CountdownTimer } from "@/components/common/countdown-timer";

interface Offer {
  id: string;
  name: string;
  type: "flash_sale" | "category_sale" | "buy_x_get_y" | "bundle" | "free_shipping" | "promo_banner";
  description?: string;
  discountType?: "percent" | "fixed" | "free_item";
  discountValue?: number;
  minOrderValue?: number;
  startDate: Date;
  endDate: Date;
  badge?: string;
  highlightColor: string;
  category?: string;
  products?: Array<{ id: string; name: string; price: number }>;
}

const offerTypeConfig = {
  flash_sale: { icon: Zap, label: "Flash Sale", color: "bg-red-500", bgColor: "bg-red-50" },
  category_sale: { icon: Tag, label: "Category Sale", color: "bg-blue-500", bgColor: "bg-blue-50" },
  buy_x_get_y: { icon: Gift, label: "Buy X Get Y", color: "bg-purple-500", bgColor: "bg-purple-50" },
  bundle: { icon: Package, label: "Bundle Deal", color: "bg-green-500", bgColor: "bg-green-50" },
  free_shipping: { icon: Truck, label: "Free Shipping", color: "bg-primary", bgColor: "bg-amber-50" },
  promo_banner: { icon: Percent, label: "Promotion", color: "bg-pink-500", bgColor: "bg-pink-50" },
};

interface OfferCardProps {
  offer: Offer;
}

export function OfferCard({ offer }: OfferCardProps) {
  const typeConfig = offerTypeConfig[offer.type];
  const TypeIcon = typeConfig.icon;

  return (
    <div
      className={`rounded-xl p-3 sm:p-5 ${typeConfig.bgColor} border border-border hover:shadow-lg transition-all duration-300 hover:scale-[1.02]`}
    >
      {/* Header */}
      <div className="flex items-start justify-between mb-2 sm:mb-3">
        <div className="flex items-center gap-1.5 sm:gap-2">
          <div className={`p-1 sm:p-1.5 rounded-lg ${typeConfig.color} text-white`}>
            <TypeIcon className="w-3 h-3 sm:w-4 sm:h-4" />
          </div>
          <span className="text-[10px] sm:text-xs font-medium text-muted-foreground">{typeConfig.label}</span>
        </div>
        {offer.badge && (
          <Badge className="bg-gradient-to-r from-red-500 to-rose-500 text-white text-[10px] sm:text-xs border-0 shadow-sm px-1.5 py-0.5 sm:px-2 sm:py-1">
            {offer.badge}
          </Badge>
        )}
      </div>

      {/* Title & Description */}
      <h3 className="font-bold text-foreground mb-0.5 sm:mb-1 text-sm sm:text-lg line-clamp-1">{offer.name}</h3>
      {offer.description && (
        <p className="text-xs sm:text-sm text-muted-foreground mb-2 sm:mb-4 line-clamp-1 sm:line-clamp-2">{offer.description}</p>
      )}

      {/* Discount Display */}
      <div className="mb-2 sm:mb-4">
        {offer.type === "free_shipping" ? (
          <div>
            <span className="text-lg sm:text-2xl font-bold text-green-600">FREE SHIPPING</span>
            {offer.minOrderValue && offer.minOrderValue > 0 && (
              <p className="text-[10px] sm:text-sm text-muted-foreground">On orders above ৳{offer.minOrderValue}</p>
            )}
          </div>
        ) : offer.type === "buy_x_get_y" ? (
          <span className="text-lg sm:text-2xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
            BUY 2 GET 1 FREE
          </span>
        ) : offer.discountValue && offer.discountType ? (
          <div>
            {offer.discountType === "percent" && (
              <span className="text-lg sm:text-2xl font-bold bg-gradient-to-r from-green-600 to-emerald-600 bg-clip-text text-transparent">
                {offer.discountValue}% OFF
              </span>
            )}
            {offer.discountType === "fixed" && (
              <span className="text-lg sm:text-2xl font-bold bg-gradient-to-r from-green-600 to-emerald-600 bg-clip-text text-transparent">
                ৳{offer.discountValue} OFF
              </span>
            )}
            {offer.category && (
              <p className="text-[10px] sm:text-sm text-muted-foreground">On all {offer.category} items</p>
            )}
          </div>
        ) : null}
      </div>

      {/* Footer: Countdown + Shop Link */}
      <div className="flex items-center justify-between gap-2">
        <CountdownTimer endDate={offer.endDate} className="text-primary text-[10px] sm:text-sm" />
        <Link
          href="/products"
          className="text-xs sm:text-sm font-medium flex items-center gap-0.5 sm:gap-1 text-primary hover:text-amber-700 transition-colors whitespace-nowrap"
        >
          Shop <ArrowRight className="w-3 h-3 sm:w-4 sm:h-4" />
        </Link>
      </div>
    </div>
  );
}
