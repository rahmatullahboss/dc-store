"use client";

import { useState, Suspense } from "react";
import { useSearchParams, useRouter } from "next/navigation";
import Link from "next/link";
import Image from "next/image";
import { Search, SlidersHorizontal, X, Star, ChevronDown, ShoppingCart, Grid3X3, List } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Checkbox } from "@/components/ui/checkbox";
import { Slider } from "@/components/ui/slider";
import { useCart } from "@/lib/cart-context";
import type { Product } from "@/db/schema";

// Demo products for search
const allProducts: Product[] = [
  {
    id: "1", name: "Premium Wireless Headphones Pro Max", slug: "premium-wireless-headphones",
    description: "Crystal-clear audio", shortDescription: "Crystal-clear audio, 40hr battery",
    price: 4999, compareAtPrice: 7999, costPrice: 2500, sku: "WH-001", barcode: null,
    quantity: 50, lowStockThreshold: 5, trackQuantity: true, categoryId: "Electronics",
    images: [], featuredImage: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
    isActive: true, isFeatured: true, weight: 0.3, weightUnit: "kg", metaTitle: null, metaDescription: null,
    createdAt: new Date(), updatedAt: new Date(),
  },
  {
    id: "2", name: "Smart Watch Series X Ultra", slug: "smart-watch-series-x",
    description: "Stay connected", shortDescription: "Health tracking, GPS, 7-day battery",
    price: 12999, compareAtPrice: 15999, costPrice: 8000, sku: "SW-001", barcode: null,
    quantity: 30, lowStockThreshold: 5, trackQuantity: true, categoryId: "Electronics",
    images: [], featuredImage: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop",
    isActive: true, isFeatured: true, weight: 0.1, weightUnit: "kg", metaTitle: null, metaDescription: null,
    createdAt: new Date(), updatedAt: new Date(),
  },
  {
    id: "3", name: "Designer Leather Bag Premium", slug: "designer-leather-bag",
    description: "Elegant leather bag", shortDescription: "Genuine leather, spacious design",
    price: 8499, compareAtPrice: null, costPrice: 4000, sku: "LB-001", barcode: null,
    quantity: 20, lowStockThreshold: 5, trackQuantity: true, categoryId: "Fashion",
    images: [], featuredImage: "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&h=400&fit=crop",
    isActive: true, isFeatured: false, weight: 0.8, weightUnit: "kg", metaTitle: null, metaDescription: null,
    createdAt: new Date(), updatedAt: new Date(),
  },
  {
    id: "4", name: "Running Sneakers Pro Max", slug: "running-sneakers-pro",
    description: "Performance shoes", shortDescription: "Lightweight, maximum comfort",
    price: 6999, compareAtPrice: 9999, costPrice: 3500, sku: "RS-001", barcode: null,
    quantity: 45, lowStockThreshold: 5, trackQuantity: true, categoryId: "Sports",
    images: [], featuredImage: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop",
    isActive: true, isFeatured: false, weight: 0.5, weightUnit: "kg", metaTitle: null, metaDescription: null,
    createdAt: new Date(), updatedAt: new Date(),
  },
  {
    id: "5", name: "Wireless Bluetooth Speaker", slug: "wireless-bluetooth-speaker",
    description: "Premium sound", shortDescription: "360° sound, waterproof",
    price: 3499, compareAtPrice: 4999, costPrice: 1800, sku: "BS-001", barcode: null,
    quantity: 40, lowStockThreshold: 5, trackQuantity: true, categoryId: "Electronics",
    images: [], featuredImage: "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&h=400&fit=crop",
    isActive: true, isFeatured: false, weight: 0.4, weightUnit: "kg", metaTitle: null, metaDescription: null,
    createdAt: new Date(), updatedAt: new Date(),
  },
];

const categories = ["Electronics", "Fashion", "Sports", "Home"];

