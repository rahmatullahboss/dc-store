// Products Listing Page
import { Search, Grid3X3, List, SlidersHorizontal } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { ProductCard } from "@/components/product/product-card";
import type { Product } from "@/db/schema";

// Demo products for display
const allProducts: Product[] = [
  {
    id: "1",
    name: "Premium Wireless Headphones Pro Max",
    slug: "premium-wireless-headphones",
    description: "Experience crystal-clear audio with our premium wireless headphones.",
    shortDescription: "Crystal-clear audio, 40hr battery",
    price: 4999,
    compareAtPrice: 7999,
    costPrice: 2500,
    sku: "WH-001",
    barcode: null,
    quantity: 50,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "Electronics",
    images: [],
    featuredImage: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: true,
    weight: 0.3,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "2",
    name: "Smart Watch Series X Ultra",
    slug: "smart-watch-series-x",
    description: "Stay connected with our premium smartwatch.",
    shortDescription: "Health tracking, GPS, 7-day battery",
    price: 12999,
    compareAtPrice: 15999,
    costPrice: 8000,
    sku: "SW-001",
    barcode: null,
    quantity: 30,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "Electronics",
    images: [],
    featuredImage: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: true,
    weight: 0.1,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "3",
    name: "Designer Leather Bag Premium",
    slug: "designer-leather-bag",
    description: "Elegant leather bag for the modern professional.",
    shortDescription: "Genuine leather, spacious design",
    price: 8499,
    compareAtPrice: null,
    costPrice: 4000,
    sku: "LB-001",
    barcode: null,
    quantity: 20,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "Fashion",
    images: [],
    featuredImage: "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: false,
    weight: 0.8,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "4",
    name: "Running Sneakers Pro Max",
    slug: "running-sneakers-pro",
    description: "Performance running shoes for athletes.",
    shortDescription: "Lightweight, maximum comfort",
    price: 6999,
    compareAtPrice: 9999,
    costPrice: 3500,
    sku: "RS-001",
    barcode: null,
    quantity: 45,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "Sports",
    images: [],
    featuredImage: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: false,
    weight: 0.5,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "5",
    name: "Vintage Camera Collection",
    slug: "vintage-camera-collection",
    description: "Classic vintage camera for photography enthusiasts.",
    shortDescription: "Retro design, modern features",
    price: 15999,
    compareAtPrice: 19999,
    costPrice: 10000,
    sku: "VC-001",
    barcode: null,
    quantity: 15,
    lowStockThreshold: 3,
    trackQuantity: true,
    categoryId: "Electronics",
    images: [],
    featuredImage: "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: true,
    weight: 0.6,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "6",
    name: "Minimalist Desk Lamp",
    slug: "minimalist-desk-lamp",
    description: "Modern LED desk lamp with adjustable brightness.",
    shortDescription: "Touch control, USB charging",
    price: 2499,
    compareAtPrice: 3499,
    costPrice: 1200,
    sku: "DL-001",
    barcode: null,
    quantity: 60,
    lowStockThreshold: 10,
    trackQuantity: true,
    categoryId: "Home",
    images: [],
    featuredImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: false,
    weight: 0.4,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "7",
    name: "Wireless Bluetooth Speaker",
    slug: "wireless-bluetooth-speaker",
    description: "Portable speaker with premium sound quality.",
    shortDescription: "360° sound, waterproof",
    price: 3499,
    compareAtPrice: 4999,
    costPrice: 1800,
    sku: "BS-001",
    barcode: null,
    quantity: 40,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "Electronics",
    images: [],
    featuredImage: "https://images.unsplash.com/photo-1608043152269-423dbba4e7e1?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: false,
    weight: 0.4,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
  {
    id: "8",
    name: "Gaming Mechanical Keyboard",
    slug: "gaming-mechanical-keyboard",
    description: "RGB mechanical keyboard for gamers.",
    shortDescription: "Cherry MX switches, RGB backlit",
    price: 5999,
    compareAtPrice: 7499,
    costPrice: 3000,
    sku: "GK-001",
    barcode: null,
    quantity: 25,
    lowStockThreshold: 5,
    trackQuantity: true,
    categoryId: "Electronics",
    images: [],
    featuredImage: "https://images.unsplash.com/photo-1541140532154-b024d705b90a?w=400&h=400&fit=crop",
    isActive: true,
    isFeatured: true,
    weight: 0.8,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

const categories = ["All", "Electronics", "Fashion", "Sports", "Home"];

export const metadata = {
  title: "All Products",
  description: "Browse our collection of premium products",
};

export default function ProductsPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-stone-100">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl md:text-4xl font-bold text-gray-800 mb-2">
            All Products
          </h1>
          <p className="text-gray-600">
            Discover our curated collection of premium products
          </p>
        </div>

        {/* Search & Filters Bar */}
        <div className="bg-white rounded-2xl p-4 shadow-lg border border-gray-100 mb-8">
          <div className="flex flex-col md:flex-row gap-4">
            {/* Search */}
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-5 w-5 text-gray-400" />
              <Input
                placeholder="Search products..."
                className="pl-10 bg-gray-50 border-0"
              />
            </div>

            {/* Category Filters */}
            <div className="flex items-center gap-2 overflow-x-auto pb-2 md:pb-0">
              {categories.map((category) => (
                <Badge
                  key={category}
                  variant={category === "All" ? "default" : "outline"}
                  className={`cursor-pointer whitespace-nowrap px-4 py-2 ${
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
              Showing {allProducts.length} products
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
        <div className="grid grid-cols-2 gap-2 sm:gap-6 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
          {allProducts.map((product, index) => (
            <ProductCard key={product.id} product={product} index={index} />
          ))}
        </div>

        {/* Pagination */}
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
