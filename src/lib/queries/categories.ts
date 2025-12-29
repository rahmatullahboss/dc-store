import { eq, and, count } from "drizzle-orm";
import { getDatabase } from "@/lib/cloudflare";
import { categories, products } from "@/db/schema";
import type { Category } from "@/db/schema";

export interface CategoryWithCount extends Category {
  productCount: number;
}

/**
 * Get all active categories with product counts
 */
export async function getCategories(): Promise<CategoryWithCount[]> {
  const db = await getDatabase();
  
  // First get all categories
  const allCategories = await db
    .select()
    .from(categories)
    .where(eq(categories.isActive, true))
    .orderBy(categories.sortOrder, categories.name);
  
  // Then get product counts for each category
  const productCounts = await db
    .select({
      categoryId: products.categoryId,
      count: count(),
    })
    .from(products)
    .where(eq(products.isActive, true))
    .groupBy(products.categoryId);
  
  // Create a map for quick lookup
  const countMap = new Map(
    productCounts.map(pc => [pc.categoryId, pc.count])
  );
  
  // Merge the results
  return allCategories.map(cat => ({
    ...cat,
    productCount: countMap.get(cat.id) || 0,
  }));
}


/**
 * Get a single category by slug
 */
export async function getCategoryBySlug(slug: string): Promise<Category | null> {
  const db = await getDatabase();
  
  const result = await db.query.categories.findFirst({
    where: and(eq(categories.slug, slug), eq(categories.isActive, true)),
  });
  
  return result || null;
}

/**
 * Get featured categories (those with most products or marked as featured)
 */
export async function getFeaturedCategories(limit: number = 3): Promise<CategoryWithCount[]> {
  const allCategories = await getCategories();
  
  // Sort by product count descending and take top N
  return allCategories
    .sort((a, b) => b.productCount - a.productCount)
    .slice(0, limit);
}
