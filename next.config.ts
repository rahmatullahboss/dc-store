import type { NextConfig } from "next";
import { initOpenNextCloudflareForDev } from "@opennextjs/cloudflare";

// Initialize OpenNext Cloudflare for local development
initOpenNextCloudflareForDev();

import createNextIntlPlugin from 'next-intl/plugin';

const withNextIntl = createNextIntlPlugin();

const nextConfig: NextConfig = {
  // Image optimization configuration
  images: {
    remotePatterns: [
      {
        protocol: "https",
        hostname: "images.unsplash.com",
      },
      {
        protocol: "https",
        hostname: "*.public.blob.vercel-storage.com",
      },
      {
        protocol: "https",
        hostname: "*.r2.cloudflarestorage.com",
      },
      {
        protocol: "https",
        hostname: "res.cloudinary.com",
      },
      {
        protocol: "https",
        hostname: "lh3.googleusercontent.com",
      },
      {
        protocol: "https",
        hostname: "*.googleusercontent.com",
      },
    ],
    formats: ["image/avif", "image/webp"],
    // Optimize for mobile-first loading
    deviceSizes: [360, 414, 640, 750, 828, 1080, 1200, 1920],
    // Cache optimized images for 1 year (60 * 60 * 24 * 365 = 31536000)
    minimumCacheTTL: 31536000,
  },

  // Performance optimizations
  experimental: {
    // Enable React's optimizing compiler
    optimizePackageImports: [
      // Icon libraries (large bundles)
      "lucide-react",
      "react-icons",
      // Radix UI components
      "@radix-ui/react-avatar",
      "@radix-ui/react-checkbox",
      "@radix-ui/react-dialog",
      "@radix-ui/react-dropdown-menu",
      "@radix-ui/react-label",
      "@radix-ui/react-select",
      "@radix-ui/react-separator",
      "@radix-ui/react-slider",
      "@radix-ui/react-slot",
      "@radix-ui/react-switch",
      "@radix-ui/react-tabs",
      // AI SDK packages
      "ai",
      "@ai-sdk/groq",
      "@ai-sdk/react",
      "@ai-sdk/openai-compatible",
      // Utility libraries
      "class-variance-authority",
      "clsx",
      "tailwind-merge",
      "sonner",
      // Form and validation
      "react-hook-form",
      "@hookform/resolvers",
      "zod",
    ],
  },

  // TypeScript strict mode
  typescript: {
    // During development, allow builds with type errors for faster iteration
    // Set to true for production builds
    ignoreBuildErrors: false,
  },

  // Headers for security
  async headers() {
    return [
      {
        source: "/:path*",
        headers: [
          {
            key: "X-DNS-Prefetch-Control",
            value: "on",
          },
          {
            key: "X-Frame-Options",
            value: "SAMEORIGIN",
          },
          {
            key: "X-Content-Type-Options",
            value: "nosniff",
          },
          {
            key: "Referrer-Policy",
            value: "origin-when-cross-origin",
          },
          {
            key: "Content-Security-Policy",
            value: [
              "default-src 'self'",
              // Scripts: self + analytics + payment
              "script-src 'self' 'unsafe-inline' 'unsafe-eval' https://www.googletagmanager.com https://www.google-analytics.com https://connect.facebook.net https://www.clarity.ms https://js.stripe.com",
              // Styles: self + inline for UI components
              "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com",
              // Images: self + analytics pixels + CDNs
              "img-src 'self' data: blob: https: http:",
              // Fonts: self + Google Fonts
              "font-src 'self' https://fonts.gstatic.com",
              // Connect: APIs + analytics endpoints
              "connect-src 'self' https://www.google-analytics.com https://analytics.google.com https://www.googletagmanager.com https://connect.facebook.net https://www.facebook.com https://clarity.ms https://www.clarity.ms https://api.stripe.com https://*.cloudinary.com",
              // Frames: Stripe payment
              "frame-src 'self' https://js.stripe.com https://www.facebook.com",
              // Workers for service workers
              "worker-src 'self' blob:",
            ].join("; "),
          },
        ],
      },
    ];
  },
};

export default withNextIntl(nextConfig);
