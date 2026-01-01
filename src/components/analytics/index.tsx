/**
 * Analytics Provider - Central hub for all analytics tracking
 *
 * This component loads all analytics scripts based on environment variables.
 * Only scripts with configured IDs will be loaded.
 *
 * Environment Variables Required:
 * - NEXT_PUBLIC_GOOGLE_ANALYTICS_ID (GA4 Measurement ID like G-XXXXXXXX)
 * - NEXT_PUBLIC_GOOGLE_TAG_MANAGER_ID (GTM Container ID like GTM-XXXXXXX)
 * - NEXT_PUBLIC_MICROSOFT_CLARITY_ID (Clarity Project ID)
 * - NEXT_PUBLIC_FACEBOOK_PIXEL_ID (Facebook Pixel ID)
 */

import { FacebookPixel } from "./facebook-pixel";
import { MicrosoftClarity } from "./microsoft-clarity";
import { GoogleAnalytics } from "./google-analytics";
import { GoogleTagManager } from "./google-tag-manager";

export function AnalyticsProvider() {
  return (
    <>
      {/* Google Tag Manager - Should be first for optimal loading */}
      <GoogleTagManager />

      {/* Google Analytics 4 - Skip if using GTM for GA4 */}
      <GoogleAnalytics />

      {/* Microsoft Clarity - Session recordings & heatmaps */}
      <MicrosoftClarity />

      {/* Facebook Pixel - Meta ads tracking */}
      <FacebookPixel />
    </>
  );
}

// Re-export individual event helpers for convenience
export { fbEvents, trackFBEvent } from "./facebook-pixel";
export { gaEvents, sendGAEvent } from "./google-analytics";
export { gtmEvents, pushToDataLayer } from "./google-tag-manager";
export { clarityEvents } from "./microsoft-clarity";
