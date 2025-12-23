import Link from "next/link";
import { ArrowRight, Zap, Gift, Clock, Percent } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ProductCard } from "@/components/product/product-card";
import { siteConfig } from "@/lib/config";
import type { Product } from "@/db/schema";

// Demo products for initial display - simulating database products
const featuredProducts: Product[] = [
  {
    id: "1",
    name: "Premium Wireless Headphones Pro Max",
    slug: "premium-wireless-headphones",
    description:
      "Experience crystal-clear audio with our premium wireless headphones.",
    shortDescription: "Crystal-clear audio, 40hr battery",
    price: 4999,
    compareAtPrice: 7999,
    costPrice: 2500,
    sku: "WH-001",
    barcode: null,
    quantity: 50,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "Electronics",
    images: [],
    featuredImage:
      "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: true,
    weight: 0.3,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "2",
    name: "Smart Watch Series X Ultra",
    slug: "smart-watch-series-x",
    description: "Stay connected with our premium smartwatch.",
    shortDescription: "Health tracking, GPS, 7-day battery",
    price: 12999,
    compareAtPrice: 15999,
    costPrice: 8000,
    sku: "SW-001",
    barcode: null,
    quantity: 30,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "Electronics",
    images: [],
    featuredImage:
      "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: true,
    weight: 0.1,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "3",
    name: "Designer Leather Bag Premium",
    slug: "designer-leather-bag",
    description: "Elegant leather bag for the modern professional.",
    shortDescription: "Genuine leather, spacious design",
    price: 8499,
    compareAtPrice: null,
    costPrice: 4000,
    sku: "LB-001",
    barcode: null,
    quantity: 20,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "Fashion",
    images: [],
    featuredImage:
      "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: false,
    weight: 0.8,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "4",
    name: "Running Sneakers Pro Max",
    slug: "running-sneakers-pro",
    description: "Performance running shoes for athletes.",
    shortDescription: "Lightweight, maximum comfort",
    price: 6999,
    compareAtPrice: 9999,
    costPrice: 3500,
    sku: "RS-001",
    barcode: null,
    quantity: 45,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "Sports",
    images: [],
    featuredImage:
      "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: false,
    weight: 0.5,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "5",
    name: "Vintage Camera Collection",
    slug: "vintage-camera-collection",
    description: "Classic vintage camera for photography enthusiasts.",
    shortDescription: "Retro design, modern features",
    price: 15999,
    compareAtPrice: 19999,
    costPrice: 10000,
    sku: "VC-001",
    barcode: null,
    quantity: 15,
    lowStockThreshold: 3,
    trackQuantity: true,
    categoryId: "Electronics",
    images: [],
    featuredImage:
      "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: true,
    weight: 0.6,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "6",
    name: "Minimalist Desk Lamp",
    slug: "minimalist-desk-lamp",
    description: "Modern LED desk lamp with adjustable brightness.",
    shortDescription: "Touch control, USB charging",
    price: 2499,
    compareAtPrice: 3499,
    costPrice: 1200,
    sku: "DL-001",
    barcode: null,
    quantity: 60,
    lowStockThreshold: 10,
    trackQuantity: true,
    categoryId: "Home",
    images: [],
    featuredImage:
      "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: false,
    weight: 0.4,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

// Demo offers
const offers = [
  {
    id: "1",
    name: "Flash Sale",
    discount: "50% OFF",
    badge: "HOT",
    icon: Zap,
    color: "from-red-500 to-orange-500",
    bgColor: "bg-red-50",
    iconBg: "bg-red-500",
    timeLeft: "2h 30m",
  },
  {
    id: "2",
    name: "Buy 2 Get 1",
    discount: "FREE",
    badge: "BOGO",
    icon: Gift,
    color: "from-purple-500 to-pink-500",
    bgColor: "bg-purple-50",
    iconBg: "bg-purple-500",
    timeLeft: "5h left",
  },
  {
    id: "3",
    name: "New User",
    discount: "20% OFF",
    badge: "NEW",
    icon: Percent,
    color: "from-blue-500 to-cyan-500",
    bgColor: "bg-blue-50",
    iconBg: "bg-blue-500",
    timeLeft: "Limited",
  },
];

export default function HomePage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-stone-100 text-gray-800">
      {/* Animated Background Elements - hidden on mobile for better LCP */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none hidden md:block">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-amber-200 rounded-full mix-blend-multiply filter blur-xl opacity-30 motion-safe:animate-pulse"></div>
        <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-rose-200 rounded-full mix-blend-multiply filter blur-xl opacity-30 motion-safe:animate-pulse animation-delay-2000"></div>
        <div className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-blue-200 rounded-full mix-blend-multiply filter blur-xl opacity-20 motion-safe:animate-pulse animation-delay-4000"></div>
      </div>

      <div className="relative z-10">
        {/* Hero Section */}
        <section className="relative pt-8 pb-8 sm:pt-24 sm:pb-16 flex items-center justify-center overflow-hidden">
          {/* Floating Elements - hidden on mobile */}
          <div className="absolute inset-0 pointer-events-none hidden md:block">
            <div className="absolute top-20 left-10 w-4 h-4 bg-amber-300 rounded-full opacity-60 motion-safe:animate-bounce animation-delay-1000"></div>
            <div className="absolute top-40 right-20 w-6 h-6 bg-rose-300 rounded-full opacity-50 motion-safe:animate-bounce animation-delay-2000"></div>
            <div className="absolute bottom-40 left-20 w-3 h-3 bg-blue-300 rounded-full opacity-60 motion-safe:animate-bounce animation-delay-3000"></div>
            <div className="absolute bottom-20 right-10 w-5 h-5 bg-amber-200 rounded-full opacity-40 motion-safe:animate-bounce animation-delay-4000"></div>
          </div>

          <div className="container mx-auto px-4 sm:px-6 lg:px-8 text-center relative">
            <div className="space-y-4 sm:space-y-8">
              <div className="space-y-2 sm:space-y-4">
                <h2 className="text-5xl sm:text-7xl md:text-8xl font-black tracking-tighter">
                  <span className="brand-text motion-safe:animate-gradient-x">
                    {siteConfig.name}
                  </span>
                  <br />
                  <span className="text-gray-800">Reimagined</span>
                </h2>
                <div className="h-1 w-24 sm:w-32 bg-gradient-to-r from-amber-400 to-rose-400 mx-auto rounded-full"></div>
              </div>
              <p className="text-base sm:text-2xl text-gray-600 max-w-3xl mx-auto leading-relaxed">
                Experience the future of shopping with our curated collection of
                premium items, delivered with precision and passion.
              </p>
            </div>
          </div>
        </section>

        {/* Hot Deals Section */}
        <section className="py-8 sm:py-12 bg-gradient-to-r from-amber-50 via-rose-50 to-purple-50">
          <div className="container mx-auto px-4 sm:px-6 lg:px-8">
            {/* Section Header */}
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-gradient-to-r from-amber-500 to-rose-500 rounded-xl text-white">
                  <Zap className="w-5 h-5" />
                </div>
                <div>
                  <h2 className="text-xl sm:text-2xl font-bold text-gray-800">
                    🔥 Hot Deals
                  </h2>
                  <p className="text-sm text-gray-500 hidden sm:block">
                    Limited time offers
                  </p>
                </div>
              </div>
              <Link href="/offers">
                <Button variant="outline" size="sm" className="gap-1">
                  View All <ArrowRight className="w-4 h-4" />
                </Button>
              </Link>
            </div>

            {/* Offers Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {offers.map((offer) => (
                <Link
                  key={offer.id}
                  href="/offers"
                  className={`${offer.bgColor} rounded-xl p-4 border border-gray-100 hover:shadow-lg transition-all hover:scale-[1.02]`}
                >
                  <div className="flex items-start justify-between mb-2">
                    <div
                      className={`p-2 rounded-lg ${offer.iconBg} text-white`}
                    >
                      <offer.icon className="w-4 h-4" />
                    </div>
                    <Badge
                      className={`bg-gradient-to-r ${offer.color} text-white text-xs border-0`}
                    >
                      {offer.badge}
                    </Badge>
                  </div>

                  <h3 className="font-bold text-gray-800 mb-1 line-clamp-1">
                    {offer.name}
                  </h3>

                  <p
                    className={`text-lg font-bold bg-gradient-to-r ${offer.color} bg-clip-text text-transparent mb-2`}
                  >
                    {offer.discount}
                  </p>

                  <div className="flex items-center gap-1 text-xs text-gray-500">
                    <Clock className="w-3 h-3" />
                    <span>{offer.timeLeft}</span>
                  </div>
                </Link>
              ))}
            </div>
          </div>
        </section>

        {/* Product Grid Section */}
        <div className="container mx-auto px-2 py-8 sm:px-6 sm:py-16 lg:px-8">
          <section className="space-y-6 sm:space-y-12">
            <div className="text-center space-y-2 sm:space-y-4">
              <h3 className="text-3xl sm:text-5xl font-bold brand-text">
                Our Collection
              </h3>
              <p className="text-base sm:text-xl text-gray-600 max-w-2xl mx-auto">
                Handcrafted experiences, delivered to perfection
              </p>
            </div>

            {/* Products Grid - exact Online-Bazar layout */}
            <div className="grid grid-cols-2 gap-2 sm:gap-6 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
              {featuredProducts.map((product, index) => (
                <ProductCard key={product.id} product={product} index={index} />
              ))}
            </div>

            {/* View All Products Button */}
            <div className="text-center pt-4">
              <Button
                size="lg"
                className="bg-gradient-to-r from-amber-500 to-rose-500 hover:from-amber-600 hover:to-rose-600 text-white rounded-full px-8"
                asChild
              >
                <Link href="/products">
                  View All Products <ArrowRight className="ml-2 h-4 w-4" />
                </Link>
              </Button>
            </div>
          </section>
        </div>
      </div>
    </div>
  );
}
