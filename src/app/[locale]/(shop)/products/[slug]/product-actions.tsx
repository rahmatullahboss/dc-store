"use client";

import { useState } from "react";
import { ShoppingBag, ShoppingCart, Check, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { QuantitySelector } from "@/components/product/quantity-selector";
import { useCart } from "@/lib/cart-context";
import { useRouter } from "@/i18n/routing";
import type { Product } from "@/db/schema";

interface ProductActionsProps {
  product: Product;
}

export function ProductActions({ product }: ProductActionsProps) {
  const [quantity, setQuantity] = useState(1);
  const [isAdding, setIsAdding] = useState(false);
  const [isAdded, setIsAdded] = useState(false);
  const { addItem } = useCart();
  const router = useRouter();

  const handleAddToCart = async () => {
    setIsAdding(true);

    addItem({
      productId: product.id,
      name: product.name,
      price: product.price,
      quantity: quantity,
      image: product.featuredImage || undefined,
    });

    setTimeout(() => {
      setIsAdding(false);
      setIsAdded(true);

      setTimeout(() => {
        setIsAdded(false);
      }, 2000);
    }, 300);
  };

  const handleBuyNow = () => {
    addItem({
      productId: product.id,
      name: product.name,
      price: product.price,
      quantity: quantity,
      image: product.featuredImage || undefined,
    });
    router.push("/checkout");
  };

  return (
    <div className="mt-6 sm:mt-8 space-y-4">
      {/* Quantity Selector */}
      <div className="flex items-center gap-4">
        <span className="text-sm font-medium text-muted-foreground">Quantity:</span>
        <QuantitySelector
          quantity={quantity}
          onQuantityChange={setQuantity}
          max={product.quantity || 99}
        />
      </div>

      {/* Action Buttons */}
      <div className="grid gap-3 grid-cols-2">
        <Button
          size="lg"
          onClick={handleAddToCart}
          disabled={isAdding}
          className="gap-2 bg-primary hover:from-amber-600 hover:to-rose-600 text-white rounded-full"
        >
          {isAdding ? (
            <>
              <Loader2 className="h-5 w-5 animate-spin" />
              Adding...
            </>
          ) : isAdded ? (
            <>
              <Check className="h-5 w-5" />
              Added!
            </>
          ) : (
            <>
              <ShoppingCart className="h-5 w-5" />
              Add to Cart
            </>
          )}
        </Button>

        <Button
          size="lg"
          variant="outline"
          onClick={handleBuyNow}
          className="gap-2 border-2 border-amber-400 text-primary hover:bg-amber-50 rounded-full"
        >
          <ShoppingBag className="h-5 w-5" />
          Buy Now
        </Button>
      </div>
    </div>
  );
}
