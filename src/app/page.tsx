import Link from "next/link";
import Image from "next/image";
import { ArrowRight, Truck, Shield, RefreshCcw, Clock } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { formatPrice } from "@/lib/config";

// Demo products for initial display
const featuredProducts = [
  {
    id: "1",
    name: "Premium Wireless Headphones",
    slug: "premium-wireless-headphones",
    price: 4999,
    compareAtPrice: 7999,
    featuredImage:
      "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
  },
  {
    id: "2",
    name: "Smart Watch Series X",
    slug: "smart-watch-series-x",
    price: 12999,
    compareAtPrice: 15999,
    featuredImage:
      "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop",
  },
  {
    id: "3",
    name: "Designer Leather Bag",
    slug: "designer-leather-bag",
    price: 8499,
    compareAtPrice: null,
    featuredImage:
      "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&h=400&fit=crop",
  },
  {
    id: "4",
    name: "Running Sneakers Pro",
    slug: "running-sneakers-pro",
    price: 6999,
    compareAtPrice: 9999,
    featuredImage:
      "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop",
  },
];

const categories = [
  {
    name: "Electronics",
    image:
      "https://images.unsplash.com/photo-1498049794561-7780e7231661?w=300&h=300&fit=crop",
    slug: "electronics",
  },
  {
    name: "Fashion",
    image:
      "https://images.unsplash.com/photo-1445205170230-053b83016050?w=300&h=300&fit=crop",
    slug: "fashion",
  },
  {
    name: "Home & Living",
    image:
      "https://images.unsplash.com/photo-1484101403633-562f891dc89a?w=300&h=300&fit=crop",
    slug: "home-living",
  },
  {
    name: "Sports",
    image:
      "https://images.unsplash.com/photo-1461896836934- voices-21c7f4c?w=300&h=300&fit=crop",
    slug: "sports",
  },
];

const features = [
  { icon: Truck, title: "Free Shipping", description: "On orders over ৳1000" },
  {
    icon: Shield,
    title: "Secure Payment",
    description: "100% secure checkout",
  },
  {
    icon: RefreshCcw,
    title: "Easy Returns",
    description: "7-day return policy",
  },
  { icon: Clock, title: "Fast Delivery", description: "2-5 business days" },
];

