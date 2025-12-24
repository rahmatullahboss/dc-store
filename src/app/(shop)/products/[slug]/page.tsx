import Image from "next/image";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowLeft, ShoppingCart, Truck, ShieldCheck, Star, StarHalf } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { siteConfig } from "@/lib/config";
import type { Metadata } from "next";
import type { Product } from "@/db/schema";
import { ProductActions } from "./product-actions";

// Demo products (same as home page for now - will be from database)
const demoProducts: Product[] = [
  {
    id: "1",
    name: "Premium Wireless Headphones Pro Max",
    slug: "premium-wireless-headphones",
    description: `Experience crystal-clear audio with our premium wireless headphones.

Features:
• Active Noise Cancellation (ANC) technology
• 40 hours of battery life on a single charge
• Premium memory foam ear cushions
• Bluetooth 5.3 for stable connection
• Built-in microphone for calls
• Foldable design for easy storage

Perfect for music lovers, gamers, and professionals who demand the best audio quality. The headphones come with a premium carrying case and USB-C charging cable.`,
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
    images: [
      "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&h=800&fit=crop",
      "https://images.unsplash.com/photo-1583394838336-acd977736f90?w=800&h=800&fit=crop",
      "https://images.unsplash.com/photo-1487215078519-e21cc028cb29?w=800&h=800&fit=crop",
    ],
    featuredImage: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&h=800&fit=crop",
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
    description: `Stay connected with our premium smartwatch.

Features:
• Advanced health monitoring (Heart rate, SpO2, Sleep tracking)
• Built-in GPS for outdoor activities
• 7-day battery life
• Water resistant up to 50 meters
• 100+ workout modes
• Always-on Retina display

Stay on top of your fitness goals with detailed analytics and personalized insights. Compatible with both iOS and Android devices.`,
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
    featuredImage: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=800&h=800&fit=crop",
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
    description: `Elegant leather bag for the modern professional.

Features:
• 100% genuine leather
• Multiple compartments for organization
• Padded laptop sleeve (fits up to 15")
• Adjustable shoulder strap
• Premium metal hardware
• Water-resistant lining

Perfect for work, travel, or everyday use. Each bag is handcrafted with attention to detail.`,
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
    featuredImage: "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&h=800&fit=crop",
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
    description: `Performance running shoes for athletes.

Features:
• Lightweight mesh upper for breathability
• Advanced cushioning technology
• Durable rubber outsole
• Reflective elements for night running
• Available in multiple colors
• True-to-size fit

Engineered for speed and comfort. Whether you're training for a marathon or just staying active, these shoes deliver.`,
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
    featuredImage: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&h=800&fit=crop",
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
    description: `Classic vintage camera for photography enthusiasts.

Features:
• Retro design with modern internals
• 35mm film compatible
• Manual focus lens
• Built-in light meter
• Leather carrying strap included
• Collector's edition packaging

A perfect blend of nostalgia and functionality. Ideal for film photography enthusiasts and collectors.`,
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
    featuredImage: "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=800&h=800&fit=crop",
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
    description: `Modern LED desk lamp with adjustable brightness.

Features:
• Touch control for easy operation
• 5 brightness levels
• 3 color temperature modes
• USB charging port
• Flexible gooseneck design
• Energy-efficient LED technology

Perfect for home office, study, or bedside. The sleek design complements any modern interior.`,
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
    featuredImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=800&h=800&fit=crop",
    isActive: true,
    isFeatured: false,
    weight: 0.4,
    weightUnit: "kg",
    metaTitle: null,
    metaDescription: null,
    createdAt: new Date(),
    updatedAt: new Date(),
  },
];

