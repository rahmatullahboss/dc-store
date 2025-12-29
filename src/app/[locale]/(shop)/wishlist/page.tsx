"use client";

import { useState, useEffect, useCallback } from "react";
import Link from "next/link";
import Image from "next/image";
import { Heart, ShoppingCart, Trash2, ArrowRight, Loader2, RefreshCcw } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { useCart } from "@/lib/cart-context";
import { toast } from "sonner";
import { useTranslations } from "next-intl";
import { formatPrice } from "@/lib/config";

interface WishlistProduct {
  id: string;
  name: string;
  slug: string;
  price: number;
  compareAtPrice: number | null;
  featuredImage: string | null;
  images: string[];
  quantity: number | null;
  isActive: boolean;
  inStock: boolean;
}

interface WishlistItem {
  id: string;
  productId: string;
  createdAt: string;
  product: WishlistProduct;
}

export default function WishlistPage() {
  const t = useTranslations("Wishlist");
  const [wishlistItems, setWishlistItems] = useState<WishlistItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [removingId, setRemovingId] = useState<string | null>(null);
  const [addingId, setAddingId] = useState<string | null>(null);
  const { addItem } = useCart();

  const fetchWishlist = useCallback(async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await fetch("/api/user/wishlist");
      
      if (response.status === 401) {
        setError("login");
        setWishlistItems([]);
        return;
      }
      
      if (!response.ok) {
        throw new Error("Failed to fetch wishlist");
      }
      
      const data = await response.json() as { items?: WishlistItem[]; count?: number };
      setWishlistItems(data.items || []);
    } catch (err) {
      setError("generic");
      console.error("Wishlist fetch error:", err);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchWishlist();
  }, [fetchWishlist]);

  const handleRemove = async (productId: string) => {
    setRemovingId(productId);
    try {
      const response = await fetch(`/api/user/wishlist/${productId}`, {
        method: "DELETE",
      });
      
      if (response.ok) {
        setWishlistItems((prev) => prev.filter((item) => item.productId !== productId));
        toast.success(t("toast.removed"));
      } else {
        toast.error(t("toast.removeError"));
      }
    } catch (err) {
      console.error("Remove error:", err);
      toast.error(t("toast.removeError"));
    } finally {
      setRemovingId(null);
    }
  };

  const handleAddToCart = (item: WishlistItem) => {
    setAddingId(item.productId);
    addItem({
      productId: item.productId,
      name: item.product.name,
      price: item.product.price,
      quantity: 1,
      image: item.product.featuredImage || undefined,
    });
    toast.success(t("toast.addedToCart"));
    setTimeout(() => {
      setAddingId(null);
    }, 1000);
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="text-center">
          <Loader2 className="w-12 h-12 animate-spin text-primary mx-auto mb-4" />
          <p className="text-muted-foreground">{t("loading")}</p>
        </div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-background">
        <div className="relative z-10 container mx-auto px-4 py-16">
          <Card className="max-w-md mx-auto text-center bg-card/80 backdrop-blur">
            <CardContent className="pt-12 pb-8">
              <div className="w-24 h-24 mx-auto bg-rose-100 rounded-full flex items-center justify-center mb-6">
                <Heart className="w-12 h-12 text-rose-400" />
              </div>
              <h2 className="text-xl font-bold text-foreground mb-2">
                {error === "login" ? t("error.login") : t("error.generic")}
              </h2>
              <p className="text-muted-foreground mb-6">
                {error === "login" 
                  ? t("error.login")
                  : t("error.refresh")}
              </p>
              {error === "login" ? (
                <Link href="/login">
                  <Button className="bg-primary text-white gap-2">
                    {t("error.signIn")}
                    <ArrowRight className="w-4 h-4" />
                  </Button>
                </Link>
              ) : (
                <Button onClick={fetchWishlist} className="gap-2">
                  <RefreshCcw className="w-4 h-4" />
                  {t("error.tryAgain")}
                </Button>
              )}
            </CardContent>
          </Card>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
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
            <h1 className="text-2xl sm:text-3xl font-bold text-foreground">{t("title")}</h1>
          </div>
          <p className="text-muted-foreground">
            {t("subtitle", { count: wishlistItems.length })}
          </p>
        </div>

        {wishlistItems.length === 0 ? (
          /* Empty State */
          <Card className="max-w-md mx-auto text-center bg-card/80 backdrop-blur">
            <CardContent className="pt-12 pb-8">
              <div className="w-24 h-24 mx-auto bg-rose-100 rounded-full flex items-center justify-center mb-6">
                <Heart className="w-12 h-12 text-rose-400" />
              </div>
              <h2 className="text-xl font-bold text-foreground mb-2">{t("empty.title")}</h2>
              <p className="text-muted-foreground mb-6">
                {t("empty.desc")}
              </p>
              <Link href="/products">
                <Button className="bg-primary text-white gap-2">
                  {t("empty.action")}
                  <ArrowRight className="w-4 h-4" />
                </Button>
              </Link>
            </CardContent>
          </Card>
        ) : (
          /* Wishlist Grid */
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
            {wishlistItems.map((item) => {
              const product = item.product;
              const discountPercentage = product.compareAtPrice
                ? Math.round(
                    ((product.compareAtPrice - product.price) / product.compareAtPrice) * 100
                  )
                : 0;

              return (
                <Card
                  key={item.id}
                  className="group overflow-hidden bg-card/80 backdrop-blur hover:shadow-xl transition-all duration-300"
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
                        <div className="w-full h-full bg-muted flex items-center justify-center">
                          <ShoppingCart className="w-12 h-12 text-muted-foreground" />
                        </div>
                      )}
                      
                      {/* Discount Badge */}
                      {discountPercentage > 0 && (
                        <Badge className="absolute top-3 left-3 bg-gradient-to-r from-red-500 to-rose-500 text-white border-0">
                          -{discountPercentage}%
                        </Badge>
                      )}

                      {/* Out of Stock Badge */}
                      {!product.inStock && (
                        <Badge className="absolute top-3 left-3 bg-muted0 text-white border-0">
                          {t("card.outOfStock")}
                        </Badge>
                      )}

                      {/* Remove Button */}
                      <Button
                        size="icon"
                        variant="secondary"
                        className="absolute top-3 right-3 h-8 w-8 rounded-full bg-card/90 hover:bg-red-50 opacity-0 group-hover:opacity-100 transition-opacity"
                        onClick={(e) => {
                          e.preventDefault();
                          handleRemove(item.productId);
                        }}
                        disabled={removingId === item.productId}
                        title={t("card.remove")}
                      >
                        {removingId === item.productId ? (
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
                      <h3 className="font-semibold text-foreground line-clamp-2 hover:text-primary transition-colors">
                        {product.name}
                      </h3>
                    </Link>

                    {/* Price */}
                    <div className="mt-3 flex items-baseline gap-2">
                      <span className="text-lg font-bold text-foreground">
                        {formatPrice(product.price)}
                      </span>
                      {product.compareAtPrice && (
                        <span className="text-sm text-muted-foreground line-through">
                          {formatPrice(product.compareAtPrice)}
                        </span>
                      )}
                    </div>

                    {/* Add to Cart Button */}
                    <Button
                      className="w-full mt-4 bg-primary hover:from-amber-600 hover:to-rose-600 text-white gap-2"
                      onClick={() => handleAddToCart(item)}
                      disabled={addingId === item.productId || !product.inStock}
                    >
                      {addingId === item.productId ? (
                        <>
                          <Loader2 className="h-4 w-4 animate-spin" />
                          {t("card.adding")}
                        </>
                      ) : !product.inStock ? (
                        t("card.outOfStock")
                      ) : (
                        <>
                          <ShoppingCart className="h-4 w-4" />
                          {t("card.addToCart")}
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
                className="gap-2 rounded-full border-2 border-amber-400 text-primary hover:bg-amber-50"
              >
                {t("continueShopping")}
                <ArrowRight className="w-4 h-4" />
              </Button>
            </Link>
          </div>
        )}
      </div>
    </div>
  );
}
