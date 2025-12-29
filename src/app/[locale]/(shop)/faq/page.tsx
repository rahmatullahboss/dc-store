"use client";

import { useState } from "react";
import { Search, ChevronDown, ChevronUp, Package, RefreshCw, CreditCard, User, Mail, MessageCircle, Phone } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { useTranslations } from "next-intl";

type FAQCategory = "orders" | "returns" | "payments" | "account";

export default function FAQPage() {
  const t = useTranslations("FAQ");
  const [activeCategory, setActiveCategory] = useState<FAQCategory>("orders");
  const [searchQuery, setSearchQuery] = useState("");
  const [openItems, setOpenItems] = useState<string[]>([]);

  const faqCategories = [
    { id: "orders", name: t("categories.orders"), icon: Package },
    { id: "returns", name: t("categories.returns"), icon: RefreshCw },
    { id: "payments", name: t("categories.payments"), icon: CreditCard },
    { id: "account", name: t("categories.account"), icon: User },
  ] as const;

  const faqs = {
    orders: [
      { id: "track-order", q: t("questions.orders.track.q"), a: t("questions.orders.track.a") },
      { id: "delivery-time", q: t("questions.orders.delivery.q"), a: t("questions.orders.delivery.a") },
      { id: "shipping-cost", q: t("questions.orders.shipping.q"), a: t("questions.orders.shipping.a") },
      { id: "change-address", q: t("questions.orders.address.q"), a: t("questions.orders.address.a") },
    ],
    returns: [
      { id: "return-policy", q: t("questions.returns.policy.q"), a: t("questions.returns.policy.a") },
      { id: "how-to-return", q: t("questions.returns.initiate.q"), a: t("questions.returns.initiate.a") },
      { id: "refund-time", q: t("questions.returns.refund.q"), a: t("questions.returns.refund.a") },
      { id: "exchange", q: t("questions.returns.exchange.q"), a: t("questions.returns.exchange.a") },
    ],
    payments: [
      { id: "payment-methods", q: t("questions.payments.methods.q"), a: t("questions.payments.methods.a") },
      { id: "cod", q: t("questions.payments.cod.q"), a: t("questions.payments.cod.a") },
      { id: "cod-charges", q: t("questions.payments.charges.q"), a: t("questions.payments.charges.a") },
      { id: "security", q: t("questions.payments.secure.q"), a: t("questions.payments.secure.a") },
    ],
    account: [
      { id: "create-account", q: t("questions.account.create.q"), a: t("questions.account.create.a") },
      { id: "forgot-password", q: t("questions.account.forgot.q"), a: t("questions.account.forgot.a") },
      { id: "guest-checkout", q: t("questions.account.guest.q"), a: t("questions.account.guest.a") },
      { id: "delete-account", q: t("questions.account.delete.q"), a: t("questions.account.delete.a") },
    ],
  };

  const toggleItem = (id: string) => {
    setOpenItems((prev) =>
      prev.includes(id) ? prev.filter((item) => item !== id) : [...prev, id]
    );
  };

  // Filter FAQs based on search
  const filteredFAQs = searchQuery
    ? Object.values(faqs).flat().filter(
        (faq) =>
          faq.q.toLowerCase().includes(searchQuery.toLowerCase()) ||
          faq.a.toLowerCase().includes(searchQuery.toLowerCase())
      )
    : faqs[activeCategory];

  return (
    <div className="min-h-screen bg-background pb-20">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
        <div className="absolute top-0 right-0 h-[500px] w-[500px] bg-indigo-100/50 blur-[100px]" />
        <div className="absolute bottom-0 left-0 h-[500px] w-[500px] bg-rose-100/50 blur-[100px]" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-12">
        {/* Header */}
        <div className="text-center max-w-2xl mx-auto mb-12">
          <h1 className="text-4xl font-bold text-foreground mb-4">{t("title")}</h1>
          <p className="text-muted-foreground text-lg mb-8">
            {t("subtitle")}
          </p>
          
          <div className="relative">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-muted-foreground" />
            <Input
              placeholder={t("searchPlaceholder")}
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-12 py-6 text-lg rounded-full bg-card shadow-sm border-2 focus:border-primary"
            />
          </div>
        </div>

        <div className="grid lg:grid-cols-4 gap-8">
          {/* Categories Sidebar */}
          {!searchQuery && (
            <div className="lg:col-span-1 space-y-2">
              {faqCategories.map((category) => {
                const Icon = category.icon;
                return (
                  <button
                    key={category.id}
                    onClick={() => setActiveCategory(category.id as FAQCategory)}
                    className={`w-full flex items-center gap-3 p-4 rounded-xl transition-all duration-300 ${
                      activeCategory === category.id
                        ? "bg-primary text-white shadow-lg scale-105"
                        : "bg-card text-foreground hover:bg-muted"
                    }`}
                  >
                    <Icon className="w-5 h-5" />
                    <span className="font-medium">{category.name}</span>
                  </button>
                );
              })}
            </div>
          )}

          {/* FAQ Items */}
          <div className={`${searchQuery ? "lg:col-span-4 max-w-3xl mx-auto" : "lg:col-span-3"}`}>
            <div className="space-y-4">
              {filteredFAQs.length > 0 ? (
                filteredFAQs.map((faq) => (
                  <Card
                    key={faq.id}
                    className="border-0 bg-card/80 backdrop-blur shadow-sm hover:shadow-md transition-all duration-300"
                  >
                    <button
                      onClick={() => toggleItem(faq.id)}
                      className="w-full flex items-center justify-between p-6 text-left"
                    >
                      <span className="font-semibold text-lg text-foreground pr-8">
                        {faq.q}
                      </span>
                      {openItems.includes(faq.id) ? (
                        <ChevronUp className="w-5 h-5 text-primary flex-shrink-0" />
                      ) : (
                        <ChevronDown className="w-5 h-5 text-muted-foreground flex-shrink-0" />
                      )}
                    </button>
                    <div
                      className={`grid transition-all duration-300 ease-in-out ${
                        openItems.includes(faq.id) ? "grid-rows-[1fr] opacity-100" : "grid-rows-[0fr] opacity-0"
                      }`}
                    >
                      <div className="overflow-hidden">
                        <div className="px-6 pb-6 text-muted-foreground leading-relaxed border-t pt-4">
                          {faq.a}
                        </div>
                      </div>
                    </div>
                  </Card>
                ))
              ) : (
                <div className="text-center py-12">
                  <p className="text-muted-foreground text-lg">
                    {t("noResults", { query: searchQuery })}
                  </p>
                </div>
              )}
            </div>
          </div>
        </div>

        {/* Contact CTA */}
        <div className="mt-20 text-center">
          <Card className="max-w-3xl mx-auto bg-gradient-to-r from-violet-500 to-fuchsia-500 text-white border-0">
            <CardContent className="p-8 sm:p-12">
              <h2 className="text-2xl sm:text-3xl font-bold mb-4">{t("cta.title")}</h2>
              <p className="text-white/90 mb-8 max-w-xl mx-auto">
                {t("cta.desc")}
              </p>
              <div className="flex flex-col sm:flex-row gap-4 justify-center">
                <Button size="lg" variant="secondary" className="gap-2">
                  <Phone className="w-4 h-4" />
                  {t("help.call")}
                </Button>
                <Button size="lg" className="bg-white/20 hover:bg-white/30 text-white gap-2 border-0">
                  <MessageCircle className="w-4 h-4" />
                  {t("help.chat")}
                </Button>
                <Button size="lg" className="bg-white/20 hover:bg-white/30 text-white gap-2 border-0">
                  <Mail className="w-4 h-4" />
                  {t("cta.button")}
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  );
}
