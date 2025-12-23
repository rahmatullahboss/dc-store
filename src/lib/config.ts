// Site configuration for white-labeling
// Edit these values to customize the store for different brands

export const siteConfig = {
  // Brand Information
  name: process.env.NEXT_PUBLIC_BRAND_NAME || "DC Store",
  description: "Your one-stop shop for quality products",
  logo: process.env.NEXT_PUBLIC_BRAND_LOGO || "/logo.svg",
  url: process.env.NEXT_PUBLIC_APP_URL || "http://localhost:3000",

  // Contact Information
  email: "support@dcstore.com",
  phone: "+880 1234-567890",
  whatsapp: "+8801234567890", // WhatsApp number for chat handoff
  address: "Dhaka, Bangladesh",
  facebookPageId: "dcstore", // Facebook page ID for Messenger

  // Social Links
  social: {
    facebook: "https://facebook.com/dcstore",
    instagram: "https://instagram.com/dcstore",
    twitter: "https://twitter.com/dcstore",
  },

  // Theme Colors (CSS custom properties)
  theme: {
    primaryColor: process.env.NEXT_PUBLIC_PRIMARY_COLOR || "#0F172A",
    accentColor: process.env.NEXT_PUBLIC_ACCENT_COLOR || "#3B82F6",
    backgroundColor: "#FFFFFF",
    textColor: "#0F172A",
  },

  // Currency Settings
  currency: {
    code: "BDT",
    symbol: "৳",
    locale: "bn-BD",
  },

  // Shipping Settings
  shipping: {
    freeShippingThreshold: 1000, // Free shipping over 1000 BDT
    defaultShippingCost: 60,
    expressShippingCost: 120,
  },

  // Store Features
  features: {
    reviews: true,
    wishlist: true,
    compareProducts: false,
    guestCheckout: true,
    multiCurrency: false,
  },

  // SEO
  seo: {
    titleTemplate: "%s | DC Store",
    defaultTitle: "DC Store - Quality Products Online",
    defaultDescription:
      "Shop the best products at DC Store. Fast delivery, secure payment, and great customer service.",
    keywords: ["online store", "ecommerce", "shopping", "bangladesh"],
  },
};

export type SiteConfig = typeof siteConfig;

// Helper function to format currency
export function formatPrice(amount: number): string {
  return new Intl.NumberFormat(siteConfig.currency.locale, {
    style: "currency",
    currency: siteConfig.currency.code,
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
}

// Helper function to generate page title
export function generateTitle(title?: string): string {
  if (!title) return siteConfig.seo.defaultTitle;
  return siteConfig.seo.titleTemplate.replace("%s", title);
}
