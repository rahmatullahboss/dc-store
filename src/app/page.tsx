import Link from "next/link";
import Image from "next/image";
import {
  ArrowRight,
  Truck,
  Shield,
  RefreshCcw,
  Clock,
  Star,
  Zap,
  Gift,
  Percent,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ProductCard } from "@/components/product/product-card";
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
    categoryId: "electronics",
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
    categoryId: "electronics",
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
    categoryId: "fashion",
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
    quantity: 0,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "sports",
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
];

const categories = [
  {
    name: "Electronics",
    image:
      "https://images.unsplash.com/photo-1498049794561-7780e7231661?w=300&h=300&fit=crop",
    slug: "electronics",
    count: 120,
  },
  {
    name: "Fashion",
    image:
      "https://images.unsplash.com/photo-1445205170230-053b83016050?w=300&h=300&fit=crop",
    slug: "fashion",
    count: 250,
  },
  {
    name: "Home & Living",
    image:
      "https://images.unsplash.com/photo-1484101403633-562f891dc89a?w=300&h=300&fit=crop",
    slug: "home-living",
    count: 180,
  },
  {
    name: "Sports & Fitness",
    image:
      "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=300&fit=crop",
    slug: "sports",
    count: 95,
  },
];

const features = [
  {
    icon: Truck,
    title: "Free Shipping",
    description: "On orders over ৳1000",
    color: "bg-blue-500",
  },
  {
    icon: Shield,
    title: "Secure Payment",
    description: "100% secure checkout",
    color: "bg-green-500",
  },
  {
    icon: RefreshCcw,
    title: "Easy Returns",
    description: "7-day return policy",
    color: "bg-purple-500",
  },
  {
    icon: Clock,
    title: "Fast Delivery",
    description: "2-5 business days",
    color: "bg-orange-500",
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
    timeLeft: "Limited",
  },
];

