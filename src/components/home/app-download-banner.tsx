"use client";

import { Button } from "@/components/ui/button";
import { Smartphone, Apple, Download, ChevronDown } from "lucide-react";
import { useState } from "react";
import { useTranslations } from "next-intl";

// GitHub Releases download URLs
const ANDROID_APK_URL = "https://github.com/rahmatullahboss/dc-store/releases/download/v1.0.0/dc-store-arm64.apk";
const ANDROID_LEGACY_APK_URL = "https://github.com/rahmatullahboss/dc-store/releases/download/v1.0.0/dc-store-armv7.apk";

export function AppDownloadBanner() {
  const [showAndroidOptions, setShowAndroidOptions] = useState(false);
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
          {/* Phone Icon */}
          <div className="flex-shrink-0 w-16 h-16 sm:w-20 sm:h-20 bg-primary/20 rounded-2xl flex items-center justify-center">
            <Smartphone className="w-8 h-8 sm:w-10 sm:h-10 text-primary" />
          </div>

          {/* Text Content */}
          <div className="flex-1 text-center sm:text-left">
            <h3 className="text-xl sm:text-2xl font-bold mb-2">
              {t("title")}
            </h3>
            <p className="text-muted-foreground text-sm sm:text-base">
              {t("description")}
            </p>
          </div>

          {/* Download Buttons */}
          <div className="flex flex-col sm:flex-row gap-3">
            {/* Android Download */}
            <div className="relative">
              <Button
                size="lg"
                className="bg-[#3DDC84] hover:bg-[#32c074] text-black font-semibold rounded-xl px-6 gap-2 w-full sm:w-auto"
                onClick={() => setShowAndroidOptions(!showAndroidOptions)}
              >
                <Download className="w-5 h-5" />
                {t("android")}
                <ChevronDown className={`w-4 h-4 transition-transform ${showAndroidOptions ? 'rotate-180' : ''}`} />
              </Button>
              
              {/* Android Dropdown */}
              {showAndroidOptions && (
                <div className="absolute top-full left-0 right-0 mt-2 bg-background border border-border rounded-xl shadow-lg overflow-hidden z-20">
                  <a
                    href={ANDROID_APK_URL}
                    download
                    className="flex items-center gap-2 px-4 py-3 hover:bg-muted transition-colors"
                  >
                    <Smartphone className="w-4 h-4" />
                    <div>
                      <div className="font-medium text-sm">{t("modernPhones")}</div>
                      <div className="text-xs text-muted-foreground">{t("recommended")}</div>
                    </div>
                  </a>
                  <a
                    href={ANDROID_LEGACY_APK_URL}
                    download
                    className="flex items-center gap-2 px-4 py-3 hover:bg-muted transition-colors border-t"
                  >
                    <Smartphone className="w-4 h-4" />
                    <div>
                      <div className="font-medium text-sm">{t("olderPhones")}</div>
                      <div className="text-xs text-muted-foreground">{t("legacy")}</div>
                    </div>
                  </a>
                </div>
              )}
            </div>

            {/* iOS - Coming Soon */}
            <Button
              size="lg"
              variant="outline"
              className="rounded-xl px-6 gap-2 opacity-60 cursor-not-allowed"
              disabled
            >
              <Apple className="w-5 h-5" />
              {t("ios")}
              <span className="text-xs bg-muted px-2 py-0.5 rounded-full">{t("comingSoon")}</span>
            </Button>
          </div>
        </div>
      </div>
    </section>
  );
}
