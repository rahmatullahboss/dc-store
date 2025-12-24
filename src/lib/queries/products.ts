import { eq, desc, like, or, and, sql, asc } from "drizzle-orm";
import { getDatabase } from "@/lib/cloudflare";
import { products, reviews } from "@/db/schema";
import type { Product } from "@/db/schema";

export interface ProductFilters {
  categoryId?: string;
  minPrice?: number;
  maxPrice?: number;
  isFeatured?: boolean;
  search?: string;
  sortBy?: "price-low" | "price-high" | "newest" | "name";
  limit?: number;
  offset?: number;
}

/**
 * Get all active products with optional filters
 */
export async function getProducts(filters: ProductFilters = {}): Promise<Product[]> {
  const db = await getDatabase();
  
  const conditions = [eq(products.isActive, true)];
  
  if (filters.categoryId) {
    conditions.push(eq(products.categoryId, filters.categoryId));
  }
  
  if (filters.isFeatured !== undefined) {
    conditions.push(eq(products.isFeatured, filters.isFeatured));
  }
  
  if (filters.minPrice !== undefined) {
    conditions.push(sql`${products.price} >= ${filters.minPrice}`);
  }
  
  if (filters.maxPrice !== undefined) {
    conditions.push(sql`${products.price} <= ${filters.maxPrice}`);
  }
  
  if (filters.search) {
    const searchTerm = `%${filters.search}%`;
    conditions.push(
      or(
        like(products.name, searchTerm),
        like(products.description, searchTerm),
        like(products.shortDescription, searchTerm)
      )!
    );
  }
  
  // Determine sort order
  const sortOrder = (() => {
    switch (filters.sortBy) {
      case "price-low":
        return asc(products.price);
      case "price-high":
        return desc(products.price);
      case "newest":
        return desc(products.createdAt);
      case "name":
        return asc(products.name);
      default:
        return desc(products.createdAt);
    }
  })();
  
  // Build base query
  const baseQuery = db
    .select()
    .from(products)
    .where(and(...conditions))
    .orderBy(sortOrder);
  
  // Apply pagination
  if (filters.limit && filters.offset) {
    return baseQuery.limit(filters.limit).offset(filters.offset);
  } else if (filters.limit) {
    return baseQuery.limit(filters.limit);
  } else if (filters.offset) {
    return baseQuery.offset(filters.offset);
  }
  
  return baseQuery;
}

/**
 * Get a single product by slug with category info
 */
export async function getProductBySlug(slug: string): Promise<Product | null> {
  const db = await getDatabase();
  
  const result = await db.query.products.findFirst({
    where: and(eq(products.slug, slug), eq(products.isActive, true)),
    with: {
      category: true,
    },
  });
  
  return result || null;
}

/**
 * Get featured products for home page
 */
export async function getFeaturedProducts(limit: number = 6): Promise<Product[]> {
  const db = await getDatabase();
  
  return db
    .select()
    .from(products)
    .where(and(eq(products.isActive, true), eq(products.isFeatured, true)))
    .orderBy(desc(products.createdAt))
    .limit(limit);
}

/**
 * Get products by category ID
 */
export async function getProductsByCategory(categoryId: string): Promise<Product[]> {
  const db = await getDatabase();
  
  return db
    .select()
    .from(products)
    .where(and(eq(products.isActive, true), eq(products.categoryId, categoryId)))
    .orderBy(desc(products.createdAt));
}

/**
 * Search products with query and filters
 */
export async function searchProducts(
  query: string,
  filters: Omit<ProductFilters, "search"> = {}
): Promise<Product[]> {
  return getProducts({ ...filters, search: query });
}

/**
 * Get related products (same category, excluding current product)
 */
export async function getRelatedProducts(
  productId: string,
  categoryId: string | null,
  limit: number = 4
): Promise<Product[]> {
  const db = await getDatabase();
  
  if (!categoryId) {
    // If no category, get random active products
    return db
      .select()
      .from(products)
      .where(and(eq(products.isActive, true), sql`${products.id} != ${productId}`))
      .orderBy(desc(products.createdAt))
      .limit(limit);
  }
  
  return db
    .select()
    .from(products)
    .where(
      and(
        eq(products.isActive, true),
        eq(products.categoryId, categoryId),
        sql`${products.id} != ${productId}`
      )
    )
    .orderBy(desc(products.createdAt))
    .limit(limit);
}

/**
 * Get product reviews
 */
export async function getProductReviews(productId: string) {
  const db = await getDatabase();
  
  return db.query.reviews.findMany({
    where: and(eq(reviews.productId, productId), eq(reviews.isApproved, true)),
    with: {
      user: {
        columns: {
          id: true,
          name: true,
          image: true,
        },
      },
    },
    orderBy: [desc(reviews.createdAt)],
  });
}

/**
 * Get unique categories from products (for filter badges)
 */
export async function getProductCategories(): Promise<string[]> {
  const db = await getDatabase();
  
  const result = await db
    .selectDistinct({ categoryId: products.categoryId })
    .from(products)
    .where(eq(products.isActive, true));
  
  return result
    .map((r) => r.categoryId)
    .filter((id): id is string => id !== null);
}
