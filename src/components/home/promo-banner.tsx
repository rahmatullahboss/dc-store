"use client";

import { Link } from "@/i18n/routing";
import { ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";

import { useTranslations } from "next-intl";

export function PromoBanner() {
  const t = useTranslations("HomePage.Promo");

  return (
    <section className="relative z-10 max-w-7xl mx-auto px-4 lg:px-10 py-8">
      <div className="relative overflow-hidden rounded-2xl bg-primary">
        {/* Background Image - Always full size */}
        <div
          className="absolute inset-0 bg-cover bg-center z-0"
          style={{
            backgroundImage: `url("https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=2670&auto=format&fit=crop")`,
          }}
        />
        {/* Overlay gradient for readability */}
        <div className="absolute inset-0 bg-gradient-to-r from-primary via-primary/95 to-primary/40 lg:to-transparent z-10" />

        {/* Content */}
        <div className="relative z-20 min-h-[400px] lg:min-h-[500px] flex items-center">
          <div className="p-8 lg:p-16 max-w-lg">
            <span className="text-primary-foreground font-bold text-sm sm:text-lg mb-4 tracking-widest uppercase block">
              {t('limitedOffer')}
            </span>
            <h2 className="text-primary-foreground text-4xl sm:text-5xl lg:text-6xl xl:text-7xl font-black leading-[0.9] mb-4 sm:mb-6">
              {t('special')}
              <br />
              <span className="text-background">{t('deals')}</span>
            </h2>
            <p className="text-primary-foreground/90 text-base sm:text-xl font-medium mb-6 sm:mb-8 max-w-sm">
              {t('description')}
            </p>
            <Button
              asChild
              className="w-fit bg-background text-foreground px-6 sm:px-8 py-3 sm:py-4 h-auto rounded-lg font-bold text-base sm:text-lg hover:bg-background/90 transition-colors"
            >
              <Link href="/offers" className="flex items-center gap-2">
                {t('shopSale')}
                <ArrowRight className="h-5 w-5" />
              </Link>
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
}
