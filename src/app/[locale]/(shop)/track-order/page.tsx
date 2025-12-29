import { getTranslations } from "next-intl/server";
import { Metadata } from "next";
import TrackOrderClient from "./client";

type Props = {
  params: Promise<{ locale: string }>;
};

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const resolvedParams = await params;
  const t = await getTranslations({ locale: resolvedParams.locale, namespace: "TrackOrder" });
  return {
    title: t("meta.title"),
    description: t("meta.description"),
  };
}

export default function TrackOrderPage() {
  return <TrackOrderClient />;
}
