"use client";

import { Button } from "@/components/ui/button";
import { Smartphone, Apple, Download } from "lucide-react";
import { useTranslations } from "next-intl";

// Vercel Blob Download URL (set after first CI run)
const ANDROID_APK_URL = process.env.NEXT_PUBLIC_APK_URL || "https://mz7q7adki8rkadux.public.blob.vercel-storage.com/dc-store-arm64.apk";

export function AppDownloadBanner() {
  const t = useTranslations("AppDownload");

  return (
    <section className="relative z-10 max-w-7xl mx-auto px-4 lg:px-10 py-6">
      <div className="relative overflow-hidden rounded-2xl bg-gradient-to-r from-primary/10 via-primary/5 to-background border border-primary/20">
        {/* Background Pattern */}
        <div className="absolute inset-0 opacity-5">
          <div className="absolute top-0 left-0 w-40 h-40 bg-primary rounded-full blur-3xl" />
          <div className="absolute bottom-0 right-0 w-40 h-40 bg-primary rounded-full blur-3xl" />
        </div>

        <div className="relative p-6 sm:p-8 flex flex-col sm:flex-row items-center gap-6">
          {/* App Icon */}
          <div className="flex-shrink-0 relative w-28 h-28 sm:w-36 sm:h-36 hover:scale-105 transition-transform duration-300">
             {/* eslint-disable-next-line @next/next/no-img-element */}
             <img 
               src="https://res.cloudinary.com/dpnccgsja/image/upload/f_auto,q_auto,w_288/dc-store/logo" 
               alt="DC Store App" 
               className="w-full h-full object-contain drop-shadow-2xl"
             />
          </div>

          {/* Text Content */}
          <div className="flex-1 text-center sm:text-left z-10">
            <h3 className="text-xl sm:text-3xl font-bold mb-3 bg-clip-text text-transparent bg-gradient-to-r from-primary to-primary/60">
              {t("title")}
            </h3>
            <p className="text-muted-foreground text-sm sm:text-base mb-0 max-w-lg">
              {t("description")}
            </p>
          </div>

          {/* Download Buttons */}
          <div className="flex flex-col gap-3 justify-center">
            <a
              href={ANDROID_APK_URL}
              // download="dc-store.apk" // Let browser handle filename from headers or URL
              className="group relative inline-flex items-center justify-center gap-2 px-6 py-2.5 font-semibold text-white transition-all duration-200 bg-[#3DDC84] hover:bg-[#32c074] rounded-xl shadow-lg hover:shadow-[#3DDC84]/30 hover:-translate-y-0.5"
            >
              <Smartphone className="w-5 h-5 transition-transform group-hover:rotate-12" />
              <span>{t("android")}</span>
              <Download className="w-4 h-4 ml-1 opacity-70" />
            </a>

            {/* iOS - Coming Soon */}
            <Button
              size="lg"
              variant="outline"
              className="rounded-xl px-6 gap-2 opacity-60 cursor-not-allowed hover:bg-transparent"
              disabled
            >
              <Apple className="w-5 h-5" />
              {t("ios")}
              <span className="text-xs bg-muted px-2 py-0.5 rounded-full border border-border">{t("comingSoon")}</span>
            </Button>
          </div>
          
        </div>
      </div>
    </section>
  );
}
