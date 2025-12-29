import { Link } from "@/i18n/routing";
import Image from "next/image";
import { ArrowRight, ShoppingBag, Package, Sparkles, TrendingUp } from "lucide-react";
import { siteConfig } from "@/lib/config";
import { getCategories } from "@/lib/queries";
import { getTranslations } from "next-intl/server";

// Force dynamic rendering for Cloudflare context
export const dynamic = "force-dynamic";

export async function generateMetadata({params}: {params: Promise<{locale: string}>}) {
  const { locale } = await params;
  const t = await getTranslations({locale, namespace: "Categories"});
  return {
    title: `${t('metaTitle')} | ${siteConfig.name}`,
    description: t('metaDescription'),
  };
}

export default async function CategoriesPage({params}: {params: Promise<{locale: string}>}) {
  const { locale } = await params;
  const t = await getTranslations({locale, namespace: "Categories"});
  
  // Fetch categories from database
  const allCategories = await getCategories();

  // Split into featured (highest product counts) and other categories
  const sortedCategories = [...allCategories].sort((a, b) => b.productCount - a.productCount);
  const featuredCategories = sortedCategories.slice(0, 3);
  const otherCategories = sortedCategories.slice(3);

  return (
    <div className="min-h-screen bg-background">
      {/* Animated Background */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0">
        <div className="absolute -top-40 -right-40 h-96 w-96 rounded-full bg-primary/15 blur-3xl animate-pulse" />
        <div className="absolute top-1/2 -left-32 h-80 w-80 rounded-full bg-primary/10 blur-3xl animate-pulse animation-delay-2000" />
        <div className="absolute -bottom-32 right-1/4 h-72 w-72 rounded-full bg-primary/15 blur-3xl animate-pulse animation-delay-4000" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8 sm:py-12">
        {/* Hero Header */}
        <div className="text-center mb-12 sm:mb-16">
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-primary/10 text-primary text-sm font-medium mb-6">
            <Sparkles className="w-4 h-4" />
            <span>{t('badge')}</span>
          </div>
          <h1 className="text-4xl sm:text-5xl lg:text-6xl font-bold text-foreground mb-4 tracking-tight">
            {t('title')}
          </h1>
          <p className="text-lg text-muted-foreground max-w-2xl mx-auto">
            {t('subtitle')}
          </p>
        </div>

        {allCategories.length === 0 ? (
          /* Empty State */
          <div className="text-center py-20">
            <div className="relative inline-block">
              <div className="absolute inset-0 bg-primary/20 rounded-full blur-2xl animate-pulse" />
              <div className="relative w-24 h-24 mx-auto bg-primary/10 rounded-full flex items-center justify-center mb-8 backdrop-blur-sm border border-primary/20">
                <Package className="w-12 h-12 text-primary" />
              </div>
            </div>
            <h2 className="text-2xl sm:text-3xl font-bold text-foreground mb-4">
              {t('empty.title')}
            </h2>
            <p className="text-muted-foreground mb-8 max-w-md mx-auto">
              {t('empty.desc')}
            </p>
            <Link href="/products">
              <button className="group inline-flex items-center gap-2 px-8 py-4 bg-primary hover:bg-primary/90 text-primary-foreground font-semibold rounded-full shadow-lg shadow-primary/25 hover:shadow-xl hover:shadow-primary/30 hover:scale-105 transition-all duration-300">
                {t('viewAll')}
                <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
              </button>
            </Link>
          </div>
        ) : (
          <>
            {/* Featured Categories - Premium Cards */}
            {featuredCategories.length > 0 && (
              <section className="mb-16">
                <div className="flex items-center gap-3 mb-8">
                  <div className="flex items-center gap-2 px-4 py-2 rounded-full bg-primary/10 border border-primary/20">
                    <TrendingUp className="w-5 h-5 text-primary" />
                    <h2 className="text-xl font-bold text-foreground">{t('featured')}</h2>
                  </div>
                </div>

                <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6 lg:gap-8">
                  {featuredCategories.map((category, index) => (
                    <Link key={category.id} href={`/products?category=${category.slug}`}>
                      <div 
                        className="group relative overflow-hidden rounded-3xl bg-card/60 backdrop-blur-xl border border-border/50 hover:border-primary/30 shadow-lg hover:shadow-2xl hover:shadow-primary/10 transition-all duration-500 h-full"
                        style={{ animationDelay: `${index * 100}ms` }}
                      >
                        {/* Image Container */}
                        <div className="relative h-56 sm:h-64 overflow-hidden">
                          {category.image ? (
                            <Image
                              src={category.image}
                              alt={category.name}
                              fill
                              className="object-cover transition-all duration-700 group-hover:scale-110 group-hover:rotate-1"
                            />
                          ) : (
                            <div className="w-full h-full bg-primary/10 flex items-center justify-center">
                              <div className="relative">
                                <div className="absolute inset-0 bg-primary/20 rounded-full blur-xl animate-pulse" />
                                <ShoppingBag className="relative w-16 h-16 text-primary/60" />
                              </div>
                            </div>
                          )}
                          
                          {/* Gradient Overlay */}
                          <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent" />
                          
                          {/* Shine Effect */}
                          <div className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500">
                            <div className="absolute inset-0 translate-x-[-100%] group-hover:translate-x-[100%] bg-gradient-to-r from-transparent via-white/20 to-transparent transition-transform duration-1000" />
                          </div>
                          
                          {/* Badge */}
                          <div className="absolute top-4 right-4">
                            <div className="px-3 py-1.5 rounded-full bg-white/90 dark:bg-black/60 backdrop-blur-md text-xs font-bold text-primary shadow-lg">
                              {t('products', {count: category.productCount})}
                            </div>
                          </div>

                          {/* Content on Image */}
                          <div className="absolute bottom-0 left-0 right-0 p-6">
                            <h3 className="text-2xl font-bold text-white mb-2 group-hover:text-primary transition-colors duration-300">
                              {category.name}
                            </h3>
                            <p className="text-sm text-white/80 line-clamp-2">
                              {category.description}
                            </p>
                          </div>
                        </div>
                        
                        {/* Footer */}
                        <div className="p-5 bg-card/80 backdrop-blur-sm">
                          <div className="flex items-center justify-between">
                            <span className="text-sm font-medium text-muted-foreground group-hover:text-primary transition-colors">
                              {t('browse')}
                            </span>
                            <div className="flex items-center justify-center w-10 h-10 rounded-full bg-primary/10 group-hover:bg-primary transition-all duration-300">
                              <ArrowRight className="w-5 h-5 text-primary group-hover:text-primary-foreground group-hover:translate-x-0.5 transition-all" />
                            </div>
                          </div>
                        </div>

                        {/* Hover Glow */}
                        <div className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500 pointer-events-none">
                          <div className="absolute -inset-px bg-primary/10 rounded-3xl" />
                        </div>
                      </div>
                    </Link>
                  ))}
                </div>
              </section>
            )}

            {/* Other Categories - Grid Cards */}
            {otherCategories.length > 0 && (
              <section className="mb-12">
                <div className="flex items-center gap-3 mb-8">
                  <div className="flex items-center gap-2 px-4 py-2 rounded-full bg-secondary border border-border">
                    <Sparkles className="w-5 h-5 text-muted-foreground" />
                    <h2 className="text-xl font-bold text-foreground">{t('more')}</h2>
                  </div>
                </div>

                <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4 sm:gap-6">
                  {otherCategories.map((category, index) => (
                    <Link key={category.id} href={`/products?category=${category.slug}`}>
                      <div 
                        className="group relative overflow-hidden rounded-2xl bg-card/60 backdrop-blur-xl border border-border/50 hover:border-primary/30 shadow-md hover:shadow-xl hover:shadow-primary/10 transition-all duration-500 hover:-translate-y-1"
                        style={{ animationDelay: `${index * 50}ms` }}
                      >
                        {/* Image */}
                        <div className="relative h-36 sm:h-44 overflow-hidden">
                          {category.image ? (
                            <Image
                              src={category.image}
                              alt={category.name}
                              fill
                              className="object-cover transition-all duration-500 group-hover:scale-110"
                            />
                          ) : (
                            <div className="w-full h-full bg-primary/5 flex items-center justify-center">
                              <ShoppingBag className="w-10 h-10 text-primary/40" />
                            </div>
                          )}
                          
                          {/* Overlay */}
                          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
                          
                          {/* Content */}
                          <div className="absolute bottom-0 left-0 right-0 p-4">
                            <h3 className="font-bold text-white text-base sm:text-lg group-hover:text-primary transition-colors">
                              {category.name}
                            </h3>
                            <div className="flex items-center gap-1.5 mt-1">
                              <span className="text-xs text-white/70 font-medium">
                                {t('items', {count: category.productCount})}
                              </span>
                              <ArrowRight className="w-3.5 h-3.5 text-primary opacity-0 group-hover:opacity-100 group-hover:translate-x-0.5 transition-all" />
                            </div>
                          </div>
                        </div>
                      </div>
                    </Link>
                  ))}
                </div>
              </section>
            )}

            {/* CTA Section */}
            <div className="mt-16 text-center">
              <div className="inline-block relative">
                <div className="absolute -inset-4 bg-primary/20 rounded-full blur-2xl opacity-60" />
                <Link href="/products">
                  <button className="relative group inline-flex items-center gap-3 px-10 py-4 bg-primary hover:bg-primary/90 text-primary-foreground font-bold rounded-full shadow-xl shadow-primary/30 hover:shadow-2xl hover:shadow-primary/40 hover:scale-105 transition-all duration-300">
                    <ShoppingBag className="w-5 h-5" />
                    {t('viewAll')}
                    <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
                  </button>
                </Link>
              </div>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
