"use client";

import { useEffect } from "react";
import { fbEvents } from "./facebook-pixel";

interface FBViewContentProps {
  productId: string;
  productName: string;
  price: number;
  currency?: string;
}

export function FBViewContent({
  productId,
  productName,
  price,
  currency = "BDT",
}: FBViewContentProps) {
  useEffect(() => {
    // Track ViewContent event when product page is viewed
    fbEvents.viewContent(productId, productName, price, currency);
  }, [productId, productName, price, currency]);

  // This component doesn't render anything
  return null;
}
