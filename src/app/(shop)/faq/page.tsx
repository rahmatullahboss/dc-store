"use client";

import { useState } from "react";
import Link from "next/link";
import { Search, ChevronDown, HelpCircle, Package, CreditCard, RotateCcw, User, MessageCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";

const faqCategories = [
  {
    id: "orders",
    name: "Orders & Shipping",
    icon: Package,
    questions: [
      {
        question: "How can I track my order?",
        answer: "You can track your order by visiting the Track Order page and entering your order number. You'll also receive tracking updates via email and SMS.",
      },
      {
        question: "How long does delivery take?",
        answer: "Inside Dhaka: 2-3 business days. Outside Dhaka: 3-5 business days. Express delivery options are available at checkout for faster delivery.",
      },
      {
        question: "Do you offer free shipping?",
        answer: "Yes! We offer free shipping on all orders above ৳1000. Orders below this amount have a flat shipping fee of ৳60 (Dhaka) or ৳120 (Outside Dhaka).",
      },
      {
        question: "Can I change my delivery address after placing an order?",
        answer: "You can change your delivery address within 2 hours of placing your order by contacting our support team. After this window, changes may not be possible if the order has already been processed.",
      },
    ],
  },
  {
    id: "returns",
    name: "Returns & Refunds",
    icon: RotateCcw,
    questions: [
      {
        question: "What is your return policy?",
        answer: "We offer a 7-day return policy for most items. Products must be unused, in original packaging, and with all tags attached. Some items like undergarments and perishables are non-returnable.",
      },
      {
        question: "How do I initiate a return?",
        answer: "Go to your Orders page, select the order, and click 'Return Item'. Follow the instructions to print your return label and schedule a pickup or drop-off.",
      },
      {
        question: "How long does a refund take?",
        answer: "Refunds are processed within 5-7 business days after we receive and inspect the returned item. The amount will be credited to your original payment method.",
      },
      {
        question: "Can I exchange an item instead of returning it?",
        answer: "Yes! During the return process, you can choose to exchange for a different size or color. We'll ship the replacement as soon as we receive your return.",
      },
    ],
  },
  {
    id: "payments",
    name: "Payments",
    icon: CreditCard,
    questions: [
      {
        question: "What payment methods do you accept?",
        answer: "We accept bKash, Nagad, Visa, Mastercard, American Express, and Cash on Delivery (COD). All online payments are secured with SSL encryption.",
      },
      {
        question: "Is Cash on Delivery available everywhere?",
        answer: "COD is available for most locations in Bangladesh. Some remote areas may have COD restrictions. You'll see available payment options at checkout based on your delivery address.",
      },
      {
        question: "Are there any extra charges for Cash on Delivery?",
        answer: "There's a small COD fee of ৳20 per order. This helps cover the additional logistics costs for handling cash payments.",
      },
      {
        question: "Is my payment information secure?",
        answer: "Absolutely! We use industry-standard SSL encryption and never store your card details. All transactions are processed through secure, PCI-compliant payment gateways.",
      },
    ],
  },
  {
    id: "account",
    name: "Account",
    icon: User,
    questions: [
      {
        question: "How do I create an account?",
        answer: "Click the 'Sign Up' button in the header, enter your email and create a password. You can also sign up quickly using your Google account.",
      },
      {
        question: "I forgot my password. How do I reset it?",
        answer: "Click 'Forgot Password' on the login page, enter your email, and we'll send you a reset link. The link is valid for 24 hours.",
      },
      {
        question: "Can I order without creating an account?",
        answer: "Currently, you need an account to place orders. This helps us track your orders and provide better support. Creating an account takes less than a minute!",
      },
      {
        question: "How do I delete my account?",
        answer: "Contact our support team to request account deletion. We'll process your request within 48 hours and confirm via email.",
      },
    ],
  },
];

export default function FAQPage() {
  const [searchQuery, setSearchQuery] = useState("");
  const [openItems, setOpenItems] = useState<Record<string, boolean>>({});

  const toggleItem = (categoryId: string, index: number) => {
    const key = `${categoryId}-${index}`;
    setOpenItems((prev) => ({ ...prev, [key]: !prev[key] }));
  };

  const filteredCategories = faqCategories.map((category) => ({
    ...category,
    questions: category.questions.filter(
      (q) =>
        q.question.toLowerCase().includes(searchQuery.toLowerCase()) ||
        q.answer.toLowerCase().includes(searchQuery.toLowerCase())
    ),
  })).filter((category) => category.questions.length > 0);

  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl dark:opacity-0" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl dark:opacity-0" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8 max-w-4xl">
        {/* Header */}
        <div className="text-center mb-10">
          <div className="w-16 h-16 mx-auto bg-primary rounded-full flex items-center justify-center mb-4">
            <HelpCircle className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-3xl sm:text-4xl font-bold text-foreground mb-3">
            Frequently Asked Questions
          </h1>
          <p className="text-muted-foreground max-w-lg mx-auto">
            Find answers to common questions about orders, shipping, returns, and more.
          </p>
        </div>

        {/* Search */}
        <div className="mb-10">
          <div className="relative max-w-xl mx-auto">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-muted-foreground" />
            <Input
              placeholder="Search for answers..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-12 py-6 text-lg rounded-xl bg-card shadow-lg border-0"
            />
          </div>
        </div>

        {/* FAQ Categories */}
        <div className="space-y-8">
          {filteredCategories.map((category) => {
            const IconComponent = category.icon;
            return (
              <Card key={category.id} className="bg-card/80 backdrop-blur border-0 shadow-lg overflow-hidden">
                {/* Category Header */}
                <div className="bg-gradient-to-r from-amber-50 to-rose-50 px-6 py-4 border-b">
                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-primary rounded-lg text-white">
                      <IconComponent className="w-5 h-5" />
                    </div>
                    <h2 className="text-lg font-bold text-foreground">{category.name}</h2>
                  </div>
                </div>

                {/* Questions */}
                <CardContent className="p-0">
                  {category.questions.map((item, index) => {
                    const isOpen = openItems[`${category.id}-${index}`];
                    return (
                      <div key={index} className="border-b last:border-b-0">
                        <button
                          onClick={() => toggleItem(category.id, index)}
                          className="w-full px-6 py-4 text-left flex items-center justify-between hover:bg-muted transition-colors"
                        >
                          <span className="font-medium text-foreground pr-4">{item.question}</span>
                          <ChevronDown
                            className={`w-5 h-5 text-muted-foreground flex-shrink-0 transition-transform ${
                              isOpen ? "rotate-180" : ""
                            }`}
                          />
                        </button>
                        {isOpen && (
                          <div className="px-6 pb-4">
                            <p className="text-muted-foreground leading-relaxed">{item.answer}</p>
                          </div>
                        )}
                      </div>
                    );
                  })}
                </CardContent>
              </Card>
            );
          })}
        </div>

        {/* No Results */}
        {filteredCategories.length === 0 && searchQuery && (
          <div className="text-center py-12">
            <HelpCircle className="w-12 h-12 text-muted-foreground mx-auto mb-4" />
            <p className="text-muted-foreground">No results found for &quot;{searchQuery}&quot;</p>
          </div>
        )}

        {/* Contact CTA */}
        <Card className="mt-12 bg-primary text-white border-0">
          <CardContent className="p-8 text-center">
            <MessageCircle className="w-12 h-12 mx-auto mb-4 opacity-80" />
            <h3 className="text-2xl font-bold mb-2">Still have questions?</h3>
            <p className="text-white/80 mb-6">
              Our support team is available 24/7 to help you with any questions.
            </p>
            <Link href="/contact">
              <Button size="lg" className="bg-card text-primary hover:bg-muted">
                Contact Support
              </Button>
            </Link>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
