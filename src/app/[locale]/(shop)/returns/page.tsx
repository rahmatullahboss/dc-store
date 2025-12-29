import { Link } from "@/i18n/routing";
import { Package, Truck, RefreshCcw, Clock, CheckCircle, ArrowLeft, MapPin, CreditCard } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { siteConfig } from "@/lib/config";

// Make this page fully static - no ISR, no KV writes
import { useTranslations } from "next-intl";
import { getTranslations } from "next-intl/server";

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Legal.Returns" });
  
  return {
    title: `${t("meta.title")} | ${siteConfig.name}`,
    description: t("meta.description"),
  };
}

export default function ReturnsPage() {
  const t = useTranslations("Legal.Returns");
  const tCommon = useTranslations("Common");
  
  const returnSteps = [
    { icon: Package, title: t("policy.steps.request.title"), description: t("policy.steps.request.desc") },
    { icon: CheckCircle, title: t("policy.steps.approve.title"), description: t("policy.steps.approve.desc") },
    { icon: Truck, title: t("policy.steps.ship.title"), description: t("policy.steps.ship.desc") },
    { icon: CreditCard, title: t("policy.steps.refund.title"), description: t("policy.steps.refund.desc") },
  ];

  const shippingZones = [
    { zone: t("shipping.zones.dhaka.zone"), delivery: t("shipping.zones.dhaka.delivery"), cost: "৳60", freeAbove: "৳1000" },
    { zone: t("shipping.zones.outside.zone"), delivery: t("shipping.zones.outside.delivery"), cost: "৳120", freeAbove: "৳2000" },
    { zone: t("shipping.zones.remote.zone"), delivery: t("shipping.zones.remote.delivery"), cost: "৳150", freeAbove: "৳3000" },
  ];

  const eligibleItems = t.raw("policy.eligible.list") as string[];
  const nonEligibleItems = t.raw("policy.notEligible.list") as string[];
  
  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
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
              <ArrowLeft className="h-4 w-4" /> {tCommon("backToHome")}
            </Link>
            <div className="flex items-center gap-3 mb-4">
              <div className="p-3 bg-primary rounded-xl text-white">
                <RefreshCcw className="w-6 h-6" />
              </div>
              <div>
                <h1 className="text-2xl sm:text-3xl font-bold text-foreground">{t("title")}</h1>
                <p className="text-muted-foreground">{t("subtitle")}</p>
              </div>
            </div>
        </div>

        {/* Return Policy Section */}
        <section className="mb-12">
          <div className="flex items-center gap-3 mb-6">
            <div className="h-8 w-1 bg-gradient-to-b from-amber-400 to-rose-400 rounded-full" />
            <h2 className="text-xl font-bold text-foreground">{t("policy.title")}</h2>
          </div>

          <Card className="bg-card/80 backdrop-blur mb-6">
            <CardContent className="p-6">
              <div className="bg-gradient-to-r from-amber-50 to-rose-50 rounded-xl p-6 mb-6">
                <p className="text-2xl font-bold text-foreground mb-2">{t("policy.banner.title")}</p>
                <p className="text-muted-foreground">
                  {t("policy.banner.desc")}
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
                      <CheckCircle className="w-5 h-5 text-green-500" /> {t("policy.eligible.title")}
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
                      <RefreshCcw className="w-5 h-5 text-red-500" /> {t("policy.notEligible.title")}
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
            <h2 className="text-xl font-bold text-foreground">{t("shipping.title")}</h2>
          </div>

          <Card className="bg-card/80 backdrop-blur">
            <CardContent className="p-6">
              {/* Free Shipping Banner */}
              <div className="bg-gradient-to-r from-green-500 to-emerald-500 text-white rounded-xl p-6 mb-6">
                <div className="flex items-center gap-3">
                  <Truck className="w-8 h-8" />
                  <div>
                    <p className="text-xl font-bold">{t("shipping.banner.title")}</p>
                    <p className="text-white/80">{t("shipping.banner.desc")}</p>
                  </div>
                </div>
              </div>

              {/* Shipping Zones Table */}
              <div className="overflow-x-auto">
                <table className="w-full">
                  <thead>
                    <tr className="border-b">
                      <th className="text-left py-3 px-4 font-semibold text-foreground">
                        <MapPin className="w-4 h-4 inline mr-2" />{t("shipping.table.zone")}
                      </th>
                      <th className="text-left py-3 px-4 font-semibold text-foreground">
                        <Clock className="w-4 h-4 inline mr-2" />{t("shipping.table.time")}
                      </th>
                      <th className="text-left py-3 px-4 font-semibold text-foreground">
                        <CreditCard className="w-4 h-4 inline mr-2" />{t("shipping.table.cost")}
                      </th>
                      <th className="text-left py-3 px-4 font-semibold text-foreground">{t("shipping.table.freeAbove")}</th>
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
                <p className="text-sm text-amber-800" dangerouslySetInnerHTML={{ __html: t("shipping.note") }} />
              </div>
            </CardContent>
          </Card>
        </section>

        {/* CTA */}
        <div className="text-center">
          <p className="text-muted-foreground mb-4">{t("cta.text")}</p>
          <div className="flex justify-center gap-4">
            <Link href="/faq">
              <Button variant="outline">{t("cta.faq")}</Button>
            </Link>
            <Link href="/contact">
              <Button className="bg-primary text-white">
                {t("cta.contact")}
              </Button>
            </Link>
          </div>
        </div>
      </div>
    </div>
  );
}
