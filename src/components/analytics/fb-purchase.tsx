"use client";

import { useEffect, useRef } from "react";
import { fbEvents } from "./facebook-pixel";

interface FBPurchaseProps {
  orderId: string;
  productIds: string[];
  numItems: number;
  value: number;
  currency?: string;
}

export function FBPurchase({
  orderId,
  productIds,
  numItems,
  value,
  currency = "BDT",
}: FBPurchaseProps) {
  const hasTracked = useRef(false);

  useEffect(() => {
    // Prevent duplicate tracking
    if (hasTracked.current) return;
    hasTracked.current = true;

    // Track Purchase event
    fbEvents.purchase(productIds, numItems, value, currency);
    
    // Log for debugging (only in development)
    if (process.env.NODE_ENV === "development") {
      console.log("FB Pixel: Purchase tracked", {
        orderId,
        productIds,
        numItems,
        value,
        currency,
      });
    }
  }, [orderId, productIds, numItems, value, currency]);

  // This component doesn't render anything
  return null;
}