export default function HomePage() {
  return (
    <div className="space-y-16 pb-16">
      {/* Hero Section */}
      <section className="relative overflow-hidden bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900">
        {/* Animated background elements */}
        <div className="absolute inset-0 overflow-hidden">
          <div className="absolute -top-40 -right-40 h-80 w-80 rounded-full bg-blue-500/20 blur-3xl" />
          <div className="absolute -bottom-40 -left-40 h-80 w-80 rounded-full bg-purple-500/20 blur-3xl" />
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 h-96 w-96 rounded-full bg-indigo-500/10 blur-3xl" />
        </div>

        <div className="container relative px-4 py-24 md:py-32 lg:py-40">
          <div className="mx-auto max-w-4xl text-center">
            <Badge className="mb-6 bg-white/10 text-white hover:bg-white/20 border-0">
              ✨ New Arrivals Just Dropped
            </Badge>
            <h1 className="text-4xl font-bold tracking-tight text-white sm:text-5xl md:text-6xl lg:text-7xl">
              Discover Your
              <span className="block bg-gradient-to-r from-blue-400 via-purple-400 to-pink-400 bg-clip-text text-transparent">
                Perfect Style
              </span>
            </h1>
            <p className="mx-auto mt-6 max-w-2xl text-lg text-slate-300 md:text-xl">
              Shop the latest trends with exclusive deals. Quality products,
              fast delivery, and exceptional service - all in one place.
            </p>
            <div className="mt-10 flex flex-col sm:flex-row items-center justify-center gap-4">
              <Button
                size="lg"
                className="w-full sm:w-auto bg-white text-slate-900 hover:bg-slate-100"
                asChild
              >
                <Link href="/products">
                  Shop Now <ArrowRight className="ml-2 h-4 w-4" />
                </Link>
              </Button>
              <Button
                size="lg"
                variant="outline"
                className="w-full sm:w-auto border-white/20 text-white hover:bg-white/10"
                asChild
              >
                <Link href="/categories">Browse Categories</Link>
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* Features */}
      <section className="container px-4">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
          {features.map((feature) => (
            <Card
              key={feature.title}
              className="border-0 shadow-sm hover:shadow-md transition-shadow"
            >
              <CardContent className="flex flex-col items-center text-center p-6">
                <div className="h-12 w-12 rounded-full bg-primary/10 flex items-center justify-center mb-4">
                  <feature.icon className="h-6 w-6 text-primary" />
                </div>
                <h3 className="font-semibold">{feature.title}</h3>
                <p className="text-sm text-muted-foreground mt-1">
                  {feature.description}
                </p>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      {/* Categories */}
      <section className="container px-4">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-2xl font-bold md:text-3xl">Shop by Category</h2>
            <p className="text-muted-foreground mt-1">
              Find what you&apos;re looking for
            </p>
          </div>
          <Button variant="ghost" asChild>
            <Link href="/categories">
              View All <ArrowRight className="ml-2 h-4 w-4" />
            </Link>
          </Button>
        </div>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6">
          {categories.map((category) => (
            <Link
              key={category.slug}
              href={`/products?category=${category.slug}`}
              className="group relative aspect-square overflow-hidden rounded-2xl"
            >
              <Image
                src={category.image}
                alt={category.name}
                fill
                className="object-cover transition-transform duration-500 group-hover:scale-110"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
              <div className="absolute bottom-4 left-4 right-4">
                <h3 className="text-lg font-semibold text-white">
                  {category.name}
                </h3>
              </div>
            </Link>
          ))}
        </div>
      </section>

      {/* Featured Products */}
      <section className="container px-4">
        <div className="flex items-center justify-between mb-8">
          <div>
            <h2 className="text-2xl font-bold md:text-3xl">
              Featured Products
            </h2>
            <p className="text-muted-foreground mt-1">
              Handpicked just for you
            </p>
          </div>
          <Button variant="ghost" asChild>
            <Link href="/products">
              View All <ArrowRight className="ml-2 h-4 w-4" />
            </Link>
          </Button>
        </div>
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 md:gap-6">
          {featuredProducts.map((product) => (
            <Link
              key={product.id}
              href={`/products/${product.slug}`}
              className="group"
            >
              <Card className="overflow-hidden border-0 shadow-sm hover:shadow-lg transition-all duration-300">
                <div className="relative aspect-square overflow-hidden">
                  <Image
                    src={product.featuredImage}
                    alt={product.name}
                    fill
                    className="object-cover transition-transform duration-500 group-hover:scale-110"
                  />
                  {product.compareAtPrice && (
                    <Badge
                      variant="destructive"
                      className="absolute top-2 left-2"
                    >
                      -
                      {Math.round(
                        ((product.compareAtPrice - product.price) /
                          product.compareAtPrice) *
                          100
                      )}
                      %
                    </Badge>
                  )}
                </div>
                <CardContent className="p-4">
                  <h3 className="font-medium line-clamp-2 group-hover:text-primary transition-colors">
                    {product.name}
                  </h3>
                  <div className="flex items-center gap-2 mt-2">
                    <span className="text-lg font-bold text-primary">
                      {formatPrice(product.price)}
                    </span>
                    {product.compareAtPrice && (
                      <span className="text-sm text-muted-foreground line-through">
                        {formatPrice(product.compareAtPrice)}
                      </span>
                    )}
                  </div>
                </CardContent>
              </Card>
            </Link>
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
          <CardContent className="relative p-8 md:p-12 lg:p-16 text-center">
            <h2 className="text-2xl md:text-3xl lg:text-4xl font-bold text-white">
              Get 20% Off Your First Order
            </h2>
            <p className="mt-4 text-white/80 max-w-2xl mx-auto">
              Subscribe to our newsletter and receive exclusive offers, new
              arrivals updates, and special discounts.
            </p>
            <div className="mt-8 flex flex-col sm:flex-row items-center justify-center gap-4 max-w-md mx-auto">
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
