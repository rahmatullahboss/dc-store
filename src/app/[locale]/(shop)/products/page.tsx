// Products Listing Page
import { Search, Grid3X3, List, SlidersHorizontal, ShoppingBag, Sparkles, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { ProductCard } from "@/components/product/product-card";
import { getProducts, getProductCategories } from "@/lib/queries";
import { getCategoryBySlug } from "@/lib/queries/categories";
import { getTranslations } from "next-intl/server";
import { Link } from "@/i18n/routing";

// ISR: Cache for 3600 seconds (1 hour), on-demand revalidation via admin actions
// Note: Only works with manual deploy (wrangler deploy), not Git integration
export const revalidate = 3600;

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "ProductsPage.meta" });

  return {
    title: t("title"),
    description: t("description"),
  };
}

interface ProductsPageProps {
  params: Promise<{ locale: string }>;
  searchParams: Promise<{ search?: string; category?: string }>;
}

export default async function ProductsPage({ params, searchParams }: ProductsPageProps) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "ProductsPage" });
  
  const searchParamsValue = await searchParams;
  const searchQuery = searchParamsValue.search?.toLowerCase() || "";
  const categorySlug = searchParamsValue.category || "";

  // If a category is selected, get its ID first
  let targetCategoryId = "";
  if (categorySlug && categorySlug !== "All") {
    const category = await getCategoryBySlug(categorySlug);
    if (category) {
      targetCategoryId = category.id;
    }
  }

  // Fetch products and categories from database
  const [allProducts, categoryIds] = await Promise.all([
    getProducts(),
    getProductCategories(),
  ]);

  // Filter products based on search query
  const filteredProducts = allProducts.filter((product) => {
    const matchesSearch = !searchQuery || 
      product.name.toLowerCase().includes(searchQuery) ||
      (product.description && product.description.toLowerCase().includes(searchQuery));
    
    const matchesCategory = !categorySlug || categorySlug === "All" || 
      product.categoryId === targetCategoryId;
      
    return matchesSearch && matchesCategory;
  });

  // Create category list with "All" option
  const categories = [{ id: "All", name: t("filters.all") }, ...categoryIds];

  return (
    <div className="min-h-screen bg-background">
      {/* Animated Background */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0">
        <div className="absolute -top-40 -right-40 h-96 w-96 rounded-full bg-primary/15 blur-3xl animate-pulse" />
        <div className="absolute top-1/2 -left-32 h-80 w-80 rounded-full bg-primary/10 blur-3xl animate-pulse animation-delay-2000" />
        <div className="absolute -bottom-32 right-1/4 h-72 w-72 rounded-full bg-primary/15 blur-3xl animate-pulse animation-delay-4000" />
      </div>

      <div className="relative z-10 container mx-auto px-3 sm:px-4 py-6 sm:py-10">
        {/* Header - Mobile Optimized */}
        <div className="text-center mb-6 sm:mb-10">
          <div className="inline-flex items-center gap-1.5 sm:gap-2 px-3 sm:px-4 py-1.5 sm:py-2 rounded-full bg-primary/10 text-primary text-xs sm:text-sm font-medium mb-3 sm:mb-4">
            <Sparkles className="w-3.5 h-3.5 sm:w-4 sm:h-4" />
            <span>{t("title")}</span>
          </div>
          <h1 className="text-2xl sm:text-3xl lg:text-4xl font-bold text-foreground mb-2 sm:mb-3 tracking-tight">
            {searchQuery 
              ? t("search.title", { query: searchQuery }) 
              : t("title")}
          </h1>
          <p className="text-sm sm:text-base text-muted-foreground max-w-2xl mx-auto px-2">
            {searchQuery 
              ? t("search.found", { count: filteredProducts.length })
              : t("search.defaultDesc")
            }
          </p>
        </div>

        {/* Premium Search Bar - Mobile Responsive */}
        <div className="max-w-3xl mx-auto mb-6 sm:mb-8">
          <form action="/products" method="GET" className="relative group">
            {/* Glow Effect - Hidden on mobile for performance */}
            <div className="hidden sm:block absolute -inset-1 bg-primary/20 rounded-xl sm:rounded-2xl blur-lg opacity-0 group-hover:opacity-60 group-focus-within:opacity-100 transition-opacity duration-500" />
            
            {/* Search Input Container */}
            <div className="relative flex items-center bg-card/90 backdrop-blur-xl rounded-xl sm:rounded-2xl border border-border/50 shadow-lg overflow-hidden group-hover:border-primary/30 group-focus-within:border-primary/50 transition-all duration-300">
              {/* Search Icon */}
              <div className="flex items-center justify-center w-11 h-11 sm:w-14 sm:h-14">
                <Search className="w-4 h-4 sm:w-5 sm:h-5 text-muted-foreground group-focus-within:text-primary transition-colors" />
              </div>
              
              {/* Input */}
              <input
                type="text"
                name="search"
                placeholder={t("search.placeholder")}
                defaultValue={searchParamsValue.search || ""}
                className="flex-1 h-11 sm:h-14 bg-transparent text-foreground text-sm sm:text-base placeholder:text-muted-foreground/70 focus:outline-none pr-2"
              />
              
              {/* Clear Button */}
              {searchQuery && (
                <Link href="/products" className="p-1.5 sm:p-2 rounded-full hover:bg-muted transition-colors">
                  <X className="w-4 h-4 sm:w-5 sm:h-5 text-muted-foreground" />
                </Link>
              )}
              
              {/* Search Button */}
              <button
                type="submit"
                className="m-1.5 sm:m-2 px-4 sm:px-6 h-8 sm:h-10 bg-primary hover:bg-primary/90 text-primary-foreground text-sm font-semibold rounded-lg sm:rounded-xl shadow-md shadow-primary/25 hover:shadow-lg hover:scale-105 transition-all duration-300"
              >
                {t("search.button")}
              </button>
            </div>
          </form>
        </div>

        {/* Category Pills - Horizontal Scroll on Mobile */}
        <div className="mb-6 sm:mb-8 -mx-3 sm:mx-0">
          <div className="flex items-center gap-2 overflow-x-auto px-3 sm:px-0 pb-2 sm:pb-0 sm:flex-wrap sm:justify-center hide-scrollbar">
            {categories.map((category) => {
              const isActive = category.id === "All" 
                ? !categorySlug 
                : categorySlug === category.id;
              return (
                <Link
                  key={category.id}
                  href={category.id === "All" ? "/products" : `/products?category=${category.id}`}
                >
                  <Badge
                    variant={isActive ? "default" : "outline"}
                    className={`cursor-pointer whitespace-nowrap px-3 sm:px-5 py-1.5 sm:py-2 text-xs sm:text-sm font-medium rounded-full transition-all duration-300 shrink-0 ${
                      isActive
                        ? "bg-primary text-primary-foreground border-0 shadow-md shadow-primary/25"
                        : "bg-card/80 backdrop-blur-sm border-border/50 hover:border-primary/50 hover:bg-primary/10 hover:text-primary"
                    }`}
                  >
                    {category.name}
                  </Badge>
                </Link>
              );
            })}
          </div>
        </div>

        {/* Filters Bar - Mobile Responsive */}
        <div className="flex flex-wrap items-center justify-between gap-2 sm:gap-4 mb-6 sm:mb-8">
          <span className="text-xs sm:text-sm text-muted-foreground">
            {t("filters.showing", { count: filteredProducts.length })}
          </span>
          
          <div className="flex items-center gap-2">
            {/* View Toggle - Desktop only */}
            <div className="hidden md:flex items-center gap-1 p-1 bg-card/60 backdrop-blur-sm rounded-lg border border-border/50">
              <Button variant="ghost" size="icon" className="h-8 w-8 rounded-md bg-primary/10 text-primary">
                <Grid3X3 className="h-4 w-4" />
              </Button>
              <Button variant="ghost" size="icon" className="h-8 w-8 rounded-md hover:bg-muted">
                <List className="h-4 w-4" />
              </Button>
            </div>
            
            {/* Sort Dropdown - Compact on mobile */}
            <select className="text-xs sm:text-sm border border-border/50 rounded-lg sm:rounded-xl px-2 sm:px-4 py-2 bg-card/80 backdrop-blur-sm text-foreground focus:outline-none focus:border-primary/50 transition-colors cursor-pointer">
              <option>{t("filters.sort.bestSelling")}</option>
              <option>{t("filters.sort.priceLowHigh")}</option>
              <option>{t("filters.sort.priceHighLow")}</option>
              <option>{t("filters.sort.newest")}</option>
            </select>
            
            {/* Filter Button - Mobile version */}
            <Button variant="outline" size="icon" className="md:hidden h-9 w-9 rounded-lg border-border/50 bg-card/80">
              <SlidersHorizontal className="h-4 w-4" />
            </Button>
            
            {/* Filter Button - Desktop */}
            <Button variant="outline" className="hidden md:flex gap-2 rounded-xl border-border/50 bg-card/60 backdrop-blur-sm hover:border-primary/50 hover:bg-primary/10">
              <SlidersHorizontal className="h-4 w-4" />
              <span>{t("filters.title")}</span>
            </Button>
          </div>
        </div>

        {/* Products Grid */}
        {filteredProducts.length > 0 ? (
          <div className="grid grid-cols-2 gap-2.5 sm:gap-4 md:gap-6 md:grid-cols-3 lg:grid-cols-4">
            {filteredProducts.map((product, index) => (
              <ProductCard key={product.id} product={product} index={index} />
            ))}
          </div>
        ) : (
          <div className="text-center py-12 sm:py-20">
            <div className="relative inline-block">
              <div className="absolute inset-0 bg-primary/20 rounded-full blur-2xl animate-pulse" />
              <div className="relative w-16 h-16 sm:w-20 sm:h-20 mx-auto bg-primary/10 rounded-full flex items-center justify-center mb-4 sm:mb-6 backdrop-blur-sm border border-primary/20">
                <ShoppingBag className="w-8 h-8 sm:w-10 sm:h-10 text-primary" />
              </div>
            </div>
            <h2 className="text-xl sm:text-2xl font-bold text-foreground mb-2 sm:mb-3">
              {t("empty.title")}
            </h2>
            <p className="text-sm sm:text-base text-muted-foreground max-w-md mx-auto px-4">
              {t("empty.desc")}
            </p>
          </div>
        )}

        {/* Pagination - Mobile Responsive */}
        {filteredProducts.length > 0 && (
          <div className="flex items-center justify-center gap-1.5 sm:gap-2 mt-8 sm:mt-12">
            <Button variant="outline" disabled className="rounded-lg sm:rounded-xl text-xs sm:text-sm h-8 sm:h-10 px-2 sm:px-4">
              {t("pagination.previous")}
            </Button>
            <Button className="bg-primary text-primary-foreground border-0 rounded-lg sm:rounded-xl h-8 sm:h-10 w-8 sm:w-10 text-xs sm:text-sm shadow-md shadow-primary/25">
              1
            </Button>
            <Button variant="outline" className="rounded-lg sm:rounded-xl h-8 sm:h-10 w-8 sm:w-10 text-xs sm:text-sm">2</Button>
            <Button variant="outline" className="rounded-lg sm:rounded-xl h-8 sm:h-10 w-8 sm:w-10 text-xs sm:text-sm">3</Button>
            <span className="px-1 sm:px-2 text-muted-foreground text-xs sm:text-sm">...</span>
            <Button variant="outline" className="rounded-lg sm:rounded-xl h-8 sm:h-10 w-8 sm:w-10 text-xs sm:text-sm">10</Button>
            <Button variant="outline" className="rounded-lg sm:rounded-xl text-xs sm:text-sm h-8 sm:h-10 px-2 sm:px-4">
              {t("pagination.next")}
            </Button>
          </div>
        )}

        {/* Newsletter Section */}
        <div className="mt-10 sm:mt-16 relative overflow-hidden rounded-2xl sm:rounded-3xl">
          <div className="absolute inset-0 bg-primary" />
          <div className="absolute inset-0 bg-[url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI2MCIgaGVpZ2h0PSI2MCI+CjxwYXRoIGQ9Ik0wIDBoNjB2NjBIMHoiIGZpbGw9Im5vbmUiLz4KPHBhdGggZD0iTTMwIDMwbTAgLTI1YTI1IDI1IDAgMSAxIDAgNTBhMjUgMjUgMCAxIDEgMCAtNTAiIGZpbGw9Im5vbmUiIHN0cm9rZT0icmdiYSgyNTUsMjU1LDI1NSwwLjEpIiBzdHJva2Utd2lkdGg9IjEiLz4KPC9zdmc+')] opacity-30" />
          
          <div className="relative p-6 sm:p-8 md:p-12 text-center">
            <h2 className="text-xl sm:text-2xl md:text-3xl font-bold mb-3 sm:mb-4 text-primary-foreground">
              {t("newsletter.title")}
            </h2>
            <p className="text-primary-foreground/80 text-sm sm:text-base mb-5 sm:mb-8 max-w-xl mx-auto">
              {t("newsletter.desc")}
            </p>
            <div className="flex flex-col sm:flex-row gap-2 sm:gap-3 max-w-md mx-auto">
              <input
                type="email"
                placeholder={t("newsletter.placeholder")}
                className="flex-1 h-10 sm:h-12 px-4 sm:px-5 bg-background/20 backdrop-blur-sm border border-background/30 rounded-lg sm:rounded-xl text-primary-foreground text-sm placeholder:text-primary-foreground/70 focus:outline-none focus:border-background/50 transition-colors"
              />
              <button className="h-10 sm:h-12 px-6 sm:px-8 bg-background text-foreground font-semibold rounded-lg sm:rounded-xl text-sm shadow-lg hover:shadow-xl hover:scale-105 transition-all duration-300">
                {t("newsletter.subscribe")}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
