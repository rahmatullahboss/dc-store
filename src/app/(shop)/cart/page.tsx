"use client";

import Image from "next/image";
import Link from "next/link";
import {
  Minus,
  Plus,
  ShoppingCart,
  Trash2,
  ArrowLeft,
  Tag,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { useCart } from "@/lib/cart-context";
import { formatPrice, siteConfig } from "@/lib/config";
import { useState } from "react";

export default function CartPage() {
  const { items, updateQuantity, removeItem, subtotal, itemCount } = useCart();
  const [couponCode, setCouponCode] = useState("");

  const shippingCost =
    subtotal >= siteConfig.shipping.freeShippingThreshold
      ? 0
      : siteConfig.shipping.defaultShippingCost;
  const total = subtotal + shippingCost;
  const freeShippingProgress = Math.min(
    (subtotal / siteConfig.shipping.freeShippingThreshold) * 100,
    100
  );
  const amountToFreeShipping =
    siteConfig.shipping.freeShippingThreshold - subtotal;

  if (items.length === 0) {
    return (
      <div className="min-h-screen bg-background">
        {/* Background decorations */}
        <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
          <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
          <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
        </div>

        <div className="relative z-10 container mx-auto px-4 py-16">
          <div className="flex flex-col items-center justify-center gap-6 text-center">
            <div className="p-6 bg-primary/20 rounded-full">
              <ShoppingCart className="h-16 w-16 text-primary" />
            </div>
            <h1 className="text-2xl font-bold text-foreground">
              Your cart is empty
            </h1>
            <p className="text-muted-foreground max-w-md">
              Looks like you haven&apos;t added anything to your cart yet.
              Explore our products and find something you&apos;ll love!
            </p>
            <Button
              size="lg"
              className="bg-primary hover:bg-primary/90 text-primary-foreground rounded-full px-8"
              asChild
            >
              <Link href="/products">
                <ShoppingCart className="mr-2 h-5 w-5" />
                Start Shopping
              </Link>
            </Button>
          </div>
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
        <div className="flex items-center gap-4 mb-8">
          <Button variant="ghost" size="icon" asChild>
            <Link href="/products">
              <ArrowLeft className="h-5 w-5" />
            </Link>
          </Button>
          <div>
            <h1 className="text-2xl md:text-3xl font-bold text-foreground">
              Shopping Cart
            </h1>
            <p className="text-muted-foreground">{itemCount} items in your cart</p>
          </div>
        </div>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Cart Items */}
          <div className="lg:col-span-2 space-y-4">
            {items.map((item) => (
              <div
                key={`${item.productId}-${item.variantId || ""}`}
                className="bg-card rounded-2xl p-4 md:p-6 shadow-lg border border-border flex gap-4"
              >
                {/* Product Image */}
                <div className="relative h-24 w-24 md:h-32 md:w-32 flex-shrink-0 overflow-hidden rounded-xl bg-muted">
                  {item.image ? (
                    <Image
                      src={item.image}
                      alt={item.name}
                      fill
                      className="object-cover"
                    />
                  ) : (
                    <div className="flex h-full items-center justify-center text-muted-foreground">
                      <ShoppingCart className="h-8 w-8" />
                    </div>
                  )}
                </div>

                {/* Product Info */}
                <div className="flex-1 flex flex-col">
                  <div className="flex justify-between gap-2">
                    <h3 className="font-semibold text-foreground line-clamp-2 text-sm md:text-base">
                      {item.name}
                    </h3>
                    <Button
                      variant="ghost"
                      size="icon"
                      className="h-8 w-8 text-muted-foreground hover:text-red-500 flex-shrink-0"
                      onClick={() => removeItem(item.productId, item.variantId)}
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>

                  <p className="text-primary font-bold text-lg mt-1">
                    {formatPrice(item.price)}
                  </p>

                  <div className="flex items-center justify-between mt-auto pt-3">
                    {/* Quantity Controls */}
                    <div className="flex items-center gap-2 bg-muted rounded-full p-1">
                      <Button
                        variant="ghost"
                        size="icon"
                        className="h-8 w-8 rounded-full hover:bg-card"
                        onClick={() =>
                          updateQuantity(
                            item.productId,
                            item.quantity - 1,
                            item.variantId
                          )
                        }
                      >
                        <Minus className="h-4 w-4" />
                      </Button>
                      <span className="w-8 text-center font-medium">
                        {item.quantity}
                      </span>
                      <Button
                        variant="ghost"
                        size="icon"
                        className="h-8 w-8 rounded-full hover:bg-card"
                        onClick={() =>
                          updateQuantity(
                            item.productId,
                            item.quantity + 1,
                            item.variantId
                          )
                        }
                      >
                        <Plus className="h-4 w-4" />
                      </Button>
                    </div>

                    {/* Item Total */}
                    <p className="font-bold text-foreground">
                      {formatPrice(item.price * item.quantity)}
                    </p>
                  </div>
                </div>
              </div>
            ))}
          </div>

          {/* Order Summary */}
          <div className="lg:col-span-1">
            <div className="bg-card rounded-2xl p-6 shadow-lg border border-border sticky top-4">
              <h2 className="text-xl font-bold text-foreground mb-6">
                Order Summary
              </h2>

              {/* Free Shipping Progress */}
              {subtotal < siteConfig.shipping.freeShippingThreshold && (
                <div className="mb-6 p-4 bg-primary/10 rounded-xl">
                  <p className="text-sm text-foreground mb-2">
                    Add{" "}
                    <span className="font-bold text-primary">
                      {formatPrice(amountToFreeShipping)}
                    </span>{" "}
                    more for free shipping!
                  </p>
                  <div className="h-2 bg-muted rounded-full overflow-hidden">
                    <div
                      className="h-full bg-primary rounded-full transition-all duration-500"
                      style={{ width: `${freeShippingProgress}%` }}
                    />
                  </div>
                </div>
              )}

              {subtotal >= siteConfig.shipping.freeShippingThreshold && (
                <div className="mb-6 p-4 bg-green-50 rounded-xl flex items-center gap-2">
                  <span className="text-green-600 text-lg">🎉</span>
                  <p className="text-sm text-green-700 font-medium">
                    You&apos;ve unlocked free shipping!
                  </p>
                </div>
              )}

              {/* Coupon Code */}
              <div className="mb-6">
                <label className="text-sm font-medium text-foreground mb-2 block">
                  Discount Code
                </label>
                <div className="flex gap-2">
                  <div className="relative flex-1">
                    <Tag className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                      placeholder="Enter coupon code"
                      value={couponCode}
                      onChange={(e) => setCouponCode(e.target.value)}
                      className="pl-10"
                    />
                  </div>
                  <Button variant="outline">Apply</Button>
                </div>
              </div>

              {/* Price Breakdown */}
              <div className="space-y-3 mb-6">
                <div className="flex justify-between text-muted-foreground">
                  <span>Subtotal</span>
                  <span>{formatPrice(subtotal)}</span>
                </div>
                <div className="flex justify-between text-muted-foreground">
                  <span>Shipping</span>
                  <span
                    className={
                      shippingCost === 0 ? "text-green-600 font-medium" : ""
                    }
                  >
                    {shippingCost === 0 ? "FREE" : formatPrice(shippingCost)}
                  </span>
                </div>
                <div className="border-t border-border pt-3">
                  <div className="flex justify-between text-lg font-bold text-foreground">
                    <span>Total</span>
                    <span className="text-primary">{formatPrice(total)}</span>
                  </div>
                </div>
              </div>

              {/* Checkout Button */}
              <Button
                size="lg"
                className="w-full bg-primary hover:bg-primary/90 text-primary-foreground rounded-full text-lg py-6"
                asChild
              >
                <Link href="/checkout">Proceed to Checkout</Link>
              </Button>

              {/* Continue Shopping */}
              <Button variant="ghost" className="w-full mt-3" asChild>
                <Link href="/products">Continue Shopping</Link>
              </Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
