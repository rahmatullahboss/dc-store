"use client";

import { GoogleTagManager as GTM } from "@next/third-parties/google";

const GTM_ID = process.env.NEXT_PUBLIC_GOOGLE_TAG_MANAGER_ID;

export function GoogleTagManager() {
  // Don't render anything if no GTM ID is configured
  if (!GTM_ID) {
    return null;
  }

  return <GTM gtmId={GTM_ID} />;
}

// Helper function to push events to dataLayer
export function pushToDataLayer(data: Record<string, unknown>) {
  if (typeof window !== "undefined" && window.dataLayer && GTM_ID) {
    window.dataLayer.push(data);
  }
}

// Predefined GTM events
export const gtmEvents = {
  // Custom event
  customEvent: (eventName: string, data?: Record<string, unknown>) => {
    pushToDataLayer({
      event: eventName,
      ...data,
    });
  },

  // E-commerce: View item
  viewItem: (item: {
    id: string;
    name: string;
    price: number;
    category?: string;
    currency?: string;
  }) => {
    pushToDataLayer({
      event: "view_item",
      ecommerce: {
        currency: item.currency || "BDT",
        value: item.price,
        items: [
          {
            item_id: item.id,
            item_name: item.name,
            price: item.price,
            item_category: item.category,
          },
        ],
      },
    });
  },

  // E-commerce: Add to cart
  addToCart: (item: {
    id: string;
    name: string;
    price: number;
    quantity: number;
    currency?: string;
  }) => {
    pushToDataLayer({
      event: "add_to_cart",
      ecommerce: {
        currency: item.currency || "BDT",
        value: item.price * item.quantity,
        items: [
          {
            item_id: item.id,
            item_name: item.name,
            price: item.price,
            quantity: item.quantity,
          },
        ],
      },
    });
  },

  // E-commerce: Begin checkout
  beginCheckout: (
    items: Array<{ id: string; name: string; price: number; quantity: number }>,
    value: number,
    currency?: string
  ) => {
    pushToDataLayer({
      event: "begin_checkout",
      ecommerce: {
        currency: currency || "BDT",
        value,
        items: items.map((item) => ({
          item_id: item.id,
          item_name: item.name,
          price: item.price,
          quantity: item.quantity,
        })),
      },
    });
  },

  // E-commerce: Purchase
  purchase: (transaction: {
    id: string;
    value: number;
    currency?: string;
    shipping?: number;
    tax?: number;
    items: Array<{ id: string; name: string; price: number; quantity: number }>;
  }) => {
    pushToDataLayer({
      event: "purchase",
      ecommerce: {
        transaction_id: transaction.id,
        currency: transaction.currency || "BDT",
        value: transaction.value,
        shipping: transaction.shipping || 0,
        tax: transaction.tax || 0,
        items: transaction.items.map((item) => ({
          item_id: item.id,
          item_name: item.name,
          price: item.price,
          quantity: item.quantity,
        })),
      },
    });
  },
};

