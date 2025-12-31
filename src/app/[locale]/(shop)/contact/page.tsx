import { getTranslations } from "next-intl/server";
import { ContactView } from "@/components/contact/contact-view";
import { siteConfig } from "@/lib/config";

// ISR: Revalidate every hour
export const revalidate = 3600;

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Contact" });

  return {
    title: `${t("title")} - ${siteConfig.name}`,
    description: t("subtitle"),
  };
}

export default function ContactPage() {
  return <ContactView />;
}
