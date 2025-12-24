"use client";

import { CardFooter } from "@/components/ui/card";
import { AddToCartButton } from "@/components/cart/add-to-cart-button";
import { OrderNowButton } from "./order-now-button";
import { formatPrice } from "@/lib/config";
import type { Product } from "@/db/schema";

interface ProductCardFooterProps {
  product: Product;
  originalPrice?: number;
  discountedPrice?: number;
}

export function ProductCardFooter({
  product,
  originalPrice,
  discountedPrice,
}: ProductCardFooterProps) {
  const hasDiscount =
    originalPrice && discountedPrice && discountedPrice < originalPrice;
  const displayPrice = hasDiscount ? discountedPrice : product.price;

  return (
    <CardFooter className="flex items-center justify-between gap-2 border-t border-gray-100 bg-white p-2.5 sm:p-4 rounded-b-xl sm:rounded-b-3xl mt-auto">
      {/* Price Section */}
      <div className="flex flex-col">
        <span className="text-lg sm:text-xl font-bold text-gray-900">
          {formatPrice(displayPrice)}
        </span>
        {hasDiscount && (
          <span className="text-xs sm:text-sm text-gray-500 line-through">
            {formatPrice(originalPrice)}
          </span>
        )}
      </div>

      {/* Buttons Section */}
      <div className="flex items-center gap-1.5 sm:gap-2">
        <AddToCartButton
          item={{
            id: product.id,
            name: product.name,
            price: displayPrice,
            image: product.featuredImage || undefined,
          }}
          compact
          className="flex-shrink-0 !h-9 !px-3 !py-1.5 !rounded-full !border-2 !border-amber-500 !bg-amber-50 hover:!bg-amber-500 !text-amber-600 hover:!text-white transition-all !font-medium !text-xs sm:!px-4 sm:!text-sm"
        />
        <OrderNowButton
          productSlug={product.slug}
          compact
          wrapperClassName="flex-shrink-0"
          className="!h-9 !px-4 !text-xs sm:!text-sm"
        />
      </div>
    </CardFooter>
  );
}
