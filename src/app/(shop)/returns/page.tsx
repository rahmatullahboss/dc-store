import Link from "next/link";
import { Package, Truck, RefreshCcw, Clock, CheckCircle, ArrowLeft, MapPin, CreditCard } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { siteConfig } from "@/lib/config";
import type { Metadata } from "next";

// Make this page fully static - no ISR, no KV writes
export const dynamic = "force-static";

export const metadata: Metadata = {
  title: `Returns & Shipping | ${siteConfig.name}`,
  description: "Learn about our return policy, shipping options, and delivery information.",
};

const returnSteps = [
  { icon: Package, title: "Request Return", description: "Go to Orders and select the item to return" },
  { icon: CheckCircle, title: "Get Approved", description: "We'll review and approve within 24 hours" },
  { icon: Truck, title: "Ship Item", description: "Pack the item and schedule a pickup" },
  { icon: CreditCard, title: "Get Refund", description: "Receive your refund within 5-7 days" },
];

const shippingZones = [
  { zone: "Inside Dhaka", delivery: "2-3 Business Days", cost: "৳60", freeAbove: "৳1000" },
  { zone: "Outside Dhaka", delivery: "3-5 Business Days", cost: "৳120", freeAbove: "৳2000" },
  { zone: "Remote Areas", delivery: "5-7 Business Days", cost: "৳150", freeAbove: "৳3000" },
];

const eligibleItems = [
  "Unused and unworn items",
  "Items in original packaging",
  "Items with all tags attached",
  "Items returned within 7 days",
];

const nonEligibleItems = [
  "Undergarments and swimwear",
  "Perishable goods",
  "Customized or personalized items",
  "Items marked as final sale",
  "Items without original packaging",
];