function SearchContent() {
  const searchParams = useSearchParams();
  const router = useRouter();
  const { addItem } = useCart();
  
  const initialQuery = searchParams.get("q") || "";
  const [query, setQuery] = useState(initialQuery);
  const [showFilters, setShowFilters] = useState(false);
  const [priceRange, setPriceRange] = useState([0, 20000]);
  const [selectedCategories, setSelectedCategories] = useState<string[]>([]);
  const [sortBy, setSortBy] = useState("relevance");

  // Filter products
  let filteredProducts = allProducts.filter((p) =>
    p.name.toLowerCase().includes(query.toLowerCase()) ||
    p.description?.toLowerCase().includes(query.toLowerCase())
  );

  // Apply category filter
  if (selectedCategories.length > 0) {
    filteredProducts = filteredProducts.filter((p) =>
      selectedCategories.includes(p.categoryId || "")
    );
  }

  // Apply price filter
  filteredProducts = filteredProducts.filter(
    (p) => p.price >= priceRange[0] && p.price <= priceRange[1]
  );

  // Apply sorting
  if (sortBy === "price-low") {
    filteredProducts.sort((a, b) => a.price - b.price);
  } else if (sortBy === "price-high") {
    filteredProducts.sort((a, b) => b.price - a.price);
  }

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    router.push(`/search?q=${encodeURIComponent(query)}`);
  };

  const handleAddToCart = (product: Product) => {
    addItem({
      productId: product.id,
      name: product.name,
      price: product.price,
      quantity: 1,
      image: product.featuredImage || undefined,
    });
  };

  const toggleCategory = (category: string) => {
    setSelectedCategories((prev) =>
      prev.includes(category)
        ? prev.filter((c) => c !== category)
        : [...prev, category]
    );
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-amber-50 via-white to-rose-50">
      <div className="pointer-events-none fixed inset-0 overflow-hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Search Bar */}
        <form onSubmit={handleSearch} className="mb-8">
          <div className="relative max-w-2xl mx-auto">
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" />
            <Input
              placeholder="Search for products..."
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              className="pl-12 pr-24 py-6 text-lg rounded-xl bg-white shadow-lg border-0"
            />
            <Button
              type="submit"
              className="absolute right-2 top-1/2 -translate-y-1/2 bg-gradient-to-r from-amber-500 to-rose-500 text-white"
            >
              Search
            </Button>
          </div>
        </form>

        <div className="flex gap-8">
          {/* Filters Sidebar - Desktop */}
          <aside className="hidden lg:block w-64 flex-shrink-0">
            <Card className="bg-white/80 backdrop-blur sticky top-24">
              <CardContent className="p-6">
                <h3 className="font-bold text-gray-800 mb-4 flex items-center gap-2">
                  <SlidersHorizontal className="w-4 h-4" /> Filters
                </h3>

                {/* Price Range */}
                <div className="mb-6">
                  <h4 className="text-sm font-medium text-gray-700 mb-3">Price Range</h4>
                  <Slider
                    value={priceRange}
                    onValueChange={setPriceRange}
                    max={20000}
                    step={500}
                    className="mb-2"
                  />
                  <div className="flex justify-between text-sm text-gray-500">
                    <span>৳{priceRange[0]}</span>
                    <span>৳{priceRange[1]}</span>
                  </div>
                </div>

                {/* Categories */}
                <div className="mb-6">
                  <h4 className="text-sm font-medium text-gray-700 mb-3">Categories</h4>
                  <div className="space-y-2">
                    {categories.map((category) => (
                      <label key={category} className="flex items-center gap-2 cursor-pointer">
                        <Checkbox
                          checked={selectedCategories.includes(category)}
                          onCheckedChange={() => toggleCategory(category)}
                        />
                        <span className="text-sm text-gray-600">{category}</span>
                      </label>
                    ))}
                  </div>
                </div>

                {/* Clear Filters */}
                {(selectedCategories.length > 0 || priceRange[0] > 0 || priceRange[1] < 20000) && (
                  <Button
                    variant="outline"
                    size="sm"
                    className="w-full"
                    onClick={() => {
                      setSelectedCategories([]);
                      setPriceRange([0, 20000]);
                    }}
                  >
                    Clear Filters
                  </Button>
                )}
              </CardContent>
            </Card>
          </aside>

          {/* Main Content */}
          <div className="flex-1">
            {/* Results Header */}
            <div className="flex items-center justify-between mb-6">
              <p className="text-gray-600">
                {filteredProducts.length} result{filteredProducts.length !== 1 ? "s" : ""}
                {query && <span> for &quot;{query}&quot;</span>}
              </p>
              <div className="flex items-center gap-3">
                <select
                  value={sortBy}
                  onChange={(e) => setSortBy(e.target.value)}
                  className="text-sm border rounded-lg px-3 py-2 bg-white"
                >
                  <option value="relevance">Relevance</option>
                  <option value="price-low">Price: Low to High</option>
                  <option value="price-high">Price: High to Low</option>
                </select>
                <Button
                  variant="outline"
                  size="sm"
                  className="lg:hidden"
                  onClick={() => setShowFilters(!showFilters)}
                >
                  <SlidersHorizontal className="w-4 h-4 mr-2" /> Filters
                </Button>
              </div>
            </div>

            {/* Products Grid */}
            {filteredProducts.length > 0 ? (
              <div className="grid grid-cols-2 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                {filteredProducts.map((product) => {
                  const discount = product.compareAtPrice
                    ? Math.round(((product.compareAtPrice - product.price) / product.compareAtPrice) * 100)
                    : 0;
                  return (
                    <Card key={product.id} className="group overflow-hidden bg-white/80 backdrop-blur hover:shadow-xl transition-all">
                      <Link href={`/products/${product.slug}`}>
                        <div className="relative aspect-square overflow-hidden">
                          {product.featuredImage ? (
                            <Image
                              src={product.featuredImage}
                              alt={product.name}
                              fill
                              className="object-cover group-hover:scale-105 transition-transform duration-500"
                            />
                          ) : (
                            <div className="w-full h-full bg-gray-100" />
                          )}
                          {discount > 0 && (
                            <Badge className="absolute top-2 left-2 bg-red-500 text-white border-0">
                              -{discount}%
                            </Badge>
                          )}
                        </div>
                      </Link>
                      <CardContent className="p-3">
                        <Link href={`/products/${product.slug}`}>
                          <h3 className="font-semibold text-gray-800 line-clamp-2 hover:text-amber-600 transition-colors text-sm">
                            {product.name}
                          </h3>
                        </Link>
                        <div className="mt-2 flex items-baseline gap-2">
                          <span className="font-bold text-gray-800">৳{product.price.toLocaleString()}</span>
                          {product.compareAtPrice && (
                            <span className="text-sm text-gray-400 line-through">
                              ৳{product.compareAtPrice.toLocaleString()}
                            </span>
                          )}
                        </div>
                        <Button
                          size="sm"
                          className="w-full mt-3 bg-gradient-to-r from-amber-500 to-rose-500 text-white gap-1"
                          onClick={() => handleAddToCart(product)}
                        >
                          <ShoppingCart className="w-4 h-4" /> Add to Cart
                        </Button>
                      </CardContent>
                    </Card>
                  );
                })}
              </div>
            ) : (
              <div className="text-center py-16">
                <Search className="w-16 h-16 text-gray-300 mx-auto mb-4" />
                <h3 className="text-xl font-bold text-gray-800 mb-2">No products found</h3>
                <p className="text-gray-500 mb-6">Try adjusting your search or filters</p>
                <Link href="/products">
                  <Button className="bg-gradient-to-r from-amber-500 to-rose-500 text-white">
                    Browse All Products
                  </Button>
                </Link>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

export default function SearchPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-gradient-to-br from-amber-50 via-white to-rose-50" />}>
      <SearchContent />
    </Suspense>
  );
}
