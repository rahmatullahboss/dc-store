import Link from "next/link";
import { Shield, ArrowLeft } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { siteConfig } from "@/lib/config";
import type { Metadata } from "next";

// Make this page fully static - no ISR, no KV writes
export const dynamic = "force-static";

export const metadata: Metadata = {
  title: `Privacy Policy | ${siteConfig.name}`,
  description: `Learn about how ${siteConfig.name} collects, uses, and protects your personal information.`,
};

export default function PrivacyPage() {
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
              <Shield className="w-5 h-5" />
            </div>
            <h1 className="text-2xl sm:text-3xl font-bold text-foreground">Privacy Policy</h1>
          </div>
          <p className="text-muted-foreground">Last updated: December 24, 2024</p>
        </div>

        <Card className="bg-card/80 backdrop-blur">
          <CardContent className="p-6 sm:p-10 prose prose-gray max-w-none">
            <h2>1. Information We Collect</h2>
            <p>
              At {siteConfig.name}, we collect information to provide better services to our users.
              The types of information we collect include:
            </p>
            <ul>
              <li><strong>Personal Information:</strong> Name, email address, phone number, shipping address</li>
              <li><strong>Payment Information:</strong> Credit card details (processed securely through payment gateways)</li>
              <li><strong>Usage Data:</strong> Pages visited, time spent on site, browser type</li>
              <li><strong>Device Information:</strong> IP address, device type, operating system</li>
            </ul>

            <h2>2. How We Use Your Information</h2>
            <p>We use the information we collect for the following purposes:</p>
            <ul>
              <li>Processing and fulfilling your orders</li>
              <li>Communicating with you about orders, products, and services</li>
              <li>Improving our website and customer experience</li>
              <li>Sending promotional offers (with your consent)</li>
              <li>Preventing fraud and ensuring security</li>
            </ul>

            <h2>3. Information Sharing</h2>
            <p>
              We do not sell your personal information to third parties. We may share your
              information with:
            </p>
            <ul>
              <li><strong>Service Providers:</strong> Shipping companies, payment processors</li>
              <li><strong>Legal Requirements:</strong> When required by law or to protect our rights</li>
              <li><strong>Business Transfers:</strong> In case of merger or acquisition</li>
            </ul>

            <h2>4. Data Security</h2>
            <p>
              We implement industry-standard security measures to protect your personal information:
            </p>
            <ul>
              <li>SSL encryption for all data transmission</li>
              <li>Secure payment processing through trusted gateways</li>
              <li>Regular security audits and updates</li>
              <li>Limited access to personal data by authorized personnel only</li>
            </ul>

            <h2>5. Cookies</h2>
            <p>
              We use cookies to enhance your browsing experience. Cookies help us:
            </p>
            <ul>
              <li>Remember your preferences and cart items</li>
              <li>Analyze website traffic and usage patterns</li>
              <li>Provide personalized recommendations</li>
            </ul>
            <p>
              You can control cookie settings through your browser. Disabling cookies may affect
              some features of our website.
            </p>

            <h2>6. Your Rights</h2>
            <p>You have the right to:</p>
            <ul>
              <li>Access the personal information we hold about you</li>
              <li>Request correction of inaccurate data</li>
              <li>Request deletion of your data (subject to legal requirements)</li>
              <li>Opt-out of marketing communications</li>
              <li>Withdraw consent at any time</li>
            </ul>

            <h2>7. Children&apos;s Privacy</h2>
            <p>
              Our services are not intended for children under 13. We do not knowingly collect
              personal information from children under 13. If you believe we have collected such
              information, please contact us immediately.
            </p>

            <h2>8. Changes to This Policy</h2>
            <p>
              We may update this Privacy Policy from time to time. We will notify you of any
              significant changes by posting a notice on our website or sending you an email.
            </p>

            <h2>9. Contact Us</h2>
            <p>
              If you have any questions about this Privacy Policy or our data practices, please
              contact us:
            </p>
            <ul>
              <li>Email: privacy@{siteConfig.name.toLowerCase().replace(/\s/g, '')}.com</li>
              <li>Phone: +880 1XXX XXXXXX</li>
              <li>Address: Dhaka, Bangladesh</li>
            </ul>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
