"use client";

import Image from "next/image";
import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/routing";
import { ArrowRight } from "lucide-react";
import { useTranslations } from "next-intl";

export function HeroSection() {
  const t = useTranslations("HomePage.Hero");

  return (
    <section className="relative z-10 w-full max-w-7xl mx-auto px-4 lg:px-10 py-6 lg:py-8">
      <div className="relative overflow-hidden rounded-2xl min-h-[450px] sm:min-h-[550px] lg:min-h-[650px] flex items-center">
        {/* LCP Hero Image - prioritized for fast loading */}
        <Image
          src="https://images.unsplash.com/photo-1556906781-9a412961c28c?q=80&w=1200&auto=format&fit=crop"
          alt="Premium quality products showcase"
          fill
          priority
          fetchPriority="high"
          sizes="100vw"
          className="object-cover object-center"
        />
        {/* Gradient Overlay */}
        <div 
          className="absolute inset-0 w-full h-full"
          style={{
            background: 'linear-gradient(105deg, rgba(0,0,0,0.85) 0%, rgba(0,0,0,0.5) 50%, rgba(0,0,0,0) 100%)',
          }}
        />

        {/* Content Overlay */}
        <div className="relative z-10 w-full lg:w-2/3 px-6 lg:pl-16 flex flex-col items-start gap-4 sm:gap-6">
          {/* Badge */}
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-primary/20 border border-primary/30 text-primary text-xs sm:text-sm font-bold tracking-wide uppercase">
            <span className="size-2 rounded-full bg-primary animate-pulse" />
            {t('newCollection')}
          </div>

          {/* Title */}
          <h1 className="text-white text-4xl sm:text-6xl lg:text-7xl xl:text-8xl font-bold leading-[0.95] tracking-tighter">
            {t('premium')}
            <br />
            <span className="text-primary">{t('quality')}</span>
            <br />
            {t('products')}
          </h1>

          {/* Description */}
          <p className="text-gray-300 text-base sm:text-lg lg:text-xl max-w-md leading-relaxed">
            {t('description')}
          </p>

          {/* CTA Buttons */}
          <div className="flex flex-wrap gap-3 sm:gap-4 mt-2 sm:mt-4">
            <Button
              asChild
              className="h-11 sm:h-12 px-6 sm:px-8 rounded-full bg-primary text-black font-bold hover:bg-card hover:scale-105 transition-all duration-200 shadow-[0_0_20px_rgba(244,140,37,0.4)]"
            >
              <Link href="/products">
                {t('shopNow')}
                <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </Button>
            <Button
              asChild
              variant="outline"
              className="h-11 sm:h-12 px-6 sm:px-8 rounded-full bg-card/10 backdrop-blur-md border-white/20 text-white font-bold hover:bg-card/20 transition-all"
            >
              <Link href="/categories">{t('browseCategories')}</Link>
            </Button>
          </div>
        </div>

        {/* Floating Product Card - Hidden on mobile */}
        <div className="absolute bottom-6 sm:bottom-10 right-6 sm:right-10 hidden lg:flex gap-4">
          <div className="w-64 p-4 rounded-xl bg-black/40 backdrop-blur-xl border border-white/10 flex items-center gap-4">
            <div
              className="size-16 rounded-lg bg-cover bg-center shrink-0"
              style={{
                backgroundImage: `url("https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=150&h=150&fit=crop")`,
              }}
            />
            <div className="flex-1 min-w-0">
              <p className="text-white text-sm font-bold truncate">
                {t('featuredItem')}
              </p>
              <p className="text-primary text-xs font-bold">{t('bestSeller')}</p>
            </div>
            <Button
              size="icon"
              className="size-8 rounded-full bg-card text-black hover:bg-primary"
              asChild
            >
              <Link href="/products">
                <ArrowRight className="h-4 w-4" />
              </Link>
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
}
