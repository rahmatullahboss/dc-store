import Image from "next/image";
import Link from "next/link";
import { notFound } from "next/navigation";
import { ArrowLeft, ShoppingCart, Truck, ShieldCheck, Star, StarHalf } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { siteConfig } from "@/lib/config";
import type { Metadata } from "next";
import { getProductBySlug, getRelatedProducts, getProductReviews } from "@/lib/queries";
import { ProductActions } from "./product-actions";

// ISR: Cache for 3600 seconds (1 hour), on-demand revalidation via admin actions
// Note: Only works with manual deploy (wrangler deploy), not Git integration
export const revalidate = 3600;

export async function generateMetadata({
  params,
}: {
  params: Promise<{ slug: string }>;
}): Promise<Metadata> {
  const { slug } = await params;
  const product = await getProductBySlug(slug);

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

export default async function ProductDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  
  // Fetch product from database
  const product = await getProductBySlug(slug);

  if (!product) {
    notFound();
  }

  // Fetch related products and reviews in parallel
  const [relatedProducts, reviews] = await Promise.all([
    getRelatedProducts(product.id, product.categoryId, 4),
    getProductReviews(product.id),
  ]);

  const discountPercentage = product.compareAtPrice
    ? Math.round(
        ((product.compareAtPrice - product.price) / product.compareAtPrice) * 100
      )
    : 0;

  // Calculate average rating from reviews
  const averageRating = reviews.length > 0
    ? reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length
    : 4.5; // Default rating if no reviews
  const reviewCount = reviews.length;

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
    <div className="relative min-h-screen bg-background text-gray-900">
      {/* Background decorations */}
      <div className="pointer-events-none absolute inset-0 overflow-hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl dark:opacity-0" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl dark:opacity-0" />
        <div className="absolute top-1/3 left-1/2 h-64 w-64 -translate-x-1/2 rounded-full bg-blue-200/40 blur-3xl dark:opacity-0" />
      </div>

      <main className="relative z-10 pb-20 md:pb-0">
        <div className="container mx-auto px-3 py-6 sm:px-6 lg:py-16 lg:px-8">
          {/* Breadcrumb */}
          <div className="mb-6 flex items-center gap-3 text-sm text-muted-foreground">
            <Link
              href="/products"
              className="inline-flex items-center gap-1 rounded-full bg-card/80 px-4 py-2 shadow-sm ring-1 ring-amber-200 transition hover:text-primary hover:ring-amber-300"
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
              <div className="group relative overflow-hidden rounded-2xl sm:rounded-[2.75rem] border border-white/60 bg-card shadow-xl shadow-amber-100/80">
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
                      <ShoppingCart className="h-24 w-24 text-muted-foreground" />
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
                          : "border-border hover:border-amber-300"
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
              <div className="grid gap-3 rounded-xl sm:rounded-[2rem] border border-white/60 bg-card/70 p-4 sm:p-6 backdrop-blur">
                <p className="text-sm font-semibold uppercase tracking-[0.24em] text-primary">
                  Highlights
                </p>
                <p className="text-lg leading-relaxed text-muted-foreground whitespace-pre-line">
                  {product.shortDescription}
                </p>
                <div className="flex flex-wrap gap-3 text-sm text-muted-foreground">
                  <span className="inline-flex items-center gap-2 rounded-full bg-amber-100 px-3 py-1 text-amber-700">
                    ⭐ Rated {averageRating.toFixed(1)} / 5
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
                <div className="rounded-xl sm:rounded-[2.75rem] border border-white/60 bg-card/80 p-4 sm:p-8 shadow-2xl shadow-amber-100/70 backdrop-blur">
                  {/* Title & Badge */}
                  <div className="flex items-start justify-between gap-4">
                    <h1 className="text-xl sm:text-3xl font-bold tracking-tight text-gray-900 lg:text-4xl">
                      {product.name}
                    </h1>
                    <Badge
                      variant="secondary"
                      className="rounded-full bg-primary/15 px-3 py-1 text-xs font-semibold uppercase tracking-[0.2em] text-primary"
                    >
                      {product.quantity && product.quantity > 0 ? "In Stock" : "Out of Stock"}
                    </Badge>
                  </div>

                  {/* Rating & Category */}
                  <div className="mt-4 flex flex-wrap items-center gap-4 text-sm text-muted-foreground">
                    <div className="flex items-center gap-2">
                      <div className="flex">
                        {Array.from({ length: Math.floor(averageRating) }).map((_, i) => (
                          <Star key={i} className="h-4 w-4 fill-amber-400 text-amber-400" />
                        ))}
                        {averageRating % 1 >= 0.5 && (
                          <StarHalf className="h-4 w-4 fill-amber-400 text-amber-400" />
                        )}
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
                      <p className="text-xs uppercase tracking-[0.3em] text-primary">
                        {discountPercentage > 0 ? "Special Offer Price" : "Starting from"}
                      </p>
                      <p className="text-3xl sm:text-4xl font-bold text-gray-900 lg:text-5xl">
                        ৳ {product.price.toLocaleString()}
                      </p>
                      {product.compareAtPrice && (
                        <p className="text-lg text-muted-foreground line-through mt-1">
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
                        className="flex items-start gap-4 rounded-2xl border border-amber-100/60 bg-amber-50/40 p-4 text-sm text-muted-foreground shadow-sm"
                      >
                        <span className="flex h-10 w-10 items-center justify-center rounded-xl bg-card text-primary shadow-inner">
                          <Icon className="h-5 w-5" />
                        </span>
                        <div>
                          <p className="font-semibold text-foreground">{title}</p>
                          <p className="text-xs text-muted-foreground">{subtitle}</p>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Help Section */}
                <div className="rounded-[2rem] border border-white/60 bg-card/70 p-6 text-sm text-muted-foreground backdrop-blur">
                  <p className="text-xs font-semibold uppercase tracking-[0.24em] text-primary">
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
          <section className="mt-8 sm:mt-16 rounded-xl sm:rounded-[2.75rem] border border-white/60 bg-card/80 p-4 sm:p-8 shadow-xl backdrop-blur">
            <Tabs defaultValue="description" className="w-full">
              <TabsList className="inline-flex rounded-full bg-amber-100/60 p-1 text-sm">
                <TabsTrigger
                  value="description"
                  className="rounded-full px-6 py-2 font-semibold text-muted-foreground data-[state=active]:bg-card data-[state=active]:text-primary data-[state=active]:shadow"
                >
                  Description
                </TabsTrigger>
                <TabsTrigger
                  value="reviews"
                  className="rounded-full px-6 py-2 font-semibold text-muted-foreground data-[state=active]:bg-card data-[state=active]:text-primary data-[state=active]:shadow"
                >
                  Reviews ({reviewCount})
                </TabsTrigger>
                <TabsTrigger
                  value="shipping"
                  className="rounded-full px-6 py-2 font-semibold text-muted-foreground data-[state=active]:bg-card data-[state=active]:text-primary data-[state=active]:shadow"
                >
                  Shipping
                </TabsTrigger>
              </TabsList>

              <TabsContent value="description" className="mt-8 text-lg leading-relaxed text-muted-foreground">
                <div className="prose max-w-none whitespace-pre-line">
                  {product.description}
                </div>
              </TabsContent>

              <TabsContent value="reviews" className="mt-8">
                <div className="space-y-6">
                  {reviews.length > 0 ? (
                    reviews.map((review) => (
                      <div
                        key={review.id}
                        className="rounded-2xl border border-border bg-card p-6 shadow-sm"
                      >
                        <div className="flex items-start justify-between">
                          <div>
                            <div className="flex items-center gap-2">
                              <span className="font-semibold text-foreground">
                                {review.user?.name || "Anonymous"}
                              </span>
                              {review.isVerified && (
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
                          <span className="text-sm text-muted-foreground">
                            {review.createdAt ? new Date(review.createdAt).toLocaleDateString() : ""}
                          </span>
                        </div>
                        {review.title && (
                          <h4 className="mt-3 font-semibold text-foreground">
                            {review.title}
                          </h4>
                        )}
                        <p className="mt-2 text-muted-foreground">{review.content}</p>
                      </div>
                    ))
                  ) : (
                    <div className="text-center py-8 text-muted-foreground">
                      No reviews yet. Be the first to review this product!
                    </div>
                  )}
                </div>
              </TabsContent>

              <TabsContent value="shipping" className="mt-8">
                <div className="space-y-6 text-muted-foreground">
                  <div className="rounded-2xl border border-amber-100 bg-amber-50/50 p-6">
                    <h4 className="font-semibold text-foreground mb-2">
                      📦 Delivery Information
                    </h4>
                    <ul className="space-y-2 text-sm">
                      <li>• Inside Dhaka: 2-3 business days</li>
                      <li>• Outside Dhaka: 3-5 business days</li>
                      <li>• Free shipping on orders over ৳2000</li>
                    </ul>
                  </div>
                  <div className="rounded-2xl border border-border bg-card p-6">
                    <h4 className="font-semibold text-foreground mb-2">
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
              <h2 className="text-2xl font-bold text-foreground mb-6">
                Related Products
              </h2>
              <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
                {relatedProducts.map((relatedProduct) => (
                  <Link
                    key={relatedProduct.id}
                    href={`/products/${relatedProduct.slug}`}
                    className="group rounded-2xl border border-border bg-card overflow-hidden shadow-md hover:shadow-lg transition-all"
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
                      <h3 className="font-semibold text-foreground line-clamp-1">
                        {relatedProduct.name}
                      </h3>
                      <p className="text-lg font-bold text-primary">
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
