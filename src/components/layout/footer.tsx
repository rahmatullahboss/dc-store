import { Link } from "@/i18n/routing";
import {
  Facebook,
  Instagram,
  Twitter,
  Mail,
  Phone,
  MapPin,
} from "lucide-react";
import { siteConfig } from "@/lib/config";

import { useTranslations } from "next-intl";

export function Footer() {
  const t = useTranslations("Footer");
  const tCommon = useTranslations("Common");

  const footerLinks = {
    shop: [
      { name: t("shopLinks.allProducts"), href: "/products" },
      { name: t("shopLinks.newArrivals"), href: "/products?sort=newest" },
      { name: t("shopLinks.bestSellers"), href: "/products?sort=popular" },
      { name: t("shopLinks.sale"), href: "/products?sale=true" },
    ],
    support: [
      { name: t("supportLinks.contactUs"), href: "/contact" },
      { name: t("supportLinks.faqs"), href: "/faq" },
      { name: t("supportLinks.returns"), href: "/returns" },
      { name: t("supportLinks.trackOrder"), href: "/track-order" },
    ],
    company: [
      { name: t("companyLinks.aboutUs"), href: "/about" },
      { name: t("companyLinks.privacy"), href: "/privacy" },
      { name: t("companyLinks.terms"), href: "/terms" },
    ],
  };

  return (
    <footer className="relative z-10 border-t bg-muted/30">
      <div className="container mx-auto px-4 py-12">
        <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-4">
          {/* Brand */}
          <div className="space-y-4 text-center md:text-left">
            <Link href="/" className="text-xl font-bold inline-flex items-center gap-2">
              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img src="https://res.cloudinary.com/dpnccgsja/image/upload/f_auto,q_auto,w_64/dc-store/logo" alt="DC Store" className="h-8 w-8 object-contain" />
              {siteConfig.name}
            </Link>
            <p className="text-sm text-muted-foreground">
              {siteConfig.description}
            </p>
            <div className="flex gap-4 justify-center md:justify-start">
              <Link
                href={siteConfig.social.facebook}
                className="text-muted-foreground hover:text-primary transition-colors"
                target="_blank"
              >
                <Facebook className="h-5 w-5" />
              </Link>
              <Link
                href={siteConfig.social.instagram}
                className="text-muted-foreground hover:text-primary transition-colors"
                target="_blank"
              >
                <Instagram className="h-5 w-5" />
              </Link>
              <Link
                href={siteConfig.social.twitter}
                className="text-muted-foreground hover:text-primary transition-colors"
                target="_blank"
              >
                <Twitter className="h-5 w-5" />
              </Link>
            </div>
          </div>

          {/* Shop Links */}
          <div className="text-center md:text-left">
            <h3 className="font-semibold mb-4">{t('shop')}</h3>
            <ul className="space-y-2">
              {footerLinks.shop.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-muted-foreground hover:text-primary transition-colors"
                  >
                    {link.name}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Support Links */}
          <div className="text-center md:text-left">
            <h3 className="font-semibold mb-4">{t('support')}</h3>
            <ul className="space-y-2">
              {footerLinks.support.map((link) => (
                <li key={link.href}>
                  <Link
                    href={link.href}
                    className="text-sm text-muted-foreground hover:text-primary transition-colors"
                  >
                    {link.name}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Contact Info */}
          <div className="text-center md:text-left">
            <h3 className="font-semibold mb-4">{t('contact')}</h3>
            <ul className="space-y-3">
              <li className="flex items-center justify-center md:justify-start gap-2 text-sm text-muted-foreground">
                <Mail className="h-4 w-4" />
                <a
                  href={`mailto:${siteConfig.email}`}
                  className="hover:text-primary"
                >
                  {siteConfig.email}
                </a>
              </li>
              <li className="flex items-center justify-center md:justify-start gap-2 text-sm text-muted-foreground">
                <Phone className="h-4 w-4" />
                <a
                  href={`tel:${siteConfig.phone}`}
                  className="hover:text-primary"
                >
                  {siteConfig.phone}
                </a>
              </li>
              <li className="flex items-start justify-center md:justify-start gap-2 text-sm text-muted-foreground">
                <MapPin className="h-4 w-4 mt-0.5" />
                <span>{siteConfig.address}</span>
              </li>
            </ul>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="mt-12 pt-8 border-t">
          <div className="flex flex-col md:flex-row justify-between items-center gap-4">
            <p className="text-sm text-muted-foreground">
              {tCommon('copyright', { year: new Date().getFullYear(), name: siteConfig.name })}
            </p>
            <div className="flex gap-6">
              {footerLinks.company.map((link) => (
                <Link
                  key={link.href}
                  href={link.href}
                  className="text-sm text-muted-foreground hover:text-primary transition-colors"
                >
                  {link.name}
                </Link>
              ))}
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
}
