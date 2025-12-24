// Site configuration for white-labeling
// All values can be customized via environment variables for easy brand switching

export const siteConfig = {
  // Brand Information
  name: process.env.NEXT_PUBLIC_BRAND_NAME || "DC Store",
  description: process.env.NEXT_PUBLIC_BRAND_DESCRIPTION || "Your one-stop shop for quality products",
  logo: process.env.NEXT_PUBLIC_BRAND_LOGO || "/logo.svg",
  url: process.env.NEXT_PUBLIC_APP_URL || "https://dcstore.digitalcare.site",

  // Contact Information
  email: process.env.NEXT_PUBLIC_CONTACT_EMAIL || "support@digitalcare.site",
  phone: process.env.NEXT_PUBLIC_CONTACT_PHONE || "+880 1234-567890",
  whatsapp: process.env.NEXT_PUBLIC_WHATSAPP_NUMBER || "+8801234567890",
  address: process.env.NEXT_PUBLIC_STORE_ADDRESS || "Dhaka, Bangladesh",
  facebookPageId: process.env.NEXT_PUBLIC_FACEBOOK_PAGE_ID || "dcstore",

  // Social Links
  social: {
    facebook: process.env.NEXT_PUBLIC_SOCIAL_FACEBOOK || "https://facebook.com/dcstore",
    instagram: process.env.NEXT_PUBLIC_SOCIAL_INSTAGRAM || "https://instagram.com/dcstore",
    twitter: process.env.NEXT_PUBLIC_SOCIAL_TWITTER || "https://twitter.com/dcstore",
  },

  // Theme Colors (CSS custom properties)
  theme: {
    primaryColor: process.env.NEXT_PUBLIC_PRIMARY_COLOR || "#0F172A",
    accentColor: process.env.NEXT_PUBLIC_ACCENT_COLOR || "#3B82F6",
    backgroundColor: process.env.NEXT_PUBLIC_BG_COLOR || "#FFFFFF",
    textColor: process.env.NEXT_PUBLIC_TEXT_COLOR || "#0F172A",
  },

  // Currency Settings
  currency: {
    code: process.env.NEXT_PUBLIC_CURRENCY_CODE || "BDT",
    symbol: process.env.NEXT_PUBLIC_CURRENCY_SYMBOL || "৳",
    locale: process.env.NEXT_PUBLIC_CURRENCY_LOCALE || "bn-BD",
  },

  // Shipping Settings
  shipping: {
    freeShippingThreshold: Number(process.env.NEXT_PUBLIC_FREE_SHIPPING_THRESHOLD) || 1000,
    defaultShippingCost: Number(process.env.NEXT_PUBLIC_DEFAULT_SHIPPING) || 60,
    expressShippingCost: Number(process.env.NEXT_PUBLIC_EXPRESS_SHIPPING) || 120,
  },

  // Store Features
  features: {
    reviews: process.env.NEXT_PUBLIC_FEATURE_REVIEWS !== "false",
    wishlist: process.env.NEXT_PUBLIC_FEATURE_WISHLIST !== "false",
    compareProducts: process.env.NEXT_PUBLIC_FEATURE_COMPARE === "true",
    guestCheckout: process.env.NEXT_PUBLIC_FEATURE_GUEST_CHECKOUT !== "false",
    multiCurrency: process.env.NEXT_PUBLIC_FEATURE_MULTI_CURRENCY === "true",
  },

  // SEO
  seo: {
    titleTemplate: process.env.NEXT_PUBLIC_SEO_TITLE_TEMPLATE || `%s | ${process.env.NEXT_PUBLIC_BRAND_NAME || "DC Store"}`,
    defaultTitle: process.env.NEXT_PUBLIC_SEO_DEFAULT_TITLE || `${process.env.NEXT_PUBLIC_BRAND_NAME || "DC Store"} - Quality Products Online`,
    defaultDescription: process.env.NEXT_PUBLIC_SEO_DESCRIPTION ||
      `Shop the best products at ${process.env.NEXT_PUBLIC_BRAND_NAME || "DC Store"}. Fast delivery, secure payment, and great customer service.`,
    keywords: (process.env.NEXT_PUBLIC_SEO_KEYWORDS || "online store,ecommerce,shopping,bangladesh").split(","),
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
