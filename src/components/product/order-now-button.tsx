"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { cn } from "@/lib/utils";
import { ShinyButton } from "@/components/ui/shiny-button";
import { useCart } from "@/lib/cart-context";

import { useTranslations } from "next-intl";

interface OrderNowButtonProps {
  productId: string;
  productName: string;
  productPrice: number;
  productImage?: string;
  className?: string;
  wrapperClassName?: string;
  compact?: boolean;
}

export function OrderNowButton({
  productId,
  productName,
  productPrice,
  productImage,
  className = "",
  wrapperClassName = "",
  compact,
}: OrderNowButtonProps) {
  const t = useTranslations("Products");
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const { addItem, items } = useCart();

  const handleOrder = () => {
    setLoading(true);
    
    // Check if item already in cart
    const existingItem = items.find(item => item.productId === productId);
    
    if (!existingItem) {
      // Add item to cart first
      addItem({
        productId,
        name: productName,
        price: productPrice,
        quantity: 1,
        image: productImage,
      });
    }
    
    // Navigate to checkout
    router.push("/checkout");
  };

  return (
    <div className={cn("flex flex-col", wrapperClassName)}>
      <ShinyButton
        type="button"
        onClick={handleOrder}
        disabled={loading}
        size="sm"
        className={cn(
          compact
            ? "rounded-full h-9 px-4 text-sm w-full sm:w-auto sm:h-9 sm:px-4 sm:text-xs"
            : "rounded-full h-9 px-3 text-xs sm:h-10 sm:px-4 sm:text-sm md:h-11 md:px-5 md:text-sm",
          className
        )}
      >
        {loading ? "..." : compact ? t('order') : t('orderNow')}
      </ShinyButton>
    </div>
  );
}

