"use client";

import { useEffect, useRef } from "react";
import { gaEvents } from "./google-analytics";
import { clarityEvents } from "./microsoft-clarity";

interface GAPurchaseProps {
  orderId: string;
  value: number;
  currency?: string;
  shipping?: number;
  items?: Array<{
    productId: string;
    name: string;
    price: number;
    quantity: number;
  }>;
}

export function GAPurchase({
  orderId,
  value,
  currency = "BDT",
  shipping = 0,
  items = [],
}: GAPurchaseProps) {
  const hasFired = useRef(false);

  useEffect(() => {
    // Prevent double firing
    if (hasFired.current) return;
    hasFired.current = true;

    // Track GA4 purchase event
    gaEvents.purchase({
      id: orderId,
      value,
      currency,
      shipping,
    });

    // Track Clarity upgrade for high-value conversion
    clarityEvents.upgrade("purchase_completed");
    clarityEvents.event("purchase");
    clarityEvents.setTag("order_id", orderId);
    clarityEvents.setTag("order_value", value.toString());
  }, [orderId, value, currency, shipping, items]);

  return null;
}
