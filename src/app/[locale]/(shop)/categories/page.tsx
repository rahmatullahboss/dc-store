import Link from "next/link";
import Image from "next/image";
import { ArrowRight, ShoppingBag, Package } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
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
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Header */}
        <div className="text-center mb-12">
          <div className="w-16 h-16 mx-auto bg-primary rounded-full flex items-center justify-center mb-4">
            <ShoppingBag className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-3xl sm:text-4xl font-bold text-foreground mb-3">{t('title')}</h1>
          <p className="text-muted-foreground max-w-lg mx-auto">
            {t('subtitle')}
          </p>
        </div>

        {allCategories.length === 0 ? (
          /* Empty State */
          <div className="text-center py-16">
            <div className="w-20 h-20 mx-auto bg-gradient-to-r from-amber-100 to-rose-100 rounded-full flex items-center justify-center mb-6">
              <Package className="w-10 h-10 text-primary" />
            </div>
            <h2 className="text-2xl font-bold text-foreground mb-3">
              {t('empty.title')}
            </h2>
            <p className="text-muted-foreground mb-8 max-w-md mx-auto">
              {t('empty.desc')}
            </p>
            <Link href="/products">
              <button className="inline-flex items-center gap-2 px-8 py-3 bg-primary text-white font-medium rounded-full hover:from-amber-600 hover:to-rose-600 transition-all">
                {t('viewAll')}
                <ArrowRight className="w-4 h-4" />
              </button>
            </Link>
          </div>
        ) : (
          <>
            {/* Featured Categories */}
            {featuredCategories.length > 0 && (
              <section className="mb-12">
                <div className="flex items-center gap-3 mb-6">
                  <div className="h-8 w-1 bg-gradient-to-b from-amber-400 to-rose-400 rounded-full" />
                  <h2 className="text-2xl font-bold text-foreground">{t('featured')}</h2>
                </div>

                <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
                  {featuredCategories.map((category) => (
                    <Link key={category.id} href={`/products?category=${category.slug}`}>
                      <Card className="group overflow-hidden bg-card/80 backdrop-blur hover:shadow-xl transition-all duration-300 h-full">
                        <div className="relative h-48 overflow-hidden">
                          {category.image ? (
                            <Image
                              src={category.image}
                              alt={category.name}
                              fill
                              className="object-cover transition-transform duration-500 group-hover:scale-110"
                            />
                          ) : (
                            <div className="w-full h-full bg-gradient-to-br from-amber-100 to-rose-100 flex items-center justify-center">
                              <ShoppingBag className="w-12 h-12 text-amber-400" />
                            </div>
                          )}
                          <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-black/20 to-transparent" />
                          <Badge className="absolute top-4 right-4 bg-primary text-white border-0">
                            {t('products', {count: category.productCount})}
                          </Badge>
                          <div className="absolute bottom-4 left-4 right-4 text-white">
                            <h3 className="text-xl font-bold mb-1">{category.name}</h3>
                            <p className="text-sm text-white/80">{category.description}</p>
                          </div>
                        </div>
                        <CardContent className="p-4">
                          <div className="flex items-center justify-between">
                            <span className="text-sm text-muted-foreground">{t('browse')}</span>
                            <ArrowRight className="w-4 h-4 text-primary group-hover:translate-x-1 transition-transform" />
                          </div>
                        </CardContent>
                      </Card>
                    </Link>
                  ))}
                </div>
              </section>
            )}

            {/* Other Categories */}
            {otherCategories.length > 0 && (
              <section>
                <div className="flex items-center gap-3 mb-6">
                  <div className="h-8 w-1 bg-gradient-to-b from-blue-400 to-purple-400 rounded-full" />
                  <h2 className="text-2xl font-bold text-foreground">{t('more')}</h2>
                </div>

                <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 gap-4">
                  {otherCategories.map((category) => (
                    <Link key={category.id} href={`/products?category=${category.slug}`}>
                      <Card className="group overflow-hidden bg-card/80 backdrop-blur hover:shadow-lg transition-all duration-300 h-full">
                        <div className="relative h-32 overflow-hidden">
                          {category.image ? (
                            <Image
                              src={category.image}
                              alt={category.name}
                              fill
                              className="object-cover transition-transform duration-500 group-hover:scale-110"
                            />
                          ) : (
                            <div className="w-full h-full bg-gradient-to-br from-blue-100 to-purple-100 flex items-center justify-center">
                              <ShoppingBag className="w-8 h-8 text-blue-400" />
                            </div>
                          )}
                          <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent" />
                          <div className="absolute bottom-3 left-3 right-3 text-white">
                            <h3 className="font-bold text-sm">{category.name}</h3>
                            <p className="text-xs text-white/70">{t('items', {count: category.productCount})}</p>
                          </div>
                        </div>
                      </Card>
                    </Link>
                  ))}
                </div>
              </section>
            )}

            {/* CTA */}
            <div className="mt-12 text-center">
              <Link href="/products">
                <button className="inline-flex items-center gap-2 px-8 py-3 bg-primary text-white font-medium rounded-full hover:from-amber-600 hover:to-rose-600 transition-all">
                  {t('viewAll')}
                  <ArrowRight className="w-4 h-4" />
                </button>
              </Link>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
