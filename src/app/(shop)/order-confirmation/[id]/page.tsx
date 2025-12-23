import Link from "next/link";
import { CheckCircle2, Package, Truck, MapPin, CreditCard, ArrowRight, Home } from "lucide-react";
import { Button } from "@/components/ui/button";
import { getDatabase } from "@/lib/cloudflare";
import { orders } from "@/db/schema";
import { eq } from "drizzle-orm";
import { formatPrice } from "@/lib/config";
import { notFound } from "next/navigation";
import Image from "next/image";

// Force dynamic rendering for Cloudflare context
export const dynamic = "force-dynamic";

interface OrderConfirmationPageProps {
  params: Promise<{ id: string }>;
}

export default async function OrderConfirmationPage({ params }: OrderConfirmationPageProps) {
  const { id } = await params;
  
  const db = await getDatabase();
  const order = await db.query.orders.findFirst({
    where: eq(orders.id, id),
  });

  if (!order) {
    notFound();
  }

  const estimatedDelivery = new Date();
  estimatedDelivery.setDate(estimatedDelivery.getDate() + 5);

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-stone-100 relative overflow-hidden">
      {/* Confetti Background Effect */}
      <div className="absolute inset-0 pointer-events-none">
        <div className="absolute top-10 left-10 w-4 h-4 bg-amber-400 rounded-full opacity-60 animate-bounce" style={{ animationDelay: "0.1s" }} />
        <div className="absolute top-20 right-20 w-3 h-3 bg-rose-400 rounded-full opacity-50 animate-bounce" style={{ animationDelay: "0.3s" }} />
        <div className="absolute top-40 left-1/4 w-5 h-5 bg-blue-400 rounded-full opacity-40 animate-bounce" style={{ animationDelay: "0.5s" }} />
        <div className="absolute top-32 right-1/3 w-4 h-4 bg-green-400 rounded-full opacity-50 animate-bounce" style={{ animationDelay: "0.7s" }} />
        <div className="absolute top-16 left-1/2 w-3 h-3 bg-purple-400 rounded-full opacity-60 animate-bounce" style={{ animationDelay: "0.9s" }} />
      </div>

      <div className="container mx-auto px-4 py-8 md:py-16 relative z-10">
        <div className="max-w-2xl mx-auto">
          {/* Success Animation */}
          <div className="text-center mb-8">
            <div className="inline-flex items-center justify-center w-24 h-24 bg-gradient-to-r from-green-400 to-emerald-500 rounded-full mb-6 shadow-xl shadow-green-200">
              <CheckCircle2 className="h-12 w-12 text-white" />
            </div>
            <h1 className="text-3xl md:text-4xl font-bold mb-2">
              <span className="bg-gradient-to-r from-amber-500 to-rose-500 bg-clip-text text-transparent">
                Thank You!
              </span>
            </h1>
            <p className="text-gray-600 text-lg">
              Your order has been placed successfully
            </p>
          </div>

          {/* Order Number */}
          <div className="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 mb-6">
            <div className="flex items-center justify-between mb-4">
              <span className="text-gray-600">Order Number</span>
              <span className="text-lg font-bold text-gray-800">#{order.orderNumber}</span>
            </div>
            <div className="flex items-center justify-between">
              <span className="text-gray-600">Order Date</span>
              <span className="font-medium text-gray-800">
                {new Date(order.createdAt!).toLocaleDateString("en-US", {
                  year: "numeric",
                  month: "long",
                  day: "numeric",
                })}
              </span>
            </div>
          </div>

          {/* Order Items */}
          <div className="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 mb-6">
            <div className="flex items-center gap-3 mb-4">
              <div className="p-2 bg-gradient-to-r from-amber-500 to-rose-500 rounded-lg text-white">
                <Package className="h-5 w-5" />
              </div>
              <h2 className="text-lg font-bold text-gray-800">Order Summary</h2>
            </div>

            <div className="space-y-4 mb-6">
              {order.items?.map((item, index) => (
                <div key={index} className="flex gap-3">
                  <div className="relative h-16 w-16 flex-shrink-0 overflow-hidden rounded-lg bg-gray-100">
                    {item.image ? (
                      <Image
                        src={item.image}
                        alt={item.name}
                        fill
                        className="object-cover"
                      />
                    ) : (
                      <div className="flex h-full items-center justify-center text-gray-400">
                        <Package className="h-6 w-6" />
                      </div>
                    )}
                  </div>
                  <div className="flex-1 min-w-0">
                    <h4 className="text-sm font-medium text-gray-800 line-clamp-1">
                      {item.name}
                    </h4>
                    <p className="text-sm text-gray-500">Qty: {item.quantity}</p>
                    <p className="text-sm font-bold text-amber-600">
                      {formatPrice(item.price * item.quantity)}
                    </p>
                  </div>
                </div>
              ))}
            </div>

            <div className="border-t pt-4 space-y-2">
              <div className="flex justify-between text-gray-600">
                <span>Subtotal</span>
                <span>{formatPrice(order.subtotal)}</span>
              </div>
              <div className="flex justify-between text-gray-600">
                <span>Shipping</span>
                <span>{order.shippingCost === 0 ? "FREE" : formatPrice(order.shippingCost || 0)}</span>
              </div>
              <div className="flex justify-between text-lg font-bold text-gray-800 pt-2 border-t">
                <span>Total</span>
                <span className="text-amber-600">{formatPrice(order.total)}</span>
              </div>
            </div>
          </div>

          {/* Shipping & Payment Info */}
          <div className="grid sm:grid-cols-2 gap-4 mb-6">
            <div className="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
              <div className="flex items-center gap-3 mb-4">
                <div className="p-2 bg-blue-100 rounded-lg text-blue-600">
                  <MapPin className="h-5 w-5" />
                </div>
                <h3 className="font-bold text-gray-800">Shipping Address</h3>
              </div>
              <div className="text-gray-600 text-sm space-y-1">
                <p className="font-medium text-gray-800">{order.customerName}</p>
                <p>{order.shippingAddress?.address}</p>
                <p>{order.shippingAddress?.city}, {order.shippingAddress?.state}</p>
                <p>{order.customerPhone}</p>
              </div>
            </div>

            <div className="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
              <div className="flex items-center gap-3 mb-4">
                <div className="p-2 bg-green-100 rounded-lg text-green-600">
                  <CreditCard className="h-5 w-5" />
                </div>
                <h3 className="font-bold text-gray-800">Payment</h3>
              </div>
              <div className="text-gray-600 text-sm space-y-2">
                <div className="inline-flex items-center gap-2 bg-amber-100 text-amber-800 px-3 py-1.5 rounded-full text-sm font-medium">
                  💵 Cash on Delivery
                </div>
                <p className="text-gray-500">Pay when you receive</p>
              </div>
            </div>
          </div>

          {/* Estimated Delivery */}
          <div className="bg-gradient-to-r from-amber-50 to-rose-50 rounded-2xl p-6 border border-amber-100 mb-8">
            <div className="flex items-center gap-3 mb-2">
              <Truck className="h-6 w-6 text-amber-600" />
              <h3 className="font-bold text-gray-800">Estimated Delivery</h3>
            </div>
            <p className="text-lg font-bold text-amber-600">
              {estimatedDelivery.toLocaleDateString("en-US", {
                weekday: "long",
                month: "long",
                day: "numeric",
              })}
            </p>
            <p className="text-sm text-gray-600 mt-1">
              We&apos;ll send you updates about your order status
            </p>
          </div>

          {/* Action Buttons */}
          <div className="flex flex-col sm:flex-row gap-4">
            <Button 
              size="lg"
              className="flex-1 bg-gradient-to-r from-amber-500 to-rose-500 hover:from-amber-600 hover:to-rose-600 text-white rounded-full"
              asChild
            >
              <Link href="/orders">
                Track Order <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </Button>
            <Button 
              size="lg"
              variant="outline"
              className="flex-1 rounded-full"
              asChild
            >
              <Link href="/">
                <Home className="mr-2 h-4 w-4" />
                Continue Shopping
              </Link>
            </Button>
          </div>

          {/* Email Notice */}
          <p className="text-center text-sm text-gray-500 mt-6">
            📧 A confirmation email has been sent to your email address
          </p>
        </div>
      </div>
    </div>
  );
}
