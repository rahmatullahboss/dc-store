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
    <CardFooter className="flex flex-col gap-2 border-t border-border bg-card p-2.5 sm:p-4 rounded-b-xl sm:rounded-b-3xl mt-auto">
      {/* First row: Price + Add button */}
      <div className="flex items-center justify-between w-full">
        <div className="flex flex-col">
          <span className="text-lg sm:text-xl font-bold text-foreground">
            {formatPrice(displayPrice)}
          </span>
          {hasDiscount && (
            <span className="text-xs sm:text-sm text-muted-foreground line-through">
              {formatPrice(originalPrice)}
            </span>
          )}
        </div>
        <AddToCartButton
          item={{
            id: product.id,
            name: product.name,
            price: displayPrice,
            image: product.featuredImage || undefined,
          }}
          compact
          className="!h-9 !px-3 sm:!px-4 !py-1.5 !rounded-full !border-2 !border-primary !bg-primary/10 hover:!bg-primary !text-primary hover:!text-primary-foreground transition-all !font-medium !text-xs sm:!text-sm"
        />
      </div>
      {/* Second row: Full width Order button */}
      <div className="w-full">
        <OrderNowButton
          productId={product.id}
          productName={product.name}
          productPrice={displayPrice}
          productImage={product.featuredImage || undefined}
          compact
          wrapperClassName="w-full"
          className="!h-9 !w-full !text-xs sm:!text-sm"
        />
      </div>
    </CardFooter>
  );
}
