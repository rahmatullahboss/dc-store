"use client";

import { GoogleAnalytics as GA4 } from "@next/third-parties/google";

const GA_MEASUREMENT_ID = process.env.NEXT_PUBLIC_GOOGLE_ANALYTICS_ID;

export function GoogleAnalytics() {
  // Don't render anything if no GA ID is configured
  if (!GA_MEASUREMENT_ID) {
    return null;
  }

  return <GA4 gaId={GA_MEASUREMENT_ID} />;
}

// Helper function to send custom events to GA4
export function sendGAEvent(
  eventName: string,
  params?: Record<string, string | number | boolean>
) {
  if (typeof window !== "undefined" && window.gtag && GA_MEASUREMENT_ID) {
    window.gtag("event", eventName, params);
  }
}

// Predefined e-commerce events for GA4
export const gaEvents = {
  // View item (product page view)
  viewItem: (item: {
    id: string;
    name: string;
    price: number;
    category?: string;
    currency?: string;
  }) => {
    sendGAEvent("view_item", {
      currency: item.currency || "BDT",
      value: item.price,
      items: JSON.stringify([
        {
          item_id: item.id,
          item_name: item.name,
          price: item.price,
          item_category: item.category,
        },
      ]),
    });
  },

  // Add to cart
  addToCart: (item: {
    id: string;
    name: string;
    price: number;
    quantity: number;
    currency?: string;
  }) => {
    sendGAEvent("add_to_cart", {
      currency: item.currency || "BDT",
      value: item.price * item.quantity,
      items: JSON.stringify([
        {
          item_id: item.id,
          item_name: item.name,
          price: item.price,
          quantity: item.quantity,
        },
      ]),
    });
  },

  // Remove from cart
  removeFromCart: (item: {
    id: string;
    name: string;
    price: number;
    quantity: number;
    currency?: string;
  }) => {
    sendGAEvent("remove_from_cart", {
      currency: item.currency || "BDT",
      value: item.price * item.quantity,
      items: JSON.stringify([
        {
          item_id: item.id,
          item_name: item.name,
          price: item.price,
          quantity: item.quantity,
        },
      ]),
    });
  },

  // Begin checkout
  beginCheckout: (value: number, itemCount: number, currency?: string) => {
    sendGAEvent("begin_checkout", {
      currency: currency || "BDT",
      value,
      items_count: itemCount,
    });
  },

  // Purchase
  purchase: (transaction: {
    id: string;
    value: number;
    currency?: string;
    shipping?: number;
    tax?: number;
  }) => {
    sendGAEvent("purchase", {
      transaction_id: transaction.id,
      currency: transaction.currency || "BDT",
      value: transaction.value,
      shipping: transaction.shipping || 0,
      tax: transaction.tax || 0,
    });
  },

  // Search
  search: (searchTerm: string) => {
    sendGAEvent("search", {
      search_term: searchTerm,
    });
  },

  // Sign up
  signUp: (method: string = "email") => {
    sendGAEvent("sign_up", {
      method,
    });
  },

  // Login
  login: (method: string = "email") => {
    sendGAEvent("login", {
      method,
    });
  },
};

// Extend Window interface for TypeScript
declare global {
  interface Window {
    gtag: (
      command: string,
      action: string,
      params?: Record<string, unknown>
    ) => void;
  }
}
