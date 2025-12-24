"use client";

import { useState } from "react";
import Link from "next/link";
import { Search, Package, Truck, CheckCircle, Clock, MapPin, ArrowRight, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";

// Demo order data
const demoOrder = {
  orderNumber: "ORD-2024-001",
  status: "shipped",
  items: [
    { name: "Premium Wireless Headphones", quantity: 1, price: 4999 },
    { name: "Smart Watch Series X", quantity: 1, price: 12999 },
  ],
  subtotal: 17998,
  shipping: 60,
  total: 18058,
  shippingAddress: {
    name: "Rahmat Ullah",
    address: "House 12, Road 5, Dhanmondi",
    city: "Dhaka",
    phone: "+880 1712 345678",
  },
  estimatedDelivery: new Date("2024-12-28"),
  trackingNumber: "BD1234567890",
  timeline: [
    { status: "placed", date: new Date("2024-12-20T10:30:00"), completed: true },
    { status: "confirmed", date: new Date("2024-12-20T11:00:00"), completed: true },
    { status: "processing", date: new Date("2024-12-21T09:00:00"), completed: true },
    { status: "shipped", date: new Date("2024-12-22T14:00:00"), completed: true },
    { status: "out_for_delivery", date: null, completed: false },
    { status: "delivered", date: null, completed: false },
  ],
};

const statusConfig: Record<string, { label: string; icon: typeof Package; color: string }> = {
  placed: { label: "Order Placed", icon: Package, color: "text-blue-500" },
  confirmed: { label: "Confirmed", icon: CheckCircle, color: "text-green-500" },
  processing: { label: "Processing", icon: Clock, color: "text-amber-500" },
  shipped: { label: "Shipped", icon: Truck, color: "text-purple-500" },
  out_for_delivery: { label: "Out for Delivery", icon: Truck, color: "text-orange-500" },
  delivered: { label: "Delivered", icon: CheckCircle, color: "text-green-600" },
};

export default function TrackOrderPage() {
  const [orderNumber, setOrderNumber] = useState("");
  const [isSearching, setIsSearching] = useState(false);
  const [foundOrder, setFoundOrder] = useState<typeof demoOrder | null>(null);
  const [error, setError] = useState("");

  const handleSearch = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    
    if (!orderNumber.trim()) {
      setError("Please enter an order number");
      return;
    }

    setIsSearching(true);

    // Simulate API call
    setTimeout(() => {
      if (orderNumber.toUpperCase() === "ORD-2024-001" || orderNumber === "demo") {
        setFoundOrder(demoOrder);
        setError("");
      } else {
        setFoundOrder(null);
        setError("Order not found. Please check the order number and try again.");
      }
      setIsSearching(false);
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
        <div className="text-center mb-8">
          <div className="w-16 h-16 mx-auto bg-gradient-to-r from-amber-500 to-rose-500 rounded-full flex items-center justify-center mb-4">
            <Truck className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-2xl sm:text-3xl font-bold text-gray-800 mb-2">Track Your Order</h1>
          <p className="text-gray-500 max-w-md mx-auto">
            Enter your order number to track the status of your delivery
          </p>
        </div>

        {/* Search Form */}
        <Card className="max-w-xl mx-auto mb-8 bg-white/80 backdrop-blur">
          <CardContent className="pt-6">
            <form onSubmit={handleSearch} className="flex gap-3">
              <div className="relative flex-1">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-gray-400" />
                <Input
                  placeholder="Enter order number (e.g., ORD-2024-001)"
                  value={orderNumber}
                  onChange={(e) => setOrderNumber(e.target.value)}
                  className="pl-10"
                />
              </div>
              <Button
                type="submit"
                className="bg-gradient-to-r from-amber-500 to-rose-500 text-white"
                disabled={isSearching}
              >
                {isSearching ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  "Track"
                )}
              </Button>
            </form>
            {error && (
              <p className="text-sm text-red-500 mt-2">{error}</p>
            )}
            <p className="text-xs text-gray-400 mt-2">
              Try: <button type="button" onClick={() => setOrderNumber("ORD-2024-001")} className="text-amber-600 hover:underline">ORD-2024-001</button> (demo order)
            </p>
          </CardContent>
        </Card>

        {/* Order Details */}
        {foundOrder && (
          <div className="max-w-4xl mx-auto space-y-6">
            {/* Order Status */}
            <Card className="bg-white/80 backdrop-blur">
              <CardHeader>
                <div className="flex items-center justify-between flex-wrap gap-4">
                  <div>
                    <CardTitle className="text-xl">{foundOrder.orderNumber}</CardTitle>
                    <CardDescription>
                      Tracking #: {foundOrder.trackingNumber}
                    </CardDescription>
                  </div>
                  <Badge className="bg-purple-100 text-purple-700 border-0 text-sm px-4 py-1">
                    {statusConfig[foundOrder.status].label}
                  </Badge>
                </div>
              </CardHeader>
              <CardContent>
                {/* Timeline */}
                <div className="relative">
                  {foundOrder.timeline.map((step, index) => {
                    const config = statusConfig[step.status];
                    const Icon = config.icon;
                    const isLast = index === foundOrder.timeline.length - 1;

                    return (
                      <div key={step.status} className="flex gap-4 pb-8 last:pb-0">
                        {/* Icon */}
                        <div className="relative">
                          <div
                            className={`w-10 h-10 rounded-full flex items-center justify-center ${
                              step.completed
                                ? "bg-gradient-to-r from-amber-500 to-rose-500"
                                : "bg-gray-200"
                            }`}
                          >
                            <Icon className={`w-5 h-5 ${step.completed ? "text-white" : "text-gray-400"}`} />
                          </div>
                          {/* Line */}
                          {!isLast && (
                            <div
                              className={`absolute left-1/2 top-10 w-0.5 h-full -translate-x-1/2 ${
                                step.completed ? "bg-amber-400" : "bg-gray-200"
                              }`}
                            />
                          )}
                        </div>

                        {/* Content */}
                        <div className="flex-1 pb-4">
                          <p className={`font-medium ${step.completed ? "text-gray-800" : "text-gray-400"}`}>
                            {config.label}
                          </p>
                          {step.date ? (
                            <p className="text-sm text-gray-500">
                              {step.date.toLocaleDateString()} at {step.date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                            </p>
                          ) : (
                            <p className="text-sm text-gray-400">Pending</p>
                          )}
                        </div>
                      </div>
                    );
                  })}
                </div>
              </CardContent>
            </Card>

            {/* Order Summary & Shipping */}
            <div className="grid md:grid-cols-2 gap-6">
              {/* Items */}
              <Card className="bg-white/80 backdrop-blur">
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2">
                    <Package className="h-5 w-5 text-amber-500" />
                    Order Items
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    {foundOrder.items.map((item, index) => (
                      <div key={index} className="flex justify-between text-sm">
                        <span className="text-gray-600">
                          {item.name} × {item.quantity}
                        </span>
                        <span className="font-medium">৳{item.price.toLocaleString()}</span>
                      </div>
                    ))}
                    <div className="border-t pt-3 mt-3">
                      <div className="flex justify-between text-sm">
                        <span className="text-gray-500">Subtotal</span>
                        <span>৳{foundOrder.subtotal.toLocaleString()}</span>
                      </div>
                      <div className="flex justify-between text-sm">
                        <span className="text-gray-500">Shipping</span>
                        <span>৳{foundOrder.shipping}</span>
                      </div>
                      <div className="flex justify-between font-bold mt-2">
                        <span>Total</span>
                        <span>৳{foundOrder.total.toLocaleString()}</span>
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>

              {/* Shipping Address */}
              <Card className="bg-white/80 backdrop-blur">
                <CardHeader>
                  <CardTitle className="text-lg flex items-center gap-2">
                    <MapPin className="h-5 w-5 text-amber-500" />
                    Shipping Address
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-2 text-sm text-gray-600">
                    <p className="font-medium text-gray-800">{foundOrder.shippingAddress.name}</p>
                    <p>{foundOrder.shippingAddress.address}</p>
                    <p>{foundOrder.shippingAddress.city}</p>
                    <p>{foundOrder.shippingAddress.phone}</p>
                  </div>
                  <div className="mt-4 p-3 bg-amber-50 rounded-lg">
                    <p className="text-sm font-medium text-amber-700">
                      📅 Estimated Delivery
                    </p>
                    <p className="text-lg font-bold text-amber-800">
                      {foundOrder.estimatedDelivery.toLocaleDateString("en-US", {
                        weekday: "long",
                        month: "long",
                        day: "numeric",
                      })}
                    </p>
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* Actions */}
            <div className="flex justify-center gap-4">
              <Link href="/orders">
                <Button variant="outline" className="gap-2">
                  View All Orders
                  <ArrowRight className="h-4 w-4" />
                </Button>
              </Link>
              <Link href="/products">
                <Button className="bg-gradient-to-r from-amber-500 to-rose-500 text-white gap-2">
                  Continue Shopping
                </Button>
              </Link>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
