"use client";

import Image from "next/image";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState, useEffect } from "react";
import { loadStripe } from "@stripe/stripe-js";
import {
  Elements,
  PaymentElement,
  useStripe,
  useElements,
} from "@stripe/react-stripe-js";
import { 
  ArrowLeft, 
  ShoppingCart, 
  MapPin, 
  CreditCard, 
  Check,
  Truck,
  Shield,
  Banknote,
  Loader2
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

// Load Stripe
const stripePromise = loadStripe(
  process.env.NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY || ""
);

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

// Stripe Payment Form Component
function StripePaymentForm({ 
  onSuccess, 
  setIsProcessing 
}: { 
  onSuccess: () => void;
  setIsProcessing: (v: boolean) => void;
}) {
  const stripe = useStripe();
  const elements = useElements();
  const [error, setError] = useState<string | null>(null);

  const handleStripeSubmit = async () => {
    if (!stripe || !elements) return false;

    setIsProcessing(true);
    setError(null);

    const { error: submitError } = await stripe.confirmPayment({
      elements,
      confirmParams: {
        return_url: `${window.location.origin}/orders?success=true`,
      },
      redirect: "if_required",
    });

    if (submitError) {
      setError(submitError.message || "Payment failed");
      setIsProcessing(false);
      return false;
    }

    onSuccess();
    return true;
  };

  // Expose the submit function via a ref-like pattern
  useEffect(() => {
    (window as unknown as { stripeSubmit?: () => Promise<boolean> }).stripeSubmit = handleStripeSubmit;
    return () => {
      delete (window as unknown as { stripeSubmit?: () => Promise<boolean> }).stripeSubmit;
    };
  });

  return (
    <div className="space-y-4">
      <PaymentElement options={{ layout: "tabs" }} />
      {error && (
        <div className="p-3 bg-red-50 border border-red-200 rounded-lg text-red-700 text-sm">
          {error}
        </div>
      )}
      <div className="flex items-center gap-2 text-sm text-muted-foreground">
        <Shield className="h-4 w-4" />
        <span>Secured by Stripe</span>
      </div>
    </div>
  );
}

export default function CheckoutPage() {
  const router = useRouter();
  const { items, subtotal, clearCart } = useCart();
  const { data: session } = useSession();
  const [isLoading, setIsLoading] = useState(false);
  const [profileLoaded, setProfileLoaded] = useState(false);
  const [paymentMethod, setPaymentMethod] = useState<"cod" | "stripe">("cod");
  const [clientSecret, setClientSecret] = useState<string | null>(null);
  const [stripeLoading, setStripeLoading] = useState(false);
  const [stripeError, setStripeError] = useState<string | null>(null);
  const [formData, setFormData] = useState<FormData>({
    name: "",
    phone: "",
    email: "",
    division: "",
    district: "",
    address: "",
    notes: "",
  });

  const shippingCost = subtotal >= siteConfig.shipping.freeShippingThreshold 
    ? 0 
    : siteConfig.shipping.defaultShippingCost;
  const total = subtotal + shippingCost;

  // Fetch and pre-fill form with user profile data
  useEffect(() => {
    async function fetchProfile() {
      if (session?.user && !profileLoaded) {
        try {
          const res = await fetch("/api/user/profile");
          if (res.ok) {
            const data = await res.json() as { 
              profile: { 
                name: string; 
                email: string; 
                phone?: string; 
                defaultAddress?: { division?: string; district?: string; address?: string; } | string;
              } 
            };
            if (data.profile) {
              // Robust parsing for defaultAddress - handle multiple levels of JSON encoding
              let parsedAddress: { division?: string; district?: string; address?: string; } | null = null;
              
              const parseAddress = (input: unknown): { division?: string; district?: string; address?: string; } | null => {
                if (!input) return null;
                
                // If it's already an object with expected properties
                if (typeof input === 'object' && input !== null && !Array.isArray(input)) {
                  const obj = input as Record<string, unknown>;
                  // Check if it has valid address properties (not char-indexed corruption)
                  if (obj.division || obj.district || obj.address) {
                    return obj as { division?: string; district?: string; address?: string; };
                  }
                  // Check for char-indexed corruption (keys are "0", "1", "2"...)
                  const keys = Object.keys(obj);
                  if (keys.length > 0 && !isNaN(Number(keys[0]))) {
                    return null; // Corrupted data
                  }
                }
                
                // If it's a string, try to parse it (may need multiple attempts for double-encoding)
                if (typeof input === 'string') {
                  let current = input;
                  for (let i = 0; i < 3; i++) { // Try up to 3 parse attempts
                    try {
                      const parsed = JSON.parse(current);
                      if (typeof parsed === 'string') {
                        current = parsed; // Double-encoded, try again
                        continue;
                      }
                      if (typeof parsed === 'object' && parsed !== null) {
                        // Check if it has valid properties
                        if (parsed.division || parsed.district || parsed.address) {
                          return parsed;
                        }
                      }
                    } catch {
                      break; // Not valid JSON
                    }
                  }
                }
                
                return null;
              };
              
              parsedAddress = parseAddress(data.profile.defaultAddress);
              
              // Debug: Log the parsed address
              console.log("Profile address data:", {
                raw: data.profile.defaultAddress,
                parsed: parsedAddress,
                district: parsedAddress?.district,
              });
              
              setFormData(prev => ({
                ...prev,
                name: prev.name || data.profile.name || "",
                email: prev.email || data.profile.email || "",
                phone: prev.phone || data.profile.phone || "",
                division: prev.division || parsedAddress?.division || "",
                district: prev.district || parsedAddress?.district || "",
                address: prev.address || parsedAddress?.address || "",
              }));
            }
          }
        } catch (error) {
          console.error("Error fetching profile:", error);
        }
        setProfileLoaded(true);
      }
    }
    fetchProfile();
  }, [session, profileLoaded]);

  // Create Stripe Payment Intent when selecting card payment
  useEffect(() => {
    if (paymentMethod === "stripe" && !clientSecret && items.length > 0) {
      setStripeLoading(true);
      setStripeError(null);
      fetch("/api/payments/create-intent", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          amount: Math.round(total * 100),
          currency: "bdt",
        }),
      })
        .then(async (res) => {
          const data = await res.json() as { clientSecret?: string; error?: string };
          if (!res.ok || data.error) {
            throw new Error(data.error || "Failed to initialize payment");
          }
          return data;
        })
        .then((data) => {
          if (data.clientSecret) {
            setClientSecret(data.clientSecret);
          } else {
            throw new Error("No client secret received from payment provider");
          }
        })
        .catch((err: Error) => {
          console.error("Payment intent error:", err);
          setStripeError(err.message || "Failed to load payment. Please try again.");
          toast.error(err.message || "Failed to load payment. Please try again.");
        })
        .finally(() => setStripeLoading(false));
    }
  }, [paymentMethod, clientSecret, total, items.length]);

  // Empty cart redirect
  if (items.length === 0) {
    return (
      <div className="min-h-screen bg-background">
        <div className="relative z-10 container mx-auto px-4 py-16">
          <div className="flex flex-col items-center justify-center gap-6 text-center">
            <div className="p-6 bg-gradient-to-br from-amber-100 to-rose-100 rounded-full">
              <ShoppingCart className="h-16 w-16 text-primary" />
            </div>
            <h1 className="text-2xl font-bold text-foreground">Your cart is empty</h1>
            <p className="text-muted-foreground max-w-md">
              Add some products to your cart before checkout.
            </p>
            <Button 
              size="lg" 
              className="bg-primary hover:from-amber-600 hover:to-rose-600 text-white rounded-full px-8"
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

  const handleInputChange = (field: keyof FormData, value: string, clearDistrict = true) => {
    setFormData(prev => ({ ...prev, [field]: value }));
    // Only clear district when user manually changes division (not during profile load)
    if (field === "division" && clearDistrict) {
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
      // For Stripe, confirm payment first
      if (paymentMethod === "stripe") {
        const stripeSubmit = (window as unknown as { stripeSubmit?: () => Promise<boolean> }).stripeSubmit;
        if (stripeSubmit) {
          const success = await stripeSubmit();
          if (!success) {
            setIsLoading(false);
            return;
          }
        }
      }

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
          paymentMethod: paymentMethod,
          paymentStatus: paymentMethod === "stripe" ? "paid" : "pending",
        }),
      });

      if (!response.ok) {
        throw new Error("Failed to create order");
      }

      const data = await response.json() as { order: { id: string; orderNumber: string } };
      
      // Save shipping info to user profile for future orders (if logged in)
      if (session?.user) {
        try {
          await fetch("/api/user/profile", {
            method: "PATCH",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              phone: formData.phone,
              defaultAddress: {
                division: formData.division,
                district: formData.district,
                address: formData.address,
              },
            }),
          });
        } catch (error) {
          console.error("Error saving profile:", error);
        }
      }

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
            <Link href="/cart">
              <ArrowLeft className="h-5 w-5" />
            </Link>
          </Button>
          <div>
            <h1 className="text-2xl md:text-3xl font-bold text-foreground">
              Checkout
            </h1>
            <p className="text-muted-foreground">Complete your order</p>
          </div>
        </div>

        {/* Progress Steps */}
        <div className="flex items-center justify-center gap-4 mb-8">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-primary text-white flex items-center justify-center text-sm font-bold">
              <Check className="h-4 w-4" />
            </div>
            <span className="text-sm font-medium text-foreground hidden sm:block">Cart</span>
          </div>
          <div className="w-8 md:w-16 h-0.5 bg-primary" />
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-primary text-white flex items-center justify-center text-sm font-bold">
              2
            </div>
            <span className="text-sm font-medium text-foreground hidden sm:block">Shipping</span>
          </div>
          <div className="w-8 md:w-16 h-0.5 bg-gray-300" />
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-full bg-gray-300 text-muted-foreground flex items-center justify-center text-sm font-bold">
              3
            </div>
            <span className="text-sm font-medium text-muted-foreground hidden sm:block">Done</span>
          </div>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="grid lg:grid-cols-3 gap-8">
            {/* Shipping Form */}
            <div className="lg:col-span-2 space-y-6">
              {/* Contact Information */}
              <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
                <div className="flex items-center gap-3 mb-6">
                  <div className="p-2 bg-primary rounded-lg text-white">
                    <MapPin className="h-5 w-5" />
                  </div>
                  <h2 className="text-lg font-bold text-foreground">Shipping Information</h2>
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
                      key={`district-${formData.division}`}
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
              <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
                <div className="flex items-center gap-3 mb-6">
                  <div className="p-2 bg-primary rounded-lg text-white">
                    <CreditCard className="h-5 w-5" />
                  </div>
                  <h2 className="text-lg font-bold text-foreground">Payment Method</h2>
                </div>

                <div className="space-y-4">
                  {/* Cash on Delivery */}
                  <button
                    type="button"
                    onClick={() => setPaymentMethod("cod")}
                    className={`w-full p-4 border-2 rounded-xl flex items-center gap-4 transition-all ${
                      paymentMethod === "cod"
                        ? "border-amber-500 bg-amber-50"
                        : "border-border hover:border-gray-300"
                    }`}
                  >
                    <div className={`p-3 rounded-full ${
                      paymentMethod === "cod"
                        ? "bg-primary text-white"
                        : "bg-muted text-muted-foreground"
                    }`}>
                      <Banknote className="h-6 w-6" />
                    </div>
                    <div className="flex-1 text-left">
                      <h3 className="font-bold text-foreground">Cash on Delivery</h3>
                      <p className="text-sm text-muted-foreground">Pay when you receive your order</p>
                    </div>
                    {paymentMethod === "cod" && (
                      <div className="w-6 h-6 rounded-full bg-primary flex items-center justify-center">
                        <Check className="h-4 w-4 text-white" />
                      </div>
                    )}
                  </button>

                  {/* Card Payment (Stripe) */}
                  <button
                    type="button"
                    onClick={() => setPaymentMethod("stripe")}
                    className={`w-full p-4 border-2 rounded-xl flex items-center gap-4 transition-all ${
                      paymentMethod === "stripe"
                        ? "border-amber-500 bg-amber-50"
                        : "border-border hover:border-gray-300"
                    }`}
                  >
                    <div className={`p-3 rounded-full ${
                      paymentMethod === "stripe"
                        ? "bg-primary text-white"
                        : "bg-muted text-muted-foreground"
                    }`}>
                      <CreditCard className="h-6 w-6" />
                    </div>
                    <div className="flex-1 text-left">
                      <h3 className="font-bold text-foreground">Credit/Debit Card</h3>
                      <p className="text-sm text-muted-foreground">Pay securely with Stripe</p>
                    </div>
                    {paymentMethod === "stripe" && (
                      <div className="w-6 h-6 rounded-full bg-primary flex items-center justify-center">
                        <Check className="h-4 w-4 text-white" />
                      </div>
                    )}
                  </button>

                  {/* Stripe Elements */}
                  {paymentMethod === "stripe" && (
                    <div className="mt-4 p-4 bg-muted rounded-xl">
                      {stripeLoading ? (
                        <div className="flex items-center justify-center py-8">
                          <Loader2 className="h-8 w-8 animate-spin text-primary" />
                        </div>
                      ) : clientSecret ? (
                        <Elements
                          stripe={stripePromise}
                          options={{
                            clientSecret,
                            appearance: {
                              theme: "stripe",
                              variables: {
                                colorPrimary: "#f59e0b",
                                borderRadius: "12px",
                              },
                            },
                          }}
                        >
                        <StripePaymentForm
                            onSuccess={() => {}}
                            setIsProcessing={setIsLoading}
                          />
                        </Elements>
                      ) : (
                        <div className="text-center py-4 space-y-3">
                          <p className="text-red-600">
                            {stripeError || "Unable to load payment form. Please try again."}
                          </p>
                          <Button
                            type="button"
                            variant="outline"
                            size="sm"
                            onClick={() => {
                              setStripeError(null);
                              setClientSecret(null);
                            }}
                          >
                            Retry
                          </Button>
                        </div>
                      )}
                    </div>
                  )}
                </div>
              </div>
            </div>

            {/* Order Summary */}
            <div className="lg:col-span-1">
              <div className="bg-card rounded-2xl p-6 shadow-lg border border-border sticky top-4">
                <h2 className="text-xl font-bold text-foreground mb-6">Order Summary</h2>

                {/* Items */}
                <div className="space-y-4 mb-6 max-h-64 overflow-y-auto">
                  {items.map((item) => (
                    <div
                      key={`${item.productId}-${item.variantId || ""}`}
                      className="flex gap-3"
                    >
                      <div className="relative h-16 w-16 flex-shrink-0 overflow-hidden rounded-lg bg-muted">
                        {item.image ? (
                          <Image
                            src={item.image}
                            alt={item.name}
                            fill
                            className="object-cover"
                          />
                        ) : (
                          <div className="flex h-full items-center justify-center text-muted-foreground">
                            <ShoppingCart className="h-6 w-6" />
                          </div>
                        )}
                        <div className="absolute -top-1 -right-1 w-5 h-5 bg-primary text-white text-xs rounded-full flex items-center justify-center font-bold">
                          {item.quantity}
                        </div>
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="text-sm font-medium text-foreground line-clamp-2">
                          {item.name}
                        </h4>
                        <p className="text-sm text-primary font-bold">
                          {formatPrice(item.price * item.quantity)}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>

                {/* Price Breakdown */}
                <div className="space-y-3 mb-6 pt-4 border-t">
                  <div className="flex justify-between text-muted-foreground">
                    <span>Subtotal</span>
                    <span>{formatPrice(subtotal)}</span>
                  </div>
                  <div className="flex justify-between text-muted-foreground">
                    <span>Shipping</span>
                    <span className={shippingCost === 0 ? "text-green-600 font-medium" : ""}>
                      {shippingCost === 0 ? "FREE" : formatPrice(shippingCost)}
                    </span>
                  </div>
                  <div className="border-t pt-3">
                    <div className="flex justify-between text-lg font-bold text-foreground">
                      <span>Total</span>
                      <span className="text-primary">{formatPrice(total)}</span>
                    </div>
                  </div>
                </div>

                {/* Place Order Button */}
                <Button 
                  type="submit"
                  size="lg" 
                  className="w-full bg-primary hover:from-amber-600 hover:to-rose-600 text-white rounded-full text-lg py-6"
                  disabled={isLoading}
                >
                  {isLoading ? (
                    <>
                      <Loader2 className="mr-2 h-5 w-5 animate-spin" />
                      Processing...
                    </>
                  ) : paymentMethod === "stripe" ? (
                    "Pay & Place Order"
                  ) : (
                    "Place Order"
                  )}
                </Button>

                {/* Trust Badges */}
                <div className="flex items-center justify-center gap-4 mt-6 text-muted-foreground">
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
