import { eq, sql, and } from "drizzle-orm";
import { getDatabase } from "@/lib/cloudflare";
import { categories } from "@/db/schema";
import type { Category } from "@/db/schema";

export interface CategoryWithCount extends Category {
  productCount: number;
}

/**
 * Get all active categories with product counts
 */
export async function getCategories(): Promise<CategoryWithCount[]> {
  const db = await getDatabase();
  
  const result = await db
    .select({
      id: categories.id,
      name: categories.name,
      slug: categories.slug,
      description: categories.description,
      image: categories.image,
      parentId: categories.parentId,
      sortOrder: categories.sortOrder,
      isActive: categories.isActive,
      createdAt: categories.createdAt,
      updatedAt: categories.updatedAt,
      productCount: sql<number>`(
        SELECT COUNT(*) FROM products 
        WHERE products.category_id = ${categories.id} 
        AND products.is_active = 1
      )`.as("productCount"),
    })
    .from(categories)
    .where(eq(categories.isActive, true))
    .orderBy(categories.sortOrder, categories.name);
  
  return result;
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
