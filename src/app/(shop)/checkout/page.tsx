"use client";

import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState, useEffect } from "react";
import { 
  ArrowLeft, 
  ShoppingCart, 
  MapPin, 
  CreditCard, 
  Check,
  Truck,
  Shield,
  Banknote
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { useCart } from "@/lib/cart-context";
import { useSession } from "@/lib/auth-client";
import { formatPrice, siteConfig } from "@/lib/config";
import { toast } from "sonner";

// Bangladesh divisions, districts
const divisions = [
  "Dhaka",
  "Chittagong", 
  "Rajshahi",
  "Khulna",
  "Barisal",
  "Sylhet",
  "Rangpur",
  "Mymensingh",
];

const districts: Record<string, string[]> = {
  Dhaka: ["Dhaka", "Gazipur", "Narayanganj", "Tangail", "Manikganj", "Munshiganj", "Narsingdi", "Kishoreganj", "Faridpur", "Gopalganj", "Madaripur", "Rajbari", "Shariatpur"],
  Chittagong: ["Chittagong", "Cox's Bazar", "Comilla", "Feni", "Lakshmipur", "Noakhali", "Chandpur", "Brahmanbaria", "Rangamati", "Khagrachhari", "Bandarban"],
  Rajshahi: ["Rajshahi", "Naogaon", "Natore", "Nawabganj", "Pabna", "Bogra", "Sirajganj", "Joypurhat"],
  Khulna: ["Khulna", "Jessore", "Satkhira", "Bagerhat", "Narail", "Magura", "Kushtia", "Chuadanga", "Meherpur", "Jhenaidah"],
  Barisal: ["Barisal", "Patuakhali", "Bhola", "Pirojpur", "Barguna", "Jhalokathi"],
  Sylhet: ["Sylhet", "Moulvibazar", "Habiganj", "Sunamganj"],
  Rangpur: ["Rangpur", "Dinajpur", "Gaibandha", "Kurigram", "Lalmonirhat", "Nilphamari", "Panchagarh", "Thakurgaon"],
  Mymensingh: ["Mymensingh", "Jamalpur", "Sherpur", "Netrokona"],
};

interface FormData {
  name: string;
  phone: string;
  email: string;
  division: string;
  district: string;
  address: string;
  notes: string;
}

export default function CheckoutPage() {
  const router = useRouter();
  const { items, subtotal, clearCart } = useCart();
  const { data: session } = useSession();
  const [isLoading, setIsLoading] = useState(false);
  const [formData, setFormData] = useState<FormData>({
    name: "",
    phone: "",
    email: "",
    division: "",
    district: "",
    address: "",
    notes: "",
  });

  // Pre-fill form with user profile data when session loads
  useEffect(() => {
    if (session?.user) {
      setFormData(prev => ({
        ...prev,
        name: prev.name || session.user.name || "",
        email: prev.email || session.user.email || "",
      }));
    }
  }, [session]);

  const shippingCost = subtotal >= siteConfig.shipping.freeShippingThreshold 
    ? 0 
    : siteConfig.shipping.defaultShippingCost;
  const total = subtotal + shippingCost;

  // Empty cart redirect
  if (items.length === 0) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-stone-100">
        <div className="container mx-auto px-4 py-16">
          <div className="flex flex-col items-center justify-center gap-6 text-center">
            <div className="p-6 bg-gradient-to-br from-amber-100 to-rose-100 rounded-full">
              <ShoppingCart className="h-16 w-16 text-amber-600" />
            </div>
            <h1 className="text-2xl font-bold text-gray-800">Your cart is empty</h1>
            <p className="text-gray-600 max-w-md">
              Add some products to your cart before checkout.
            </p>
            <Button 
              size="lg" 
              className="bg-gradient-to-r from-amber-500 to-rose-500 hover:from-amber-600 hover:to-rose-600 text-white rounded-full px-8"
              asChild
            >
              <Link href="/products">
                Start Shopping
              </Link>
            </Button>
          </div>
        </div>
      </div>
    );
  }

  const handleInputChange = (field: keyof FormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    if (field === "division") {
      setFormData(prev => ({ ...prev, district: "" }));
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // Validation
    if (!formData.name || !formData.phone || !formData.division || !formData.district || !formData.address) {
      toast.error("Please fill in all required fields");
      return;
    }

    if (!/^01[3-9]\d{8}$/.test(formData.phone)) {
      toast.error("Please enter a valid Bangladesh phone number");
      return;
    }

    setIsLoading(true);

    try {
      // Create order via API
      const response = await fetch("/api/orders", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          items: items.map(item => ({
            ...item,
            total: item.price * item.quantity,
          })),
          subtotal,
          shippingCost,
          total,
          customerName: formData.name,
          customerPhone: formData.phone,
          customerEmail: formData.email || null,
          shippingAddress: {
            name: formData.name,
            phone: formData.phone,
            address: formData.address,
            city: formData.district,
            state: formData.division,
            country: "Bangladesh",
          },
          notes: formData.notes || null,
          paymentMethod: "cod",
        }),
      });

      if (!response.ok) {
        throw new Error("Failed to create order");
      }

      const data = await response.json() as { order: { id: string; orderNumber: string } };
      
      // Clear cart and redirect
      clearCart();
      router.push(`/order-confirmation/${data.order.id}`);
    } catch {
      toast.error("Failed to place order. Please try again.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-stone-100">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex items-center gap-4 mb-8">
          <Button variant="ghost" size="icon" asChild>
            <Link href="/cart">
              <ArrowLeft className="h-5 w-5" />
            </Link>
          </Button>
          <div>
            <h1 className="text-2xl md:text-3xl font-bold text-gray-800">
              Checkout
            </h1>
            <p className="text-gray-600">Complete your order</p>
          </div>
        </div>

        {/* Progress Steps */}
        <div className="flex items-center justify-center gap-4 mb-8">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-amber-500 text-white flex items-center justify-center text-sm font-bold">
              <Check className="h-4 w-4" />
            </div>
            <span className="text-sm font-medium text-gray-800 hidden sm:block">Cart</span>
          </div>
          <div className="w-8 md:w-16 h-0.5 bg-amber-500" />
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-amber-500 text-white flex items-center justify-center text-sm font-bold">
              2
            </div>
            <span className="text-sm font-medium text-gray-800 hidden sm:block">Shipping</span>
          </div>
          <div className="w-8 md:w-16 h-0.5 bg-gray-300" />
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-gray-300 text-gray-600 flex items-center justify-center text-sm font-bold">
              3
            </div>
            <span className="text-sm font-medium text-gray-500 hidden sm:block">Done</span>
          </div>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="grid lg:grid-cols-3 gap-8">
            {/* Shipping Form */}
            <div className="lg:col-span-2 space-y-6">
              {/* Contact Information */}
              <div className="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                <div className="flex items-center gap-3 mb-6">
                  <div className="p-2 bg-gradient-to-r from-amber-500 to-rose-500 rounded-lg text-white">
                    <MapPin className="h-5 w-5" />
                  </div>
                  <h2 className="text-lg font-bold text-gray-800">Shipping Information</h2>
                </div>

                <div className="grid sm:grid-cols-2 gap-4">
                  <div className="sm:col-span-2">
                    <Label htmlFor="name">Full Name *</Label>
                    <Input
                      id="name"
                      placeholder="Enter your full name"
                      value={formData.name}
                      onChange={(e) => handleInputChange("name", e.target.value)}
                      required
                    />
                  </div>

                  <div>
                    <Label htmlFor="phone">Phone Number *</Label>
                    <Input
                      id="phone"
                      type="tel"
                      placeholder="01XXXXXXXXX"
                      value={formData.phone}
                      onChange={(e) => handleInputChange("phone", e.target.value)}
                      required
                    />
                  </div>

                  <div>
                    <Label htmlFor="email">Email (Optional)</Label>
                    <Input
                      id="email"
                      type="email"
                      placeholder="your@email.com"
                      value={formData.email}
                      onChange={(e) => handleInputChange("email", e.target.value)}
                    />
                  </div>

                  <div>
                    <Label htmlFor="division">Division *</Label>
                    <Select
                      value={formData.division}
                      onValueChange={(value) => handleInputChange("division", value)}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder="Select Division" />
                      </SelectTrigger>
                      <SelectContent>
                        {divisions.map((div) => (
                          <SelectItem key={div} value={div}>
                            {div}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>

                  <div>
                    <Label htmlFor="district">District *</Label>
                    <Select
                      value={formData.district}
                      onValueChange={(value) => handleInputChange("district", value)}
                      disabled={!formData.division}
                    >
                      <SelectTrigger>
                        <SelectValue placeholder={formData.division ? "Select District" : "Select Division first"} />
                      </SelectTrigger>
                      <SelectContent>
                        {formData.division &&
                          districts[formData.division]?.map((dist) => (
                            <SelectItem key={dist} value={dist}>
                              {dist}
                            </SelectItem>
                          ))}
                      </SelectContent>
                    </Select>
                  </div>

                  <div className="sm:col-span-2">
                    <Label htmlFor="address">Full Address *</Label>
                    <Textarea
                      id="address"
                      placeholder="House no, Road no, Area name..."
                      value={formData.address}
                      onChange={(e) => handleInputChange("address", e.target.value)}
                      rows={3}
                      required
                    />
                  </div>

                  <div className="sm:col-span-2">
                    <Label htmlFor="notes">Delivery Note (Optional)</Label>
                    <Textarea
                      id="notes"
                      placeholder="Any special instructions for delivery..."
                      value={formData.notes}
                      onChange={(e) => handleInputChange("notes", e.target.value)}
                      rows={2}
                    />
                  </div>
                </div>
              </div>

              {/* Payment Method */}
              <div className="bg-white rounded-2xl p-6 shadow-lg border border-gray-100">
                <div className="flex items-center gap-3 mb-6">
                  <div className="p-2 bg-gradient-to-r from-amber-500 to-rose-500 rounded-lg text-white">
                    <CreditCard className="h-5 w-5" />
                  </div>
                  <h2 className="text-lg font-bold text-gray-800">Payment Method</h2>
                </div>

                {/* Cash on Delivery - Selected */}
                <div className="p-4 border-2 border-amber-500 rounded-xl bg-amber-50 flex items-center gap-4">
                  <div className="p-3 bg-gradient-to-r from-amber-500 to-rose-500 rounded-full text-white">
                    <Banknote className="h-6 w-6" />
                  </div>
                  <div className="flex-1">
                    <h3 className="font-bold text-gray-800">Cash on Delivery</h3>
                    <p className="text-sm text-gray-600">Pay when you receive your order</p>
                  </div>
                  <div className="w-6 h-6 rounded-full bg-amber-500 flex items-center justify-center">
                    <Check className="h-4 w-4 text-white" />
                  </div>
                </div>
              </div>
            </div>

            {/* Order Summary */}
            <div className="lg:col-span-1">
              <div className="bg-white rounded-2xl p-6 shadow-lg border border-gray-100 sticky top-4">
                <h2 className="text-xl font-bold text-gray-800 mb-6">Order Summary</h2>

                {/* Items */}
                <div className="space-y-4 mb-6 max-h-64 overflow-y-auto">
                  {items.map((item) => (
                    <div
                      key={`${item.productId}-${item.variantId || ""}`}
                      className="flex gap-3"
                    >
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
                            <ShoppingCart className="h-6 w-6" />
                          </div>
                        )}
                        <div className="absolute -top-1 -right-1 w-5 h-5 bg-amber-500 text-white text-xs rounded-full flex items-center justify-center font-bold">
                          {item.quantity}
                        </div>
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="text-sm font-medium text-gray-800 line-clamp-2">
                          {item.name}
                        </h4>
                        <p className="text-sm text-amber-600 font-bold">
                          {formatPrice(item.price * item.quantity)}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Price Breakdown */}
                <div className="space-y-3 mb-6 pt-4 border-t">
                  <div className="flex justify-between text-gray-600">
                    <span>Subtotal</span>
                    <span>{formatPrice(subtotal)}</span>
                  </div>
                  <div className="flex justify-between text-gray-600">
                    <span>Shipping</span>
                    <span className={shippingCost === 0 ? "text-green-600 font-medium" : ""}>
                      {shippingCost === 0 ? "FREE" : formatPrice(shippingCost)}
                    </span>
                  </div>
                  <div className="border-t pt-3">
                    <div className="flex justify-between text-lg font-bold text-gray-800">
                      <span>Total</span>
                      <span className="text-amber-600">{formatPrice(total)}</span>
                    </div>
                  </div>
                </div>

                {/* Place Order Button */}
                <Button 
                  type="submit"
                  size="lg" 
                  className="w-full bg-gradient-to-r from-amber-500 to-rose-500 hover:from-amber-600 hover:to-rose-600 text-white rounded-full text-lg py-6"
                  disabled={isLoading}
                >
                  {isLoading ? "Placing Order..." : "Place Order"}
                </Button>

                {/* Trust Badges */}
                <div className="flex items-center justify-center gap-4 mt-6 text-gray-500">
                  <div className="flex items-center gap-1 text-xs">
                    <Shield className="h-4 w-4" />
                    <span>Secure</span>
                  </div>
                  <div className="flex items-center gap-1 text-xs">
                    <Truck className="h-4 w-4" />
                    <span>Fast Delivery</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </form>
      </div>
    </div>
  );
}
