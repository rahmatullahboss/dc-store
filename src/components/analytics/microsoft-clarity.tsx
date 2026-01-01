"use client";

import Script from "next/script";

const CLARITY_PROJECT_ID = process.env.NEXT_PUBLIC_MICROSOFT_CLARITY_ID;

export function MicrosoftClarity() {
  // Don't render anything if no Clarity ID is configured
  if (!CLARITY_PROJECT_ID) {
    return null;
  }

  return (
    <Script
      id="microsoft-clarity"
      strategy="afterInteractive"
      dangerouslySetInnerHTML={{
        __html: `
          (function(c,l,a,r,i,t,y){
            c[a]=c[a]||function(){(c[a].q=c[a].q||[]).push(arguments)};
            t=l.createElement(r);t.async=1;t.src="https://www.clarity.ms/tag/"+i;
            y=l.getElementsByTagName(r)[0];y.parentNode.insertBefore(t,y);
          })(window, document, "clarity", "script", "${CLARITY_PROJECT_ID}");
        `,
      }}
    />
  );
}

// Clarity API helper functions for advanced tracking
export const clarityEvents = {
  // Set custom user ID
  identify: (userId: string) => {
    if (typeof window !== "undefined" && window.clarity && CLARITY_PROJECT_ID) {
      window.clarity("identify", userId);
    }
  },

  // Set custom session tags
  setTag: (key: string, value: string) => {
    if (typeof window !== "undefined" && window.clarity && CLARITY_PROJECT_ID) {
      window.clarity("set", key, value);
    }
  },

  // Upgrade session for priority recording
  upgrade: (reason: string) => {
    if (typeof window !== "undefined" && window.clarity && CLARITY_PROJECT_ID) {
      window.clarity("upgrade", reason);
    }
  },

  // Custom event tracking
  event: (eventName: string) => {
    if (typeof window !== "undefined" && window.clarity && CLARITY_PROJECT_ID) {
      window.clarity("event", eventName);
    }
  },
};

// Extend Window interface for TypeScript
declare global {
  interface Window {
    clarity: (
      method: string,
      ...args: (string | Record<string, unknown>)[]
    ) => void;
  }
}
