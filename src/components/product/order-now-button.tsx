"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";

interface OrderNowButtonProps {
  productSlug: string;
  className?: string;
  wrapperClassName?: string;
  compact?: boolean;
}

export function OrderNowButton({
  productSlug,
  className = "",
  wrapperClassName = "",
  compact,
}: OrderNowButtonProps) {
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  const handleOrder = () => {
    setLoading(true);
    router.push(`/products/${productSlug}`);
  };

  return (
    <div className={cn("flex flex-col", className, wrapperClassName)}>
      <Button
        type="button"
        onClick={handleOrder}
        disabled={loading}
        size="sm"
        className={cn(
          "bg-gradient-to-r from-amber-500 to-rose-500 hover:from-amber-600 hover:to-rose-600 text-white border-0 shadow-md transition-all",
          compact
            ? "rounded-full h-9 px-4 text-sm w-full sm:w-auto sm:h-9 sm:px-4 sm:text-xs"
            : "rounded-full h-9 px-3 text-xs sm:h-10 sm:px-4 sm:text-sm md:h-11 md:px-5 md:text-sm"
        )}
      >
        {loading ? "..." : compact ? "Order" : "Order Now"}
      </Button>
    </div>
  );
}
