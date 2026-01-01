"use client";

import Script from "next/script";

const FB_PIXEL_ID = process.env.NEXT_PUBLIC_FACEBOOK_PIXEL_ID;

// Generate event ID for deduplication between client and server
function generateEventId(): string {
  return `${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
}

// Send event to server-side CAPI endpoint
async function sendServerEvent(
  eventName: string,
  customData?: Record<string, unknown>,
  userData?: Record<string, unknown>
): Promise<void> {
  try {
    await fetch("/api/analytics/facebook", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        eventName,
        customData,
        userData,
      }),
    });
  } catch (error) {
    // Silently fail - don't disrupt user experience
    console.debug("FB CAPI server event failed:", error);
  }
}

export function FacebookPixel() {
  // Don't render anything if no Pixel ID is configured
  if (!FB_PIXEL_ID) {
    return null;
  }

  return (
    <>
      {/* Facebook Pixel Base Code */}
      <Script
        id="facebook-pixel"
        strategy="afterInteractive"
        dangerouslySetInnerHTML={{
          __html: `
            !function(f,b,e,v,n,t,s)
            {if(f.fbq)return;n=f.fbq=function(){n.callMethod?
            n.callMethod.apply(n,arguments):n.queue.push(arguments)};
            if(!f._fbq)f._fbq=n;n.push=n;n.loaded=!0;n.version='2.0';
            n.queue=[];t=b.createElement(e);t.async=!0;
            t.src=v;s=b.getElementsByTagName(e)[0];
            s.parentNode.insertBefore(t,s)}(window, document,'script',
            'https://connect.facebook.net/en_US/fbevents.js');
            fbq('init', '${FB_PIXEL_ID}');
            fbq('track', 'PageView');
          `,
        }}
      />
      {/* Facebook Pixel NoScript Fallback */}
      <noscript>
        <img
          height="1"
          width="1"
          style={{ display: "none" }}
          src={`https://www.facebook.com/tr?id=${FB_PIXEL_ID}&ev=PageView&noscript=1`}
          alt=""
        />
      </noscript>
    </>
  );
}

// Helper function to track custom events (client-side only)
export function trackFBEvent(
  eventName: string,
  params?: Record<string, unknown>,
  eventId?: string
) {
  if (typeof window !== "undefined" && window.fbq && FB_PIXEL_ID) {
    // Include eventID for deduplication with server-side events
    const eventParams = eventId ? { ...params, eventID: eventId } : params;
    window.fbq("track", eventName, eventParams);
  }
}

// Hybrid tracking: sends to both client (Pixel) and server (CAPI)
async function hybridTrack(
  eventName: string,
  params?: Record<string, unknown>,
  serverCustomData?: Record<string, unknown>
) {
  const eventId = generateEventId();
  
  // 1. Send to client-side Pixel (immediate)
  trackFBEvent(eventName, params, eventId);
  
  // 2. Send to server-side CAPI (async, non-blocking)
  sendServerEvent(eventName, serverCustomData);
}

// Predefined e-commerce events with hybrid tracking
export const fbEvents = {
  // When a product is added to cart
  addToCart: (
    contentId: string,
    contentName: string,
    value: number,
    currency: string = "BDT"
  ) => {
    hybridTrack(
      "AddToCart",
      {
        content_ids: [contentId],
        content_name: contentName,
        content_type: "product",
        value,
        currency,
      },
      {
        contentId,
        contentName,
        value,
        currency,
      }
    );
  },

  // When checkout is initiated
  initiateCheckout: (
    contentIds: string[],
    numItems: number,
    value: number,
    currency: string = "BDT"
  ) => {
    hybridTrack(
      "InitiateCheckout",
      {
        content_ids: contentIds,
        num_items: numItems,
        value,
        currency,
      },
      {
        contentIds,
        numItems,
        value,
        currency,
      }
    );
  },

  // When a purchase is completed (client-side only, server handles separately)
  purchase: (
    contentIds: string[],
    numItems: number,
    value: number,
    currency: string = "BDT"
  ) => {
    // Purchase is tracked server-side in the orders API
    // This is just for client-side backup
    trackFBEvent("Purchase", {
      content_ids: contentIds,
      num_items: numItems,
      value,
      currency,
    });
  },

  // When a product is viewed
  viewContent: (
    contentId: string,
    contentName: string,
    value: number,
    currency: string = "BDT"
  ) => {
    hybridTrack(
      "ViewContent",
      {
        content_ids: [contentId],
        content_name: contentName,
        content_type: "product",
        value,
        currency,
      },
      {
        contentId,
        contentName,
        value,
        currency,
      }
    );
  },

  // When a user searches
  search: (searchString: string) => {
    hybridTrack(
      "Search",
      {
        search_string: searchString,
      },
      {
        searchString,
      }
    );
  },

  // When a user adds to wishlist
  addToWishlist: (
    contentId: string,
    contentName: string,
    value: number,
    currency: string = "BDT"
  ) => {
    trackFBEvent("AddToWishlist", {
      content_ids: [contentId],
      content_name: contentName,
      content_type: "product",
      value,
      currency,
    });
  },

  // When user completes registration
  completeRegistration: () => {
    hybridTrack("CompleteRegistration", {}, {});
  },

  // When user contacts (Lead event for CAPI)
  contact: () => {
    // Track as Contact for Pixel, Lead for CAPI
    trackFBEvent("Contact");
    sendServerEvent("Lead", {});
  },
};

// Extend Window interface for TypeScript
declare global {
  interface Window {
    fbq: (
      type: string,
      eventName: string,
      params?: Record<string, unknown>
    ) => void;
  }
}
