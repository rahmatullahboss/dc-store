// Products Listing Page
import { Search, Grid3X3, List, SlidersHorizontal, ShoppingBag } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { ProductCard } from "@/components/product/product-card";
import { getProducts, getProductCategories } from "@/lib/queries";

// Force dynamic rendering for Cloudflare context
export const dynamic = "force-dynamic";

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
  const categoryFilter = params.category || "";

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
    const matchesCategory = !categoryFilter || categoryFilter === "All" || 
      product.categoryId === categoryFilter;
    return matchesSearch && matchesCategory;
  });

  // Create category list with "All" option
  const categories = ["All", ...categoryIds];

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-stone-100">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl md:text-4xl font-bold text-gray-800 mb-2">
            {searchQuery ? `Search: "${params.search}"` : "All Products"}
          </h1>
          <p className="text-gray-600">
            {searchQuery 
              ? `Found ${filteredProducts.length} products matching your search`
              : "Discover our curated collection of premium products"
            }
          </p>
        </div>

        {/* Search & Filters Bar */}
        <div className="bg-white rounded-xl sm:rounded-2xl p-3 sm:p-4 shadow-lg border border-gray-100 mb-6 sm:mb-8">
          <div className="flex flex-col md:flex-row gap-3 sm:gap-4">
            {/* Search */}
            <form action="/products" method="GET" className="relative flex-1">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" />
              <Input
                name="search"
                placeholder="Search products..."
                defaultValue={params.search || ""}
                className="pl-10 bg-gray-50 border-0"
              />
            </form>

            {/* Category Filters */}
            <div className="flex items-center gap-1.5 sm:gap-2 overflow-x-auto pb-1 sm:pb-2 md:pb-0 scrollbar-hide">
              {categories.map((category) => (
                <Badge
                  key={category}
                  variant={category === "All" ? "default" : "outline"}
                  className={`cursor-pointer whitespace-nowrap px-2 sm:px-4 py-1 sm:py-2 text-xs sm:text-sm ${
                    category === "All"
                      ? "bg-gradient-to-r from-amber-500 to-rose-500 text-white border-0 hover:from-amber-600 hover:to-rose-600"
                      : "hover:bg-gray-100"
                  }`}
                >
                  {category}
                </Badge>
              ))}
            </div>

            {/* View Toggle & Filters */}
            <div className="flex items-center gap-2">
              <Button variant="outline" size="icon" className="hidden md:flex">
                <Grid3X3 className="h-4 w-4" />
              </Button>
              <Button variant="ghost" size="icon" className="hidden md:flex">
                <List className="h-4 w-4" />
              </Button>
              <Button variant="outline" className="gap-2">
                <SlidersHorizontal className="h-4 w-4" />
                <span className="hidden sm:inline">Filters</span>
              </Button>
            </div>
          </div>

          {/* Active Filters */}
          <div className="flex items-center gap-2 mt-4 pt-4 border-t">
            <span className="text-sm text-gray-500">
              Showing {filteredProducts.length} products
            </span>
            <div className="flex-1" />
            <select className="text-sm border rounded-lg px-3 py-2 bg-white">
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
            <div className="w-16 h-16 mx-auto bg-gradient-to-r from-amber-100 to-rose-100 rounded-full flex items-center justify-center mb-4">
              <ShoppingBag className="w-8 h-8 text-amber-600" />
            </div>
            <h2 className="text-xl font-bold text-gray-800 mb-2">
              No Products Yet
            </h2>
            <p className="text-gray-500">
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
            <Button className="bg-gradient-to-r from-amber-500 to-rose-500 text-white border-0">
              1
            </Button>
            <Button variant="outline">2</Button>
            <Button variant="outline">3</Button>
            <span className="px-2 text-gray-500">...</span>
            <Button variant="outline">10</Button>
            <Button variant="outline">
              Next
            </Button>
          </div>
        )}

        {/* Newsletter Section */}
        <div className="mt-16 bg-gradient-to-r from-amber-500 to-rose-500 rounded-3xl p-8 md:p-12 text-center text-white">
          <h2 className="text-2xl md:text-3xl font-bold mb-4">
            Get 10% Off Your First Order!
          </h2>
          <p className="text-white/90 mb-6 max-w-xl mx-auto">
            Subscribe to our newsletter and get exclusive offers, new arrivals, 
            and special discounts delivered to your inbox.
          </p>
          <div className="flex flex-col sm:flex-row gap-3 max-w-md mx-auto">
            <Input
              placeholder="Enter your email"
              className="bg-white/20 border-white/30 text-white placeholder:text-white/70 flex-1"
            />
            <Button className="bg-white text-amber-600 hover:bg-white/90 font-semibold">
              Subscribe
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
}
