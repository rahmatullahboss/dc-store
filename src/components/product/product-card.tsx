"use client";

import Image from "next/image";
import Link from "next/link";
import { ShoppingCart, Eye, Heart, ShoppingBag } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardFooter } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { AddToCartButton } from "@/components/cart/add-to-cart-button";
import { formatPrice } from "@/lib/config";
import { cn } from "@/lib/utils";
import type { Product } from "@/db/schema";

interface ProductCardProps {
  product: Product;
  className?: string;
}

export function ProductCard({ product, className }: ProductCardProps) {
  const discountPercentage = product.compareAtPrice
    ? Math.round(
        ((product.compareAtPrice - product.price) / product.compareAtPrice) *
          100
      )
    : 0;

  const isOutOfStock = product.quantity !== null && product.quantity <= 0;

  return (
    <Card
      className={cn(
        "group overflow-hidden border-0 shadow-sm hover:shadow-xl transition-all duration-300 flex flex-col",
        className
      )}
    >
      <Link href={`/products/${product.slug}`} className="flex-1 flex flex-col">
        {/* Image Container */}
        <div className="relative aspect-square overflow-hidden bg-gradient-to-br from-gray-50 to-gray-100">
          {product.featuredImage ? (
            <Image
              src={product.featuredImage}
              alt={product.name}
              fill
              className="object-cover transition-transform duration-500 group-hover:scale-110"
              sizes="(max-width: 640px) 50vw, (max-width: 1024px) 33vw, 25vw"
            />
          ) : (
            <div className="flex h-full items-center justify-center text-gray-300">
              <ShoppingCart className="h-16 w-16" />
            </div>
          )}

          {/* Badges */}
          <div className="absolute top-2 left-2 flex flex-col gap-1.5">
            {discountPercentage > 0 && (
              <Badge
                variant="destructive"
                className="text-xs font-bold px-2 py-0.5 shadow-md"
              >
                -{discountPercentage}%
              </Badge>
            )}
            {product.isFeatured && (
              <Badge className="text-xs bg-amber-500 hover:bg-amber-600 shadow-md">
                ⭐ Featured
              </Badge>
            )}
            {isOutOfStock && (
              <Badge variant="secondary" className="text-xs shadow-md">
                Out of Stock
              </Badge>
            )}
          </div>

          {/* Quick Actions (visible on hover) */}
          <div className="absolute right-2 top-2 flex flex-col gap-2 opacity-0 translate-x-2 group-hover:opacity-100 group-hover:translate-x-0 transition-all duration-300">
            <Button
              variant="secondary"
              size="icon"
              className="h-9 w-9 rounded-full shadow-md bg-white/90 backdrop-blur-sm hover:bg-white"
            >
              <Heart className="h-4 w-4" />
            </Button>
            <Button
              variant="secondary"
              size="icon"
              className="h-9 w-9 rounded-full shadow-md bg-white/90 backdrop-blur-sm hover:bg-white"
            >
              <Eye className="h-4 w-4" />
            </Button>
          </div>

          {/* Mobile Quick Add (always visible on mobile) */}
          <div className="absolute bottom-2 right-2 sm:hidden">
            <AddToCartButton
              item={{
                id: product.id,
                name: product.name,
                price: product.price,
                image: product.featuredImage || undefined,
              }}
              compact
              className="rounded-full shadow-lg !bg-primary !text-white"
            />
          </div>
        </div>

        {/* Content */}
        <CardContent className="flex-1 p-3 sm:p-4">
          <h3 className="font-medium text-sm sm:text-base line-clamp-2 group-hover:text-primary transition-colors min-h-[2.5rem] sm:min-h-[3rem]">
            {product.name}
          </h3>
          {product.shortDescription && (
            <p className="text-xs text-muted-foreground line-clamp-1 mt-1 hidden sm:block">
              {product.shortDescription}
            </p>
          )}
        </CardContent>
      </Link>

      {/* Footer with Price and Buttons */}
      <CardFooter className="flex flex-col gap-2 sm:flex-row sm:items-center sm:justify-between border-t border-gray-100 bg-gray-50/50 p-3 sm:p-4 mt-auto">
        {/* Price */}
        <div className="flex items-center gap-2 w-full sm:w-auto justify-between sm:justify-start">
          <div className="flex flex-col">
            <span className="text-lg sm:text-xl font-bold text-primary">
              {formatPrice(product.price)}
            </span>
            {product.compareAtPrice &&
              product.compareAtPrice > product.price && (
                <span className="text-xs text-muted-foreground line-through">
                  {formatPrice(product.compareAtPrice)}
                </span>
              )}
          </div>

          {/* Mobile Add Button (on right side of price) */}
          <AddToCartButton
            item={{
              id: product.id,
              name: product.name,
              price: product.price,
              image: product.featuredImage || undefined,
            }}
            compact
            variant="outline"
            className="sm:hidden !border-amber-500 !text-amber-600 hover:!bg-amber-500 hover:!text-white"
          />
        </div>

        {/* Desktop Buttons */}
        <div className="hidden sm:flex gap-2">
          <AddToCartButton
            item={{
              id: product.id,
              name: product.name,
              price: product.price,
              image: product.featuredImage || undefined,
            }}
            compact
            variant="outline"
            className="!border-amber-500 !text-amber-600 hover:!bg-amber-500 hover:!text-white"
          />
          <Button
            size="sm"
            className="bg-gradient-to-r from-primary to-primary/80 hover:from-primary/90 hover:to-primary/70"
            asChild
          >
            <Link href={`/products/${product.slug}`}>
              <ShoppingBag className="h-3 w-3 mr-1" />
              Order
            </Link>
          </Button>
        </div>

        {/* Mobile Order Button (full width) */}
        <Button
          size="sm"
          className="w-full sm:hidden bg-gradient-to-r from-primary to-primary/80"
          asChild
        >
          <Link href={`/products/${product.slug}`}>
            <ShoppingBag className="h-3 w-3 mr-1" />
            Order Now
          </Link>
        </Button>
      </CardFooter>
    </Card>
  );
}
