"use client";

import Link from "next/link";
import {
  Grid3X3,
  Shirt,
  Watch,
  Laptop,
  ShoppingBag,
  Sparkles,
} from "lucide-react";

const categories = [
  { name: "All", icon: Grid3X3, href: "/products", active: true },
  { name: "Fashion", icon: Shirt, href: "/products?category=fashion" },
  { name: "Watches", icon: Watch, href: "/products?category=watches" },
  { name: "Electronics", icon: Laptop, href: "/products?category=electronics" },
  { name: "Accessories", icon: ShoppingBag, href: "/products?category=accessories" },
  { name: "New", icon: Sparkles, href: "/products?sort=newest" },
];

export function CategoryChips() {
  return (
    <section className="max-w-7xl mx-auto px-4 lg:px-10 py-4">
      <div className="flex gap-3 overflow-x-auto hide-scrollbar pb-2">
        {categories.map((category) => (
          <Link
            key={category.name}
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
