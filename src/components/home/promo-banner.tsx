"use client";

import Link from "next/link";
import { ArrowRight } from "lucide-react";
import { Button } from "@/components/ui/button";

export function PromoBanner() {
  return (
    <section className="max-w-7xl mx-auto px-4 lg:px-10 py-8">
      <div className="relative overflow-hidden rounded-2xl bg-primary">
        <div className="grid grid-cols-1 lg:grid-cols-12 min-h-[400px] lg:min-h-[500px]">
          {/* Text Content */}
          <div className="lg:col-span-5 p-8 lg:p-16 flex flex-col justify-center relative z-20">
            <span className="text-black font-bold text-sm sm:text-lg mb-4 tracking-widest uppercase">
              Limited Offer
            </span>
            <h2 className="text-black text-4xl sm:text-5xl lg:text-6xl xl:text-7xl font-black leading-[0.9] mb-4 sm:mb-6">
              SPECIAL
              <br />
              <span className="text-white">DEALS</span>
            </h2>
            <p className="text-black/80 text-base sm:text-xl font-medium mb-6 sm:mb-8 max-w-sm">
              Get amazing discounts on our premium collection. Limited time
              offers you can&apos;t miss.
            </p>
            <Button
              asChild
              className="w-fit bg-black text-white px-6 sm:px-8 py-3 sm:py-4 h-auto rounded-lg font-bold text-base sm:text-lg hover:bg-gray-900 transition-colors"
            >
              <Link href="/offers" className="flex items-center gap-2">
                Shop Sale
                <ArrowRight className="h-5 w-5" />
              </Link>
            </Button>
          </div>

          {/* Image Side */}
          <div className="lg:col-span-7 relative min-h-[200px] lg:min-h-full">
            <div
              className="absolute inset-0 bg-cover bg-center"
              style={{
                backgroundImage: `url("https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=2670&auto=format&fit=crop")`,
              }}
            />
            {/* Gradient blend */}
            <div className="absolute inset-0 bg-gradient-to-t from-primary/90 to-transparent lg:bg-gradient-to-r lg:from-primary lg:via-transparent lg:to-transparent" />
          </div>
        </div>
      </div>
    </section>
  );
}