export default function ReturnsPage() {
  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8 max-w-5xl">
        {/* Header */}
        <div className="mb-8">
          <Link
            href="/"
            className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-primary mb-4"
          >
            <ArrowLeft className="h-4 w-4" /> Back to Home
          </Link>
          <div className="flex items-center gap-3 mb-4">
            <div className="p-3 bg-primary rounded-xl text-white">
              <RefreshCcw className="w-6 h-6" />
            </div>
            <div>
              <h1 className="text-2xl sm:text-3xl font-bold text-foreground">Returns & Shipping</h1>
              <p className="text-muted-foreground">Everything you need to know about returns and delivery</p>
            </div>
          </div>
        </div>

        {/* Return Policy Section */}
        <section className="mb-12">
          <div className="flex items-center gap-3 mb-6">
            <div className="h-8 w-1 bg-gradient-to-b from-amber-400 to-rose-400 rounded-full" />
            <h2 className="text-xl font-bold text-foreground">Return Policy</h2>
          </div>

          <Card className="bg-card/80 backdrop-blur mb-6">
            <CardContent className="p-6">
              <div className="bg-gradient-to-r from-amber-50 to-rose-50 rounded-xl p-6 mb-6">
                <p className="text-2xl font-bold text-foreground mb-2">7-Day Easy Returns</p>
                <p className="text-muted-foreground">
                  Not satisfied with your purchase? Return it within 7 days for a full refund. No questions asked!
                </p>
              </div>

              {/* Return Steps */}
              <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
                {returnSteps.map((step, index) => (
                  <div key={index} className="text-center p-4 rounded-xl bg-muted">
                    <div className="w-12 h-12 mx-auto bg-gradient-to-r from-amber-100 to-rose-100 rounded-full flex items-center justify-center mb-3">
                      <step.icon className="w-6 h-6 text-primary" />
                    </div>
                    <p className="font-semibold text-foreground text-sm mb-1">{step.title}</p>
                    <p className="text-xs text-muted-foreground">{step.description}</p>
                  </div>
                ))}
              </div>

              {/* Eligibility */}
              <div className="grid md:grid-cols-2 gap-6">
                <div>
                  <h3 className="font-semibold text-foreground mb-3 flex items-center gap-2">
                    <CheckCircle className="w-5 h-5 text-green-500" /> Eligible for Return
                  </h3>
                  <ul className="space-y-2">
                    {eligibleItems.map((item, index) => (
                      <li key={index} className="text-sm text-muted-foreground flex items-start gap-2">
                        <span className="text-green-500 mt-1">✓</span> {item}
                      </li>
                    ))}
                  </ul>
                </div>
                <div>
                  <h3 className="font-semibold text-foreground mb-3 flex items-center gap-2">
                    <RefreshCcw className="w-5 h-5 text-red-500" /> Not Eligible
                  </h3>
                  <ul className="space-y-2">
                    {nonEligibleItems.map((item, index) => (
                      <li key={index} className="text-sm text-muted-foreground flex items-start gap-2">
                        <span className="text-red-500 mt-1">✗</span> {item}
                      </li>
                    ))}
                  </ul>
                </div>
              </div>
            </CardContent>
          </Card>
        </section>

        {/* Shipping Section */}
        <section className="mb-12">
          <div className="flex items-center gap-3 mb-6">
            <div className="h-8 w-1 bg-gradient-to-b from-blue-400 to-purple-400 rounded-full" />
            <h2 className="text-xl font-bold text-foreground">Shipping Information</h2>
          </div>

          <Card className="bg-card/80 backdrop-blur">
            <CardContent className="p-6">
              {/* Free Shipping Banner */}
              <div className="bg-gradient-to-r from-green-500 to-emerald-500 text-white rounded-xl p-6 mb-6">
                <div className="flex items-center gap-3">
                  <Truck className="w-8 h-8" />
                  <div>
                    <p className="text-xl font-bold">Free Shipping on Orders ৳1000+</p>
                    <p className="text-white/80">Inside Dhaka • No code needed</p>
                  </div>
                </div>
              </div>

              {/* Shipping Zones Table */}
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b">
                      <th className="text-left py-3 px-4 font-semibold text-foreground">
                        <MapPin className="w-4 h-4 inline mr-2" />Delivery Zone
                      </th>
                      <th className="text-left py-3 px-4 font-semibold text-foreground">
                        <Clock className="w-4 h-4 inline mr-2" />Delivery Time
                      </th>
                      <th className="text-left py-3 px-4 font-semibold text-foreground">
                        <CreditCard className="w-4 h-4 inline mr-2" />Shipping Cost
                      </th>
                      <th className="text-left py-3 px-4 font-semibold text-foreground">Free Above</th>
                    </tr>
                  </thead>
                  <tbody>
                    {shippingZones.map((zone, index) => (
                      <tr key={index} className="border-b last:border-b-0 hover:bg-muted">
                        <td className="py-4 px-4 font-medium text-foreground">{zone.zone}</td>
                        <td className="py-4 px-4 text-muted-foreground">{zone.delivery}</td>
                        <td className="py-4 px-4 text-muted-foreground">{zone.cost}</td>
                        <td className="py-4 px-4">
                          <span className="text-green-600 font-medium">{zone.freeAbove}</span>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Additional Info */}
              <div className="mt-6 p-4 bg-amber-50 rounded-xl">
                <p className="text-sm text-amber-800">
                  <strong>Note:</strong> Delivery times are estimates and may vary during peak seasons or due to unforeseen circumstances. 
                  You&apos;ll receive tracking information via SMS and email once your order ships.
                </p>
              </div>
            </CardContent>
          </Card>
        </section>

        {/* CTA */}
        <div className="text-center">
          <p className="text-muted-foreground mb-4">Have more questions?</p>
          <div className="flex justify-center gap-4">
            <Link href="/faq">
              <Button variant="outline">View FAQ</Button>
            </Link>
            <Link href="/contact">
              <Button className="bg-primary text-white">
                Contact Support
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
