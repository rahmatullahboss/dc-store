import { Link } from "@/i18n/routing";
import { FileText, ArrowLeft } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { siteConfig } from "@/lib/config";

// Make this page fully static - no ISR, no KV writes
import { useTranslations } from "next-intl";
import { getTranslations } from "next-intl/server";

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Legal.Terms" });
  
  return {
    title: `${t("meta.title")} | ${siteConfig.name}`,
    description: t("meta.description", { name: siteConfig.name }),
  };
}

export default function TermsPage() {
  const t = useTranslations("Legal.Terms");
  
  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
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
            <ArrowLeft className="h-4 w-4" /> {t("backToHome")}
          </Link>
          <div className="flex items-center gap-3 mb-4">
            <div className="p-2 bg-primary rounded-lg text-white">
              <FileText className="w-5 h-5" />
            </div>
            <h1 className="text-2xl sm:text-3xl font-bold text-foreground">{t("title")}</h1>
          </div>
          <p className="text-muted-foreground">{t("lastUpdated")}</p>
        </div>

        <Card className="bg-card/80 backdrop-blur">
          <CardContent className="p-6 sm:p-10 prose prose-gray max-w-none">
            {/* Sections 1-10 */}
            {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((num) => (
              <div key={num} className="mb-8 last:mb-0">
                <h2>{t(`sections.${num}.title`)}</h2>
                {t.has(`sections.${num}.content`) && (
                  <p>{t(`sections.${num}.content`, { name: siteConfig.name })}</p>
                )}
                {t.has(`sections.${num}.list`) && (
                  <ul>
                    {t.raw(`sections.${num}.list`).map((item: string, i: number) => (
                      <li key={i} dangerouslySetInnerHTML={{ __html: item.replace("{name}", siteConfig.name) }} />
                    ))}
                  </ul>
                )}
              </div>
            ))}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
