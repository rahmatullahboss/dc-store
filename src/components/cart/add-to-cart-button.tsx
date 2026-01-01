"use client";

import { useState } from "react";
import { Plus, Check, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useCart } from "@/lib/cart-context";
import { cn } from "@/lib/utils";
import type { CartItem } from "@/db/schema";
import { useTranslations } from "next-intl";
import { fbEvents } from "@/components/analytics/facebook-pixel";

interface AddToCartButtonProps {
  item: {
    id: string;
    name: string;
    price: number;
    image?: string;
  };
  className?: string;
  compact?: boolean;
  variant?: "default" | "outline" | "secondary";
}

export function AddToCartButton({
  item,
  className,
  compact = false,
  variant = "default",
}: AddToCartButtonProps) {
  const t = useTranslations("Products");
  const { addItem } = useCart();
  const [isAdded, setIsAdded] = useState(false);
  const [isAdding, setIsAdding] = useState(false);

  const handleAddToCart = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();

    if (isAdding) return;

    setIsAdding(true);

    const cartItem: CartItem = {
      productId: item.id,
      name: item.name,
      price: item.price,
      quantity: 1,
      image: item.image,
    };

    addItem(cartItem);

    // Track Facebook Pixel AddToCart event
    fbEvents.addToCart(item.id, item.name, item.price);

    setIsAdded(true);

    // Reset after animation
    setTimeout(() => {
      setIsAdded(false);
      setIsAdding(false);
    }, 1500);
  };

  return (
    <Button
      onClick={handleAddToCart}
      disabled={isAdding}
      variant={isAdded ? "default" : variant}
      size={compact ? "sm" : "default"}
      className={cn(
        "transition-all duration-300",
        compact ? "h-8 px-3 text-xs" : "h-10 px-4",
        isAdded && "bg-green-600 hover:bg-green-600 text-white",
        className
      )}
    >
      {isAdding && !isAdded ? (
        <Loader2
          className={cn("animate-spin", compact ? "h-3 w-3" : "h-4 w-4")}
        />
      ) : isAdded ? (
        <>
          <Check className={cn(compact ? "h-3 w-3 mr-1" : "h-4 w-4 mr-2")} />
          <span>{compact ? "✓" : t('added')}</span>
        </>
      ) : (
        <>
          <Plus className={cn(compact ? "h-3 w-3 mr-1" : "h-4 w-4 mr-2")} />
          <span>{compact ? t('add') : t('addToCart')}</span>
        </>
      )}
    </Button>
  );
}
