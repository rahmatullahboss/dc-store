"use client";

import { useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { Heart, ShoppingCart, Trash2, ArrowRight, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { useCart } from "@/lib/cart-context";
import type { Product } from "@/db/schema";

// Demo wishlist data
const demoWishlistItems: Product[] = [
  {
    id: "1",
    name: "Premium Wireless Headphones Pro Max",
    slug: "premium-wireless-headphones",
    description: "Crystal-clear audio with noise cancellation",
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
    featuredImage: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
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
    description: "Stay connected with health monitoring",
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
    featuredImage: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop",
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
    id: "4",
    name: "Running Sneakers Pro Max",
    slug: "running-sneakers-pro",
    description: "Lightweight performance shoes",
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
    featuredImage: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop",
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

export default function WishlistPage() {
  const [wishlistItems, setWishlistItems] = useState(demoWishlistItems);
  const [removingId, setRemovingId] = useState<string | null>(null);
  const [addingId, setAddingId] = useState<string | null>(null);
  const { addItem } = useCart();

  const handleRemove = (productId: string) => {
    setRemovingId(productId);
    setTimeout(() => {
      setWishlistItems((prev) => prev.filter((item) => item.id !== productId));
      setRemovingId(null);
    }, 300);
  };

  const handleAddToCart = (product: Product) => {
    setAddingId(product.id);
    addItem({
      productId: product.id,
      name: product.name,
      price: product.price,
      quantity: 1,
      image: product.featuredImage || undefined,
    });
    setTimeout(() => {
      setAddingId(null);
    }, 1000);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-amber-50 via-white to-rose-50">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Header */}
        <div className="mb-8">
          <div className="flex items-center gap-3 mb-2">
            <div className="p-2 bg-gradient-to-r from-rose-500 to-pink-500 rounded-lg text-white">
              <Heart className="w-5 h-5" />
            </div>
            <h1 className="text-2xl sm:text-3xl font-bold text-gray-800">My Wishlist</h1>
          </div>
          <p className="text-gray-500">
            {wishlistItems.length} {wishlistItems.length === 1 ? "item" : "items"} saved
          </p>
        </div>

        {wishlistItems.length === 0 ? (
          /* Empty State */
          <Card className="max-w-md mx-auto text-center bg-white/80 backdrop-blur">
            <CardContent className="pt-12 pb-8">
              <div className="w-24 h-24 mx-auto bg-rose-100 rounded-full flex items-center justify-center mb-6">
                <Heart className="w-12 h-12 text-rose-400" />
              </div>
              <h2 className="text-xl font-bold text-gray-800 mb-2">Your wishlist is empty</h2>
              <p className="text-gray-500 mb-6">
                Start adding products you love to your wishlist!
              </p>
              <Link href="/products">
                <Button className="bg-gradient-to-r from-amber-500 to-rose-500 text-white gap-2">
                  Start Shopping
                  <ArrowRight className="w-4 h-4" />
                </Button>
              </Link>
            </CardContent>
          </Card>
        ) : (
          /* Wishlist Grid */
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {wishlistItems.map((product) => {
              const discountPercentage = product.compareAtPrice
                ? Math.round(
                    ((product.compareAtPrice - product.price) / product.compareAtPrice) * 100
                  )
                : 0;

              return (
                <Card
                  key={product.id}
                  className="group overflow-hidden bg-white/80 backdrop-blur hover:shadow-xl transition-all duration-300"
                >
                  {/* Product Image */}
                  <Link href={`/products/${product.slug}`}>
                    <div className="relative aspect-square overflow-hidden">
                      {product.featuredImage ? (
                        <Image
                          src={product.featuredImage}
                          alt={product.name}
                          fill
                          className="object-cover transition-transform duration-500 group-hover:scale-105"
                        />
                      ) : (
                        <div className="w-full h-full bg-gray-100 flex items-center justify-center">
                          <ShoppingCart className="w-12 h-12 text-gray-300" />
                        </div>
                      )}
                      
                      {/* Discount Badge */}
                      {discountPercentage > 0 && (
                        <Badge className="absolute top-3 left-3 bg-gradient-to-r from-red-500 to-rose-500 text-white border-0">
                          -{discountPercentage}%
                        </Badge>
                      )}

                      {/* Remove Button */}
                      <Button
                        size="icon"
                        variant="secondary"
                        className="absolute top-3 right-3 h-8 w-8 rounded-full bg-white/90 hover:bg-red-50 opacity-0 group-hover:opacity-100 transition-opacity"
                        onClick={(e) => {
                          e.preventDefault();
                          handleRemove(product.id);
                        }}
                        disabled={removingId === product.id}
                      >
                        {removingId === product.id ? (
                          <Loader2 className="h-4 w-4 animate-spin" />
                        ) : (
                          <Trash2 className="h-4 w-4 text-red-500" />
                        )}
                      </Button>
                    </div>
                  </Link>

                  {/* Product Info */}
                  <CardContent className="p-4">
                    <Link href={`/products/${product.slug}`}>
                      <h3 className="font-semibold text-gray-800 line-clamp-2 hover:text-amber-600 transition-colors">
                        {product.name}
                      </h3>
                    </Link>
                    
                    {product.categoryId && (
                      <p className="text-sm text-gray-500 mt-1">{product.categoryId}</p>
                    )}

                    {/* Price */}
                    <div className="mt-3 flex items-baseline gap-2">
                      <span className="text-lg font-bold text-gray-800">
                        ৳{product.price.toLocaleString()}
                      </span>
                      {product.compareAtPrice && (
                        <span className="text-sm text-gray-400 line-through">
                          ৳{product.compareAtPrice.toLocaleString()}
                        </span>
                      )}
                    </div>

                    {/* Add to Cart Button */}
                    <Button
                      className="w-full mt-4 bg-gradient-to-r from-amber-500 to-rose-500 hover:from-amber-600 hover:to-rose-600 text-white gap-2"
                      onClick={() => handleAddToCart(product)}
                      disabled={addingId === product.id}
                    >
                      {addingId === product.id ? (
                        <>
                          <Loader2 className="h-4 w-4 animate-spin" />
                          Adding...
                        </>
                      ) : (
                        <>
                          <ShoppingCart className="h-4 w-4" />
                          Add to Cart
                        </>
                      )}
                    </Button>
                  </CardContent>
                </Card>
              );
            })}
          </div>
        )}

        {/* Continue Shopping */}
        {wishlistItems.length > 0 && (
          <div className="mt-12 text-center">
            <Link href="/products">
              <Button
                variant="outline"
                size="lg"
                className="gap-2 rounded-full border-2 border-amber-400 text-amber-600 hover:bg-amber-50"
              >
                Continue Shopping
                <ArrowRight className="w-4 h-4" />
              </Button>
            </Link>
          </div>
        )}
      </div>
    </div>
  );
}
