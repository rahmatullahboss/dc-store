import { getTranslations } from "next-intl/server";
import { ContactView } from "@/components/contact/contact-view";
import { siteConfig } from "@/lib/config";

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
