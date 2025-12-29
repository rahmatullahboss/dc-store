// Products Listing Page
import { Search, Grid3X3, List, SlidersHorizontal, ShoppingBag } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { ProductCard } from "@/components/product/product-card";
import { getProducts, getProductCategories } from "@/lib/queries";
import { getCategoryBySlug } from "@/lib/queries/categories";

// ISR: Cache for 3600 seconds (1 hour), on-demand revalidation via admin actions
// Note: Only works with manual deploy (wrangler deploy), not Git integration
export const revalidate = 3600;

export const metadata = {
  title: "All Products",
  description: "Browse our collection of premium products",
};

interface ProductsPageProps {
  searchParams: Promise<{ search?: string; category?: string }>;
}

export default async function ProductsPage({ searchParams }: ProductsPageProps) {
  const params = await searchParams;
  const searchQuery = params.search?.toLowerCase() || "";
  const categorySlug = params.category || "";

  // If a category is selected, get its ID first
  let targetCategoryId = "";
  if (categorySlug && categorySlug !== "All") {
    const category = await getCategoryBySlug(categorySlug);
    if (category) {
      targetCategoryId = category.id;
    }
  }

  // Fetch products and categories from database
  // Pass categoryId to the query for better performance if filtering by category
  const [allProducts, categoryIds] = await Promise.all([
    getProducts(),
    getProductCategories(),
  ]);

  // Filter products based on search query
  const filteredProducts = allProducts.filter((product) => {
    const matchesSearch = !searchQuery || 
      product.name.toLowerCase().includes(searchQuery) ||
      (product.description && product.description.toLowerCase().includes(searchQuery));
    
    // Filter by category ID, not slug
    const matchesCategory = !categorySlug || categorySlug === "All" || 
      product.categoryId === targetCategoryId;
      
    return matchesSearch && matchesCategory;
  });

  // Create category list with "All" option
  const categories = [{ id: "All", name: "All" }, ...categoryIds];

  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl md:text-4xl font-bold text-foreground mb-2">
            {searchQuery ? `Search: "${params.search}"` : "All Products"}
          </h1>
          <p className="text-muted-foreground">
            {searchQuery 
              ? `Found ${filteredProducts.length} products matching your search`
              : "Discover our curated collection of premium products"
            }
          </p>
        </div>

        {/* Search & Filters Bar */}
        <div className="bg-card rounded-xl sm:rounded-2xl p-3 sm:p-4 shadow-lg border border-border mb-6 sm:mb-8">
          <div className="flex flex-col md:flex-row gap-3 sm:gap-4">
            {/* Search */}
            <form action="/products" method="GET" className="relative flex-1">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-muted-foreground" />
              <Input
                name="search"
                placeholder="Search products..."
                defaultValue={params.search || ""}
                className="pl-10 bg-muted border-0"
              />
            </form>

            {/* Category Filters */}
            <div className="flex items-center gap-1.5 sm:gap-2 overflow-x-auto pb-1 sm:pb-2 md:pb-0 scrollbar-hide">
              {categories.map((category) => {
                const isActive = category.id === "All" 
                  ? !categorySlug 
                  : categorySlug === category.id;
                return (
                  <Badge
                    key={category.id}
                    variant={isActive ? "default" : "outline"}
                    className={`cursor-pointer whitespace-nowrap px-2 sm:px-4 py-1 sm:py-2 text-xs sm:text-sm ${
                      isActive
                        ? "bg-primary text-primary-foreground border-0 hover:bg-primary/90"
                        : "hover:bg-muted"
                    }`}
                  >
                    {category.name}
                  </Badge>
                );
              })}
            </div>

            {/* View Toggle & Filters - Desktop only */}
            <div className="hidden md:flex items-center gap-2">
              <Button variant="outline" size="icon">
                <Grid3X3 className="h-4 w-4" />
              </Button>
              <Button variant="ghost" size="icon">
                <List className="h-4 w-4" />
              </Button>
              <Button variant="outline" className="gap-2">
                <SlidersHorizontal className="h-4 w-4" />
                <span>Filters</span>
              </Button>
            </div>
          </div>

          {/* Active Filters */}
          <div className="flex items-center gap-2 mt-4 pt-4 border-t border-border">
            <span className="text-sm text-muted-foreground">
              Showing {filteredProducts.length} products
            </span>
            <div className="flex-1" />
            <select className="text-sm border border-border rounded-lg px-3 py-2 bg-card text-foreground">
              <option>Best Selling</option>
              <option>Price: Low to High</option>
              <option>Price: High to Low</option>
              <option>Newest First</option>
            </select>
          </div>
        </div>

        {/* Products Grid */}
        {filteredProducts.length > 0 ? (
          <div className="grid grid-cols-2 gap-2 sm:gap-6 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
            {filteredProducts.map((product, index) => (
              <ProductCard key={product.id} product={product} index={index} />
            ))}
          </div>
        ) : (
          <div className="text-center py-16">
            <div className="w-16 h-16 mx-auto bg-primary/20 rounded-full flex items-center justify-center mb-4">
              <ShoppingBag className="w-8 h-8 text-primary" />
            </div>
            <h2 className="text-xl font-bold text-foreground mb-2">
              No Products Yet
            </h2>
            <p className="text-muted-foreground">
              Products will appear here once they&apos;re added to the store.
            </p>
          </div>
        )}

        {/* Pagination - only show if products exist */}
        {filteredProducts.length > 0 && (
          <div className="flex items-center justify-center gap-2 mt-12">
            <Button variant="outline" disabled>
              Previous
            </Button>
            <Button className="bg-primary text-primary-foreground border-0">
              1
            </Button>
            <Button variant="outline">2</Button>
            <Button variant="outline">3</Button>
            <span className="px-2 text-muted-foreground">...</span>
            <Button variant="outline">10</Button>
            <Button variant="outline">
              Next
            </Button>
          </div>
        )}

        {/* Newsletter Section */}
        <div className="mt-16 bg-primary rounded-3xl p-8 md:p-12 text-center">
          <h2 className="text-2xl md:text-3xl font-bold mb-4 text-primary-foreground">
            Get 10% Off Your First Order!
          </h2>
          <p className="text-primary-foreground/80 mb-6 max-w-xl mx-auto">
            Subscribe to our newsletter and get exclusive offers, new arrivals, 
            and special discounts delivered to your inbox.
          </p>
          <div className="flex flex-col sm:flex-row gap-3 max-w-md mx-auto">
            <Input
              placeholder="Enter your email"
              className="bg-background/20 border-background/30 text-primary-foreground placeholder:text-primary-foreground/70 flex-1"
            />
            <Button className="bg-background text-foreground hover:bg-background/90 font-semibold">
              Subscribe
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