// Demo reviews
const demoReviews = [
  {
    id: "1",
    userName: "Rahmat Ullah",
    rating: 5,
    title: "Excellent product!",
    content: "Amazing quality and fast delivery. Highly recommended!",
    createdAt: new Date("2024-12-20"),
    verified: true,
  },
  {
    id: "2",
    userName: "Tasnim K.",
    rating: 4,
    title: "Great value for money",
    content: "Good quality product. Packaging was also very nice.",
    createdAt: new Date("2024-12-15"),
    verified: true,
  },
  {
    id: "3",
    userName: "Sakib Hasan",
    rating: 5,
    title: "Love it!",
    content: "Exactly as described. Will buy again.",
    createdAt: new Date("2024-12-10"),
    verified: false,
  },
];

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const product = demoProducts.find((p) => p.slug === slug);

  if (!product) {
    return {
      title: "Product Not Found",
      description: "The requested product could not be found.",
    };
  }

  return {
    title: `${product.name} | ${siteConfig.name}`,
    description: product.shortDescription || product.description,
    openGraph: {
      title: product.name,
      description: product.shortDescription || product.description || "",
      images: product.featuredImage ? [product.featuredImage] : [],
      type: "website",
    },
  };
}

export const dynamic = "force-dynamic";

export default async function ProductDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  
  // Find product by slug (will be from database later)
  const product = demoProducts.find((p) => p.slug === slug);

  if (!product) {
    notFound();
  }

  const discountPercentage = product.compareAtPrice
    ? Math.round(
        ((product.compareAtPrice - product.price) / product.compareAtPrice) * 100
      )
    : 0;

  const averageRating = 4.5;
  const reviewCount = demoReviews.length;

  // Get related products (same category)
  const relatedProducts = demoProducts
    .filter((p) => p.categoryId === product.categoryId && p.id !== product.id)
    .slice(0, 4);

  const highlightCards = [
    {
      icon: Truck,
      title: "Fast Delivery",
      subtitle: "Delivery within 2-3 business days",
    },
    {
      icon: ShieldCheck,
      title: "Secure Payment",
      subtitle: "100% secure payment gateway",
    },
    {
      icon: ShoppingCart,
      title: "Easy Returns",
      subtitle: "7-day return policy",
    },
  ];

  return (
    <div className="relative min-h-screen bg-gradient-to-br from-amber-50 via-white to-rose-50 text-gray-900">
      {/* Background decorations */}
      <div className="pointer-events-none absolute inset-0 overflow-hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
        <div className="absolute top-1/3 left-1/2 h-64 w-64 -translate-x-1/2 rounded-full bg-blue-200/40 blur-3xl" />
      </div>

      <main className="relative z-10 pb-20 md:pb-0">
        <div className="container mx-auto px-3 py-6 sm:px-6 lg:py-16 lg:px-8">
          {/* Breadcrumb */}
          <div className="mb-6 flex items-center gap-3 text-sm text-gray-500">
            <Link
              href="/products"
              className="inline-flex items-center gap-1 rounded-full bg-white/80 px-4 py-2 shadow-sm ring-1 ring-amber-200 transition hover:text-amber-600 hover:ring-amber-300"
            >
              <ArrowLeft className="h-4 w-4" />
              Back to Products
            </Link>
            {product.categoryId && (
              <span className="inline-flex items-center gap-2 rounded-full bg-gradient-to-r from-amber-100 to-rose-100 px-4 py-2 text-xs font-semibold uppercase tracking-[0.2em] text-amber-700">
                {product.categoryId}
              </span>
            )}
          </div>

          {/* Main Content Grid */}
          <div className="grid gap-6 lg:gap-12 lg:grid-cols-[1.1fr_0.9fr]">
            {/* Left: Product Images */}
            <div className="space-y-6">
              {/* Main Image */}
              <div className="group relative overflow-hidden rounded-2xl sm:rounded-[2.75rem] border border-white/60 bg-white shadow-xl shadow-amber-100/80">
                <div className="relative aspect-square">
                  {product.featuredImage ? (
                    <Image
                      src={product.featuredImage}
                      alt={product.name}
                      fill
                      className="object-cover transition duration-700 ease-out group-hover:scale-105"
                      priority
                    />
                  ) : (
                    <div className="flex h-full items-center justify-center bg-gradient-to-br from-gray-100 to-gray-200">
                      <ShoppingCart className="h-24 w-24 text-gray-300" />
                    </div>
                  )}

                  {/* Discount Badge */}
                  {discountPercentage > 0 && (
                    <div className="absolute top-4 left-4">
                      <Badge className="bg-gradient-to-r from-red-500 to-rose-500 text-white border-0 shadow-lg text-sm font-bold px-3 py-1">
                        -{discountPercentage}% OFF
                      </Badge>
                    </div>
                  )}
                  
                  {/* Featured Badge */}
                  {product.isFeatured && (
                    <div className="absolute top-4 right-4">
                      <Badge className="bg-gradient-to-r from-amber-500 to-yellow-500 text-white border-0 shadow-md">
                        ⭐ Featured
                      </Badge>
                    </div>
                  )}
                </div>
              </div>

              {/* Thumbnail Gallery (if multiple images) */}
              {product.images && product.images.length > 0 && (
                <div className="flex gap-3 overflow-x-auto pb-2">
                  {[product.featuredImage, ...product.images].filter(Boolean).map((img, idx) => (
                    <button
                      key={idx}
                      className={`relative h-20 w-20 flex-shrink-0 overflow-hidden rounded-xl border-2 transition ${
                        idx === 0
                          ? "border-amber-400 ring-2 ring-amber-200"
                          : "border-gray-200 hover:border-amber-300"
                      }`}
                    >
                      <Image
                        src={img!}
                        alt={`${product.name} - Image ${idx + 1}`}
                        fill
                        className="object-cover"
                      />
                    </button>
                  ))}
                </div>
              )}

              {/* Highlights Section */}
              <div className="grid gap-3 rounded-xl sm:rounded-[2rem] border border-white/60 bg-white/70 p-4 sm:p-6 backdrop-blur">
                <p className="text-sm font-semibold uppercase tracking-[0.24em] text-amber-500">
                  Highlights
                </p>
                <p className="text-lg leading-relaxed text-gray-600 whitespace-pre-line">
                  {product.shortDescription}
                </p>
                <div className="flex flex-wrap gap-3 text-sm text-gray-500">
                  <span className="inline-flex items-center gap-2 rounded-full bg-amber-100 px-3 py-1 text-amber-700">
                    ⭐ Rated {averageRating} / 5
                  </span>
                  <span className="inline-flex items-center gap-2 rounded-full bg-rose-100 px-3 py-1 text-rose-700">
                    {reviewCount} verified reviews
                  </span>
                </div>
              </div>
            </div>

            {/* Right: Product Info */}
            <aside className="space-y-6">
              <div className="sticky top-28 space-y-6">
                {/* Main Info Card */}
                <div className="rounded-xl sm:rounded-[2.75rem] border border-white/60 bg-white/80 p-4 sm:p-8 shadow-2xl shadow-amber-100/70 backdrop-blur">
                  {/* Title & Badge */}
                  <div className="flex items-start justify-between gap-4">
                    <h1 className="text-xl sm:text-3xl font-bold tracking-tight text-gray-900 lg:text-4xl">
                      {product.name}
                    </h1>
                    <Badge
                      variant="secondary"
                      className="rounded-full bg-amber-500/15 px-3 py-1 text-xs font-semibold uppercase tracking-[0.2em] text-amber-600"
                    >
                      In Stock
                    </Badge>
                  </div>

                  {/* Rating & Category */}
                  <div className="mt-4 flex flex-wrap items-center gap-4 text-sm text-gray-600">
                    <div className="flex items-center gap-2">
                      <div className="flex">
                        {[1, 2, 3, 4].map((i) => (
                          <Star key={i} className="h-4 w-4 fill-amber-400 text-amber-400" />
                        ))}
                        <StarHalf className="h-4 w-4 fill-amber-400 text-amber-400" />
                      </div>
                      <span>{reviewCount} Reviews</span>
                    </div>
                    <span className="inline-flex items-center gap-1 rounded-full bg-amber-100 px-2 py-1 font-medium text-amber-700">
                      {product.categoryId || "Featured"}
                    </span>
                  </div>

                  {/* Price Section */}
                  <div className="mt-6 flex items-end justify-between gap-4">
                    <div>
                      <p className="text-xs uppercase tracking-[0.3em] text-amber-500">
                        {discountPercentage > 0 ? "Special Offer Price" : "Starting from"}
                      </p>
                      <p className="text-3xl sm:text-4xl font-bold text-gray-900 lg:text-5xl">
                        ৳ {product.price.toLocaleString()}
                      </p>
                      {product.compareAtPrice && (
                        <p className="text-lg text-gray-500 line-through mt-1">
                          ৳ {product.compareAtPrice.toLocaleString()}
                        </p>
                      )}
                    </div>
                    {discountPercentage > 0 && (
                      <span className="rounded-full bg-gradient-to-r from-amber-400 to-rose-400 px-4 py-2 text-xs font-semibold uppercase tracking-[0.25em] text-white shadow-lg">
                        Save ৳{((product.compareAtPrice || 0) - product.price).toLocaleString()}
                      </span>
                    )}
                  </div>

                  {/* Action Buttons (Client Component) */}
                  <ProductActions product={product} />

                  {/* Feature Cards */}
                  <div className="mt-6 grid gap-4">
                    {highlightCards.map(({ icon: Icon, title, subtitle }) => (
                      <div
                        key={title}
                        className="flex items-start gap-4 rounded-2xl border border-amber-100/60 bg-amber-50/40 p-4 text-sm text-gray-600 shadow-sm"
                      >
                        <span className="flex h-10 w-10 items-center justify-center rounded-xl bg-white text-amber-500 shadow-inner">
                          <Icon className="h-5 w-5" />
                        </span>
                        <div>
                          <p className="font-semibold text-gray-800">{title}</p>
                          <p className="text-xs text-gray-500">{subtitle}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Help Section */}
                <div className="rounded-[2rem] border border-white/60 bg-white/70 p-6 text-sm text-gray-600 backdrop-blur">
                  <p className="text-xs font-semibold uppercase tracking-[0.24em] text-amber-500">
                    Need help?
                  </p>
                  <p className="mt-2 leading-relaxed">
                    Chat with our support team for personalized recommendations,
                    delivery schedules, or bulk order support. We are online 9am – 11pm daily.
                  </p>
                </div>
              </div>
            </aside>
          </div>

          {/* Tabs Section */}
          <section className="mt-8 sm:mt-16 rounded-xl sm:rounded-[2.75rem] border border-white/60 bg-white/80 p-4 sm:p-8 shadow-xl backdrop-blur">
            <Tabs defaultValue="description" className="w-full">
              <TabsList className="inline-flex rounded-full bg-amber-100/60 p-1 text-sm">
                <TabsTrigger
                  value="description"
                  className="rounded-full px-6 py-2 font-semibold text-gray-600 data-[state=active]:bg-white data-[state=active]:text-amber-600 data-[state=active]:shadow"
                >
                  Description
                </TabsTrigger>
                <TabsTrigger
                  value="reviews"
                  className="rounded-full px-6 py-2 font-semibold text-gray-600 data-[state=active]:bg-white data-[state=active]:text-amber-600 data-[state=active]:shadow"
                >
                  Reviews ({reviewCount})
                </TabsTrigger>
                <TabsTrigger
                  value="shipping"
                  className="rounded-full px-6 py-2 font-semibold text-gray-600 data-[state=active]:bg-white data-[state=active]:text-amber-600 data-[state=active]:shadow"
                >
                  Shipping
                </TabsTrigger>
              </TabsList>

              <TabsContent value="description" className="mt-8 text-lg leading-relaxed text-gray-600">
                <div className="prose max-w-none whitespace-pre-line">
                  {product.description}
                </div>
              </TabsContent>

              <TabsContent value="reviews" className="mt-8">
                <div className="space-y-6">
                  {demoReviews.map((review) => (
                    <div
                      key={review.id}
                      className="rounded-2xl border border-gray-100 bg-white p-6 shadow-sm"
                    >
                      <div className="flex items-start justify-between">
                        <div>
                          <div className="flex items-center gap-2">
                            <span className="font-semibold text-gray-800">
                              {review.userName}
                            </span>
                            {review.verified && (
                              <Badge className="bg-green-100 text-green-700 border-0 text-xs">
                                Verified Purchase
                              </Badge>
                            )}
                          </div>
                          <div className="mt-1 flex">
                            {Array.from({ length: 5 }).map((_, i) => (
                              <Star
                                key={i}
                                className={`h-4 w-4 ${
                                  i < review.rating
                                    ? "fill-amber-400 text-amber-400"
                                    : "text-gray-200"
                                }`}
                              />
                            ))}
                          </div>
                        </div>
                        <span className="text-sm text-gray-400">
                          {review.createdAt.toLocaleDateString()}
                        </span>
                      </div>
                      <h4 className="mt-3 font-semibold text-gray-800">
                        {review.title}
                      </h4>
                      <p className="mt-2 text-gray-600">{review.content}</p>
                    </div>
                  ))}
                </div>
              </TabsContent>

              <TabsContent value="shipping" className="mt-8">
                <div className="space-y-6 text-gray-600">
                  <div className="rounded-2xl border border-amber-100 bg-amber-50/50 p-6">
                    <h4 className="font-semibold text-gray-800 mb-2">
                      📦 Delivery Information
                    </h4>
                    <ul className="space-y-2 text-sm">
                      <li>• Inside Dhaka: 2-3 business days</li>
                      <li>• Outside Dhaka: 3-5 business days</li>
                      <li>• Free shipping on orders over ৳2000</li>
                    </ul>
                  </div>
                  <div className="rounded-2xl border border-gray-100 bg-white p-6">
                    <h4 className="font-semibold text-gray-800 mb-2">
                      🔄 Return Policy
                    </h4>
                    <p className="text-sm">
                      We offer a 7-day return policy for unused items in original packaging.
                      Please contact our support team to initiate a return.
                    </p>
                  </div>
                </div>
              </TabsContent>
            </Tabs>
          </section>

          {/* Related Products */}
          {relatedProducts.length > 0 && (
            <section className="mt-16">
              <h2 className="text-2xl font-bold text-gray-800 mb-6">
                Related Products
              </h2>
              <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
                {relatedProducts.map((relatedProduct) => (
                  <Link
                    key={relatedProduct.id}
                    href={`/products/${relatedProduct.slug}`}
                    className="group rounded-2xl border border-gray-100 bg-white overflow-hidden shadow-md hover:shadow-lg transition-all"
                  >
                    <div className="relative aspect-square">
                      {relatedProduct.featuredImage && (
                        <Image
                          src={relatedProduct.featuredImage}
                          alt={relatedProduct.name}
                          fill
                          className="object-cover transition-transform group-hover:scale-105"
                        />
                      )}
                    </div>
                    <div className="p-3">
                      <h3 className="font-semibold text-gray-800 line-clamp-1">
                        {relatedProduct.name}
                      </h3>
                      <p className="text-lg font-bold text-amber-600">
                        ৳ {relatedProduct.price.toLocaleString()}
                      </p>
                    </div>
                  </Link>
                ))}
              </div>
            </section>
          )}
        </div>
      </main>
    </div>
  );
}
