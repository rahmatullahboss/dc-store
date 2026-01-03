import { Link } from "@/i18n/routing";
import {
  LayoutGrid,
  Shirt,
  Watch,
  Laptop,
  ShoppingBag,
  Sparkles,
} from "lucide-react";

import { getTranslations } from "next-intl/server";

export async function CategoryChips() {
  const t = await getTranslations("HomePage.Categories");

  const categories = [
    { name: t("all"), icon: LayoutGrid, href: "/products", active: true },
    { name: t("fashion"), icon: Shirt, href: "/products?category=fashion" },
    { name: t("watches"), icon: Watch, href: "/products?category=watches" },
    { name: t("electronics"), icon: Laptop, href: "/products?category=electronics" },
    { name: t("accessories"), icon: ShoppingBag, href: "/products?category=accessories" },
    { name: t("new"), icon: Sparkles, href: "/products?sort=newest" },
  ];

  return (
    <section className="relative z-10 max-w-7xl mx-auto px-4 lg:px-10 py-4">
      <div className="flex gap-3 overflow-x-auto hide-scrollbar pb-2">
        {categories.map((category) => (
          <Link
            key={category.href}
            href={category.href}
            className={`flex h-10 shrink-0 items-center justify-center gap-2 rounded-full px-5 sm:px-6 font-medium text-sm transition-all ${
              category.active
                ? "bg-foreground text-background hover:opacity-90"
                : "bg-card border border-border text-foreground hover:border-primary hover:text-primary"
            }`}
          >
            <category.icon className="h-4 w-4" />
            {category.name}
          </Link>
        ))}
      </div>
    </section>
  );
}
