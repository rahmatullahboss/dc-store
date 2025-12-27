"use client";

import Image from "next/image";
import Link from "next/link";
import { ShoppingCart } from "lucide-react";
import {
  Card,
  CardHeader,
  CardTitle,
  CardDescription,
} from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { ProductCardFooter } from "./product-card-footer";
import type { Product } from "@/db/schema";

interface ProductCardProps {
  product: Product;
  index?: number;
}

export function ProductCard({ product, index = 0 }: ProductCardProps) {
  const discountPercentage = product.compareAtPrice
    ? Math.round(
        ((product.compareAtPrice - product.price) / product.compareAtPrice) *
          100
      )
    : 0;

  return (
    <Card
      className="group relative overflow-hidden rounded-xl sm:rounded-3xl border border-border bg-card shadow-md sm:shadow-xl transition-all duration-300 sm:duration-700 ease-out hover:shadow-lg sm:hover:scale-[1.02] sm:hover:shadow-2xl sm:hover:shadow-primary/20 sm:hover:border-primary/60 gap-0 p-0"
      style={{ animationDelay: `${index * 100}ms` }}
    >
      <div className="relative z-10 h-full flex flex-col">
        <Link href={`/products/${product.slug}`} className="block">
          {/* Product Image */}
          <div className="relative aspect-square sm:aspect-[5/4] overflow-hidden rounded-t-xl sm:rounded-t-3xl">
            {product.featuredImage ? (
              <Image
                src={product.featuredImage}
                alt={product.name}
                fill
                sizes="(max-width: 640px) 50vw, (max-width: 1024px) 50vw, 25vw"
                className="object-cover transition-all duration-300 sm:duration-700 ease-out group-hover:scale-105 sm:group-hover:scale-110"
                priority={index < 2}
              />
            ) : (
              <div className="flex h-full items-center justify-center bg-muted">
                <ShoppingCart className="h-12 w-12 text-muted-foreground" />
              </div>
            )}

            {/* Offer/Discount Badge - Top Left */}
            {discountPercentage > 0 && (
              <div className="absolute top-2 left-2 sm:top-4 sm:left-4 z-10">
                <Badge
                  variant="destructive"
                  className="bg-gradient-to-r from-red-500 to-rose-500 text-white border-0 shadow-md text-[10px] sm:text-xs font-bold px-1.5 py-0.5 sm:px-2 sm:py-1"
                >
                  -{discountPercentage}% OFF
                </Badge>
              </div>
            )}

            {/* Category Badge - Top Right */}
            {product.categoryId && (
              <div className="absolute top-2 right-2 sm:top-4 sm:right-4">
                <Badge
                  variant="secondary"
                  className="bg-background/90 text-foreground border border-border shadow text-[10px] sm:text-xs font-medium px-1.5 py-0.5 sm:px-3 sm:py-1"
                >
                  {product.categoryId}
                </Badge>
              </div>
            )}

            {/* Featured Badge */}
            {product.isFeatured && (
              <div className="absolute bottom-2 left-2 sm:bottom-4 sm:left-4 z-10">
                <Badge className="bg-primary text-primary-foreground border-0 shadow-md text-[10px] sm:text-xs font-medium px-1.5 py-0.5 sm:px-2 sm:py-1">
                  ⭐ Featured
                </Badge>
              </div>
            )}
          </div>

          {/* Card Header - Title & Description */}
          <CardHeader className="p-1.5 sm:p-3 space-y-0.5 sm:space-y-2">
            <CardTitle className="text-sm sm:text-lg font-semibold sm:font-bold text-foreground leading-tight line-clamp-2">
              {product.name}
            </CardTitle>
            <CardDescription className="hidden sm:block text-muted-foreground text-sm leading-relaxed line-clamp-2">
              {product.shortDescription || product.description}
            </CardDescription>
          </CardHeader>
        </Link>

        {/* Footer with Price and Buttons */}
        <ProductCardFooter
          product={product}
          originalPrice={product.compareAtPrice || undefined}
          discountedPrice={discountPercentage > 0 ? product.price : undefined}
        />
      </div>
    </Card>
  );
}
