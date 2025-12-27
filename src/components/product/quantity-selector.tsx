"use client";

import { Minus, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";

interface QuantitySelectorProps {
  quantity: number;
  onQuantityChange: (quantity: number) => void;
  min?: number;
  max?: number;
  className?: string;
}

export function QuantitySelector({
  quantity,
  onQuantityChange,
  min = 1,
  max = 99,
  className = "",
}: QuantitySelectorProps) {
  const decrease = () => {
    if (quantity > min) {
      onQuantityChange(quantity - 1);
    }
  };

  const increase = () => {
    if (quantity < max) {
      onQuantityChange(quantity + 1);
    }
  };

  return (
    <div className={`flex items-center gap-3 ${className}`}>
      <Button
        variant="outline"
        size="icon"
        onClick={decrease}
        disabled={quantity <= min}
        className="h-10 w-10 rounded-full border-2 border-border hover:border-amber-400 hover:bg-amber-50 transition-all"
      >
        <Minus className="h-4 w-4" />
      </Button>
      
      <span className="w-12 text-center text-lg font-bold text-foreground">
        {quantity}
      </span>
      
      <Button
        variant="outline"
        size="icon"
        onClick={increase}
        disabled={quantity >= max}
        className="h-10 w-10 rounded-full border-2 border-border hover:border-amber-400 hover:bg-amber-50 transition-all"
      >
        <Plus className="h-4 w-4" />
      </Button>
    </div>
  );
}
