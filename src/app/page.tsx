import Link from "next/link";
import { ArrowRight, ShoppingBag } from "lucide-react";
import { Button } from "@/components/ui/button";
import { ProductCard } from "@/components/product/product-card";
import { getFeaturedProducts, getProducts } from "@/lib/queries";
import { HeroSection } from "@/components/home/hero-section";
import { CategoryChips } from "@/components/home/category-chips";
import { PromoBanner } from "@/components/home/promo-banner";
import { TrendingSection } from "@/components/home/trending-section";

// ISR: Cache for 3600 seconds (1 hour), on-demand revalidation via admin actions
export const revalidate = 3600;

export default async function HomePage() {
  // Fetch featured products from database, fallback to all products if no featured
  let featuredProducts = await getFeaturedProducts(8);

  // If no featured products, get latest products
  if (featuredProducts.length === 0) {
    featuredProducts = await getProducts({ limit: 8 });
  }

  return (
    <div className="min-h-screen bg-background text-foreground transition-colors duration-300">
      {/* Hero Section */}
      <HeroSection />

      {/* Category Chips */}
      <CategoryChips />

      {/* New Arrivals Grid */}
      <section className="max-w-7xl mx-auto px-4 lg:px-10 py-8 sm:py-12">
        {/* Section Header */}
        <div className="flex items-center justify-between mb-6 sm:mb-8">
          <div className="flex items-center gap-3">
            <div className="w-1.5 sm:w-2 h-6 sm:h-8 bg-primary rounded-sm" />
            <h2 className="text-2xl sm:text-3xl md:text-4xl font-bold tracking-tight">
              New Arrivals
            </h2>
          </div>
          <Link
            href="/products"
            className="text-muted-foreground hover:text-foreground flex items-center gap-1 text-sm font-medium transition-colors"
          >
            View all <ArrowRight className="h-4 w-4" />
          </Link>
        </div>

        {/* Products Grid */}
        {featuredProducts.length > 0 ? (
          <div className="grid grid-cols-2 gap-3 sm:gap-6 md:grid-cols-3 lg:grid-cols-4">
            {featuredProducts.map((product, index) => (
              <ProductCard key={product.id} product={product} index={index} />
            ))}
          </div>
        ) : (
          <div className="text-center py-12">
            <div className="w-16 h-16 mx-auto bg-primary/20 rounded-full flex items-center justify-center mb-4">
              <ShoppingBag className="w-8 h-8 text-primary" />
            </div>
            <h3 className="text-xl font-bold mb-2">Products Coming Soon!</h3>
            <p className="text-muted-foreground">
              We&apos;re preparing our collection for you.
            </p>
          </div>
        )}

        {/* View All Products Button */}
        {featuredProducts.length > 0 && (
          <div className="text-center pt-6 sm:pt-8">
            <Button
              size="lg"
              className="bg-primary text-primary-foreground hover:bg-primary/90 rounded-full px-8"
              asChild
            >
              <Link href="/products">
                View All Products <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </Button>
          </div>
        )}
      </section>

      {/* Promotional Banner */}
      <PromoBanner />

      {/* Trending Section */}
      <TrendingSection />
    </div>
  );
}
