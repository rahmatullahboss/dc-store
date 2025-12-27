import Link from "next/link";
import { FileText, ArrowLeft } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { siteConfig } from "@/lib/config";
import type { Metadata } from "next";

// Make this page fully static - no ISR, no KV writes
export const dynamic = "force-static";

export const metadata: Metadata = {
  title: `Terms of Service | ${siteConfig.name}`,
  description: `Read the terms of service for ${siteConfig.name}. These terms govern your use of our website and services.`,
};

export default function TermsPage() {
  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden dark:hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8 max-w-4xl">
        {/* Header */}
        <div className="mb-8">
          <Link
            href="/"
            className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-primary mb-4"
          >
            <ArrowLeft className="h-4 w-4" /> Back to Home
          </Link>
          <div className="flex items-center gap-3 mb-4">
            <div className="p-2 bg-primary rounded-lg text-white">
              <FileText className="w-5 h-5" />
            </div>
            <h1 className="text-2xl sm:text-3xl font-bold text-foreground">Terms of Service</h1>
          </div>
          <p className="text-muted-foreground">Last updated: December 24, 2024</p>
        </div>

        <Card className="bg-card/80 backdrop-blur">
          <CardContent className="p-6 sm:p-10 prose prose-gray max-w-none">
            <h2>1. Introduction</h2>
            <p>
              Welcome to {siteConfig.name}. By accessing and using our website, you agree to be bound
              by these Terms of Service. Please read them carefully before using our services.
            </p>

            <h2>2. Definitions</h2>
            <ul>
              <li><strong>&quot;Service&quot;</strong> refers to the {siteConfig.name} website and all related services.</li>
              <li><strong>&quot;User&quot;</strong> refers to any individual who accesses or uses our Service.</li>
              <li><strong>&quot;Products&quot;</strong> refers to items available for purchase on our website.</li>
            </ul>

            <h2>3. Account Registration</h2>
            <p>
              To access certain features of our Service, you may need to create an account. You are
              responsible for maintaining the confidentiality of your account information and for all
              activities that occur under your account.
            </p>

            <h2>4. Orders and Payment</h2>
            <p>
              All orders are subject to acceptance and availability. We reserve the right to refuse
              or cancel any order for any reason. Prices are subject to change without notice.
            </p>
            <ul>
              <li>Orders are confirmed only after successful payment processing</li>
              <li>We accept major credit cards, bKash, and Nagad</li>
              <li>All prices are displayed in Bangladeshi Taka (BDT)</li>
            </ul>

            <h2>5. Shipping and Delivery</h2>
            <p>
              We strive to deliver your orders within the estimated timeframe. Delivery times may
              vary based on location and product availability.
            </p>
            <ul>
              <li>Inside Dhaka: 2-3 business days</li>
              <li>Outside Dhaka: 3-5 business days</li>
              <li>Shipping costs are calculated at checkout</li>
            </ul>

            <h2>6. Returns and Refunds</h2>
            <p>
              We offer a 7-day return policy for most items. Products must be unused and in their
              original packaging. Refunds will be processed within 5-7 business days after receiving
              the returned item.
            </p>

            <h2>7. Intellectual Property</h2>
            <p>
              All content on this website, including text, images, logos, and graphics, is the
              property of {siteConfig.name} and is protected by copyright laws.
            </p>

            <h2>8. Limitation of Liability</h2>
            <p>
              {siteConfig.name} shall not be liable for any indirect, incidental, special, or
              consequential damages arising out of your use of our Service.
            </p>

            <h2>9. Changes to Terms</h2>
            <p>
              We reserve the right to modify these Terms of Service at any time. Changes will be
              effective immediately upon posting on our website.
            </p>

            <h2>10. Contact Information</h2>
            <p>
              If you have any questions about these Terms, please contact us at:
            </p>
            <ul>
              <li>Email: support@{siteConfig.name.toLowerCase().replace(/\s/g, '')}.com</li>
              <li>Phone: +880 1XXX XXXXXX</li>
            </ul>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