export default function HomePage() {
  return (
    <div className="space-y-12 sm:space-y-16 pb-20 md:pb-16">
      {/* Hero Section */}
      <section className="relative overflow-hidden bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900">
        {/* Animated background elements */}
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute -top-40 -right-40 h-80 w-80 rounded-full bg-blue-500/20 blur-3xl animate-pulse" />
          <div className="absolute -bottom-40 -left-40 h-80 w-80 rounded-full bg-purple-500/20 blur-3xl animate-pulse delay-1000" />
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 h-96 w-96 rounded-full bg-indigo-500/10 blur-3xl" />
        </div>

        <div className="container relative px-4 py-16 sm:py-24 md:py-32 lg:py-40">
          <div className="mx-auto max-w-4xl text-center">
            <Badge className="mb-4 sm:mb-6 bg-white/10 text-white hover:bg-white/20 border-0 px-4 py-1.5">
              ✨ New Arrivals Just Dropped
            </Badge>
            <h1 className="text-3xl sm:text-4xl md:text-5xl lg:text-6xl xl:text-7xl font-bold tracking-tight text-white">
              Discover Your
              <span className="block bg-gradient-to-r from-blue-400 via-purple-400 to-pink-400 bg-clip-text text-transparent">
                Perfect Style
              </span>
            </h1>
            <p className="mx-auto mt-4 sm:mt-6 max-w-2xl text-base sm:text-lg text-slate-300 md:text-xl px-4">
              Shop the latest trends with exclusive deals. Quality products,
              fast delivery, and exceptional service.
            </p>
            <div className="mt-8 sm:mt-10 flex flex-col sm:flex-row items-center justify-center gap-3 sm:gap-4 px-4">
              <Button
                size="lg"
                className="w-full sm:w-auto bg-white text-slate-900 hover:bg-slate-100 h-12 px-8 text-base"
                asChild
              >
                <Link href="/products">
                  Shop Now <ArrowRight className="ml-2 h-4 w-4" />
                </Link>
              </Button>
              <Button
                size="lg"
                variant="outline"
                className="w-full sm:w-auto border-white/30 text-white hover:bg-white/10 h-12 px-8 text-base"
                asChild
              >
                <Link href="/categories">Browse Categories</Link>
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* Hot Offers Section */}
      <section className="container px-4">
        <div className="flex items-center justify-between mb-6">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-gradient-to-r from-amber-500 to-rose-500 rounded-xl text-white">
              <Zap className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-xl sm:text-2xl font-bold">🔥 Hot Deals</h2>
              <p className="text-sm text-muted-foreground hidden sm:block">
                Limited time offers
              </p>
            </div>
          </div>
          <Button variant="outline" size="sm" asChild>
            <Link href="/offers">
              View All <ArrowRight className="ml-2 h-4 w-4" />
            </Link>
          </Button>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
          {offers.map((offer) => (
            <Link
              key={offer.id}
              href="/offers"
              className={`${offer.bgColor} rounded-xl p-4 sm:p-5 border border-gray-100 hover:shadow-lg transition-all hover:scale-[1.02] group`}
            >
              <div className="flex items-start justify-between mb-3">
                <div
                  className={`p-2.5 rounded-xl bg-gradient-to-r ${offer.color} text-white shadow-lg`}
                >
                  <offer.icon className="w-5 h-5" />
                </div>
                <Badge
                  className={`bg-gradient-to-r ${offer.color} text-white border-0 shadow-md`}
                >
                  {offer.badge}
                </Badge>
              </div>
              <h3 className="font-bold text-gray-800 mb-1">{offer.name}</h3>
              <p
                className={`text-2xl font-bold bg-gradient-to-r ${offer.color} bg-clip-text text-transparent mb-2`}
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
      </section>

      {/* Features */}
      <section className="container px-4">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3 sm:gap-6">
          {features.map((feature) => (
            <Card
              key={feature.title}
              className="border-0 shadow-sm hover:shadow-md transition-all duration-300 hover:-translate-y-1"
            >
              <CardContent className="flex flex-col items-center text-center p-4 sm:p-6">
                <div
                  className={`h-10 w-10 sm:h-12 sm:w-12 rounded-full ${feature.color} flex items-center justify-center mb-3 sm:mb-4 shadow-lg`}
                >
                  <feature.icon className="h-5 w-5 sm:h-6 sm:w-6 text-white" />
                </div>
                <h3 className="font-semibold text-sm sm:text-base">
                  {feature.title}
                </h3>
                <p className="text-xs sm:text-sm text-muted-foreground mt-1">
                  {feature.description}
                </p>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      {/* Categories */}
      <section className="container px-4">
        <div className="flex items-center justify-between mb-6 sm:mb-8">
          <div>
            <h2 className="text-xl sm:text-2xl font-bold md:text-3xl">
              Shop by Category
            </h2>
            <p className="text-muted-foreground mt-1 text-sm sm:text-base">
              Find what you&apos;re looking for
            </p>
          </div>
          <Button variant="ghost" size="sm" asChild>
            <Link href="/categories">
              View All <ArrowRight className="ml-2 h-4 w-4" />
            </Link>
          </Button>
        </div>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3 sm:gap-6">
          {categories.map((category) => (
            <Link
              key={category.slug}
              href={`/products?category=${category.slug}`}
              className="group relative aspect-square overflow-hidden rounded-2xl shadow-md hover:shadow-xl transition-all duration-300"
            >
              <Image
                src={category.image}
                alt={category.name}
                fill
                className="object-cover transition-transform duration-500 group-hover:scale-110"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent" />
              <div className="absolute bottom-3 sm:bottom-4 left-3 sm:left-4 right-3 sm:right-4">
                <h3 className="text-base sm:text-lg font-bold text-white">
                  {category.name}
                </h3>
                <p className="text-xs sm:text-sm text-white/80">
                  {category.count}+ Products
                </p>
              </div>
            </Link>
          ))}
        </div>
      </section>

      {/* Featured Products */}
      <section className="container px-4">
        <div className="flex items-center justify-between mb-6 sm:mb-8">
          <div>
            <h2 className="text-xl sm:text-2xl font-bold md:text-3xl">
              Featured Products
            </h2>
            <p className="text-muted-foreground mt-1 text-sm sm:text-base">
              Handpicked just for you
            </p>
          </div>
          <Button variant="ghost" size="sm" asChild>
            <Link href="/products">
              View All <ArrowRight className="ml-2 h-4 w-4" />
            </Link>
          </Button>
        </div>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-3 sm:gap-6">
          {featuredProducts.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))}
        </div>
      </section>

      {/* Testimonials */}
      <section className="container px-4">
        <div className="text-center mb-8">
          <h2 className="text-xl sm:text-2xl font-bold md:text-3xl">
            What Our Customers Say
          </h2>
          <p className="text-muted-foreground mt-1">
            Trusted by thousands of happy customers
          </p>
        </div>
        <div className="grid md:grid-cols-3 gap-6">
          {[
            {
              name: "Sarah J.",
              rating: 5,
              comment:
                "Amazing quality and super fast delivery! Will definitely order again.",
              avatar: "S",
            },
            {
              name: "Mike R.",
              rating: 5,
              comment:
                "Best online shopping experience. The products exceeded my expectations.",
              avatar: "M",
            },
            {
              name: "Lisa K.",
              rating: 5,
              comment:
                "Great customer service and the return process was hassle-free.",
              avatar: "L",
            },
          ].map((review, index) => (
            <Card key={index} className="border-0 shadow-sm">
              <CardContent className="p-6">
                <div className="flex items-center gap-1 mb-3">
                  {Array.from({ length: review.rating }).map((_, i) => (
                    <Star
                      key={i}
                      className="h-4 w-4 fill-amber-400 text-amber-400"
                    />
                  ))}
                </div>
                <p className="text-muted-foreground mb-4">
                  &quot;{review.comment}&quot;
                </p>
                <div className="flex items-center gap-3">
                  <div className="h-10 w-10 rounded-full bg-gradient-to-r from-primary to-primary/60 flex items-center justify-center text-white font-bold">
                    {review.avatar}
                  </div>
                  <span className="font-medium">{review.name}</span>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      {/* CTA Section */}
      <section className="container px-4">
        <Card className="relative overflow-hidden border-0 bg-gradient-to-r from-blue-600 to-purple-600">
          <div className="absolute inset-0 overflow-hidden">
            <div className="absolute -top-20 -right-20 h-60 w-60 rounded-full bg-white/10 blur-3xl" />
            <div className="absolute -bottom-20 -left-20 h-60 w-60 rounded-full bg-white/10 blur-3xl" />
          </div>
          <CardContent className="relative p-6 sm:p-8 md:p-12 lg:p-16 text-center">
            <h2 className="text-xl sm:text-2xl md:text-3xl lg:text-4xl font-bold text-white">
              Get 20% Off Your First Order
            </h2>
            <p className="mt-3 sm:mt-4 text-white/80 max-w-2xl mx-auto text-sm sm:text-base">
              Subscribe to our newsletter and receive exclusive offers, new
              arrivals updates, and special discounts.
            </p>
            <div className="mt-6 sm:mt-8 flex flex-col sm:flex-row items-center justify-center gap-3 sm:gap-4 max-w-md mx-auto">
              <input
                type="email"
                placeholder="Enter your email"
                className="w-full px-4 py-3 rounded-lg bg-white/10 border border-white/20 text-white placeholder:text-white/60 focus:outline-none focus:ring-2 focus:ring-white/30"
              />
              <Button
                size="lg"
                className="w-full sm:w-auto bg-white text-blue-600 hover:bg-slate-100"
              >
                Subscribe
              </Button>
            </div>
          </CardContent>
        </Card>
      </section>
    </div>
  );
}
