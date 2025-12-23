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
    <CardFooter className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between sm:gap-2 border-t border-gray-100 bg-white p-2.5 sm:p-4 rounded-b-xl sm:rounded-b-3xl mt-auto">
      {/* First row on mobile: Price + Add button */}
      <div className="flex items-center justify-between w-full sm:w-auto sm:gap-2">
        <div className="flex flex-col">
          <span className="text-lg sm:text-2xl font-bold text-gray-900">
            {formatPrice(displayPrice)}
          </span>
          {hasDiscount && (
            <span className="text-xs sm:text-sm text-gray-500 line-through">
              {formatPrice(originalPrice)}
            </span>
          )}
        </div>
        {/* Mobile Add Button */}
        <AddToCartButton
          item={{
            id: product.id,
            name: product.name,
            price: displayPrice,
            image: product.featuredImage || undefined,
          }}
          compact
          className="sm:hidden !px-3 !py-1.5 !rounded-full !border-2 !border-amber-500 !bg-amber-50 hover:!bg-amber-500 !text-amber-600 hover:!text-white transition-all !font-medium !text-xs"
        />
      </div>

      {/* Second row on mobile: Full width Order button */}
      <div className="flex gap-2 w-full sm:w-auto">
        {/* Desktop Add Button */}
        <AddToCartButton
          item={{
            id: product.id,
            name: product.name,
            price: displayPrice,
            image: product.featuredImage || undefined,
          }}
          compact
          className="hidden sm:flex !px-2.5 !py-1.5 !rounded-full !border-2 !border-amber-500 !bg-amber-50 hover:!bg-amber-500 !text-amber-600 hover:!text-white transition-all !font-medium !text-sm"
        />
        <OrderNowButton
          productSlug={product.slug}
          compact
          wrapperClassName="w-full sm:w-auto"
        />
      </div>
    </CardFooter>
  );
}
