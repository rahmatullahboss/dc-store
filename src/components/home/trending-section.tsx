"use client";

import { useRef } from "react";
import Image from "next/image";
import { Link } from "@/i18n/routing";
import { ArrowLeft, ArrowRight, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";

const trendingProducts = [
  {
    id: "1",
    name: "Premium Leather Bag",
    description: "Crafted from premium Italian leather, perfect for everyday use.",
    price: 245,
    image: "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&h=400&fit=crop",
    badge: "Best Seller",
  },
  {
    id: "2",
    name: "Wireless Headphones",
    description: "Premium sound quality with active noise cancellation.",
    price: 160,
    image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
  },
  {
    id: "3",
    name: "Smart Watch Pro",
    description: "Track your fitness and stay connected on the go.",
    price: 299,
    image: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop",
  },
];

import { useTranslations } from "next-intl";

export function TrendingSection() {
  const t = useTranslations("HomePage.Trending");
  const scrollRef = useRef<HTMLDivElement>(null);

  const scroll = (direction: "left" | "right") => {
    if (scrollRef.current) {
      const scrollAmount = 340; // Card width + gap
      scrollRef.current.scrollBy({
        left: direction === "left" ? -scrollAmount : scrollAmount,
        behavior: "smooth",
      });
    }
  };

  return (
    <section className="relative z-10 max-w-7xl mx-auto px-4 lg:px-10 py-12 mb-8 lg:mb-12">
      {/* Header */}
      <div className="flex items-center justify-between mb-6 sm:mb-8">
        <h2 className="text-2xl sm:text-3xl md:text-4xl font-bold tracking-tight">
          {t('title')}
        </h2>
        <div className="flex gap-2">
          <Button
            size="icon"
            variant="outline"
            className="size-10 rounded-full"
            onClick={() => scroll("left")}
          >
            <ArrowLeft className="h-4 w-4" />
          </Button>
          <Button
            size="icon"
            className="size-10 rounded-full bg-primary text-primary-foreground hover:bg-primary/90"
            onClick={() => scroll("right")}
          >
            <ArrowRight className="h-4 w-4" />
          </Button>
        </div>
      </div>

      {/* Horizontal Scroll Cards */}
      <div
        ref={scrollRef}
        className="flex gap-4 sm:gap-6 overflow-x-auto hide-scrollbar pb-4 snap-x"
      >
        {trendingProducts.map((product) => (
          <div
            key={product.id}
            className="min-w-[280px] sm:min-w-[320px] md:min-w-[400px] snap-center bg-card rounded-xl overflow-hidden flex flex-col md:flex-row group border border-border hover:border-primary/50 transition-colors"
          >
            {/* Image - Using Next.js Image for optimization */}
            <div className="w-full md:w-2/5 aspect-square md:aspect-auto min-h-[150px] relative">
              <Image
                src={product.image}
                alt={product.name}
                fill
                sizes="(max-width: 768px) 280px, 200px"
                className="object-cover"
              />
            </div>
            {/* Content */}
            <div className="p-4 sm:p-6 flex flex-col justify-center flex-1">
              {product.badge && (
                <div className="flex items-center gap-2 mb-2">
                  <span className="text-primary text-xs font-bold uppercase tracking-wider">
                    {t('bestSeller')}
                  </span>
                </div>
              )}
              <h3 className="font-bold text-lg sm:text-xl mb-2">
                {product.name}
              </h3>
              <p className="text-muted-foreground text-sm mb-4 line-clamp-2">
                {product.description}
              </p>
              <div className="flex items-center justify-between mt-auto">
                <span className="font-bold text-lg">${product.price}</span>
                <Button
                  size="icon"
                  className="size-8 rounded-full bg-foreground text-background hover:bg-primary hover:text-primary-foreground"
                  asChild
                >
                  <Link href="/products">
                    <Plus className="h-4 w-4" />
                  </Link>
                </Button>
              </div>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
}
