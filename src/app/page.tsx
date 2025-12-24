import Link from "next/link";
import { ArrowRight, Zap, Gift, Clock, Percent, ShoppingBag } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ProductCard } from "@/components/product/product-card";
import { siteConfig } from "@/lib/config";
import { getFeaturedProducts, getProducts } from "@/lib/queries";

// Force dynamic rendering for Cloudflare context
export const dynamic = "force-dynamic";

// Demo offers (will be replaced with database offers later)
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

export default async function HomePage() {
  // Fetch featured products from database, fallback to all products if no featured
  let featuredProducts = await getFeaturedProducts(6);
  
  // If no featured products, get latest products
  if (featuredProducts.length === 0) {
    featuredProducts = await getProducts({ limit: 6 });
  }

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

            {/* Offers Grid - Horizontal scroll on mobile */}
            <div className="flex gap-3 overflow-x-auto pb-2 sm:grid sm:grid-cols-2 lg:grid-cols-3 sm:gap-4 sm:overflow-visible scrollbar-hide">
              {offers.map((offer) => (
                <Link
                  key={offer.id}
                  href="/offers"
                  className={`${offer.bgColor} rounded-xl p-3 sm:p-4 border border-gray-100 hover:shadow-lg transition-all hover:scale-[1.02] flex-shrink-0 w-[160px] sm:w-auto`}
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

                  <h3 className="font-bold text-gray-800 mb-0.5 sm:mb-1 text-sm sm:text-base line-clamp-1">
                    {offer.name}
                  </h3>

                  <p
                    className={`text-base sm:text-lg font-bold bg-gradient-to-r ${offer.color} bg-clip-text text-transparent mb-1 sm:mb-2`}
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

            {/* Products Grid */}
            {featuredProducts.length > 0 ? (
              <div className="grid grid-cols-2 gap-2 sm:gap-6 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                {featuredProducts.map((product, index) => (
                  <ProductCard key={product.id} product={product} index={index} />
                ))}
              </div>
            ) : (
              <div className="text-center py-12">
                <div className="w-16 h-16 mx-auto bg-gradient-to-r from-amber-100 to-rose-100 rounded-full flex items-center justify-center mb-4">
                  <ShoppingBag className="w-8 h-8 text-amber-600" />
                </div>
                <h3 className="text-xl font-bold text-gray-800 mb-2">
                  Products Coming Soon!
                </h3>
                <p className="text-gray-500">
                  We&apos;re preparing our collection for you.
                </p>
              </div>
            )}

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

