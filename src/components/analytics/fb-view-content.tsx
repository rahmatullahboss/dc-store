"use client";

import { useEffect } from "react";
import { fbEvents } from "./facebook-pixel";
import { gaEvents } from "./google-analytics";
import { clarityEvents } from "./microsoft-clarity";

interface ViewContentProps {
  productId: string;
  productName: string;
  price: number;
  currency?: string;
}

/**
 * ViewContent Analytics Component
 * 
 * Tracks product view events across all analytics platforms:
 * - Facebook Pixel: ViewContent
 * - Google Analytics 4: view_item
 * - Microsoft Clarity: view_product event + tags
 */
export function FBViewContent({
  productId,
  productName,
  price,
  currency = "BDT",
}: ViewContentProps) {
  useEffect(() => {
    // Facebook Pixel - ViewContent
    fbEvents.viewContent(productId, productName, price, currency);
    
    // Google Analytics 4 - view_item
    gaEvents.viewItem({
      id: productId,
      name: productName,
      price,
      currency,
    });
    
    // Microsoft Clarity - custom event + tags
    clarityEvents.event("view_product");
    clarityEvents.setTag("product_id", productId);
    clarityEvents.setTag("product_name", productName);
    clarityEvents.setTag("product_price", price.toString());
  }, [productId, productName, price, currency]);

  // This component doesn't render anything
  return null;
}

