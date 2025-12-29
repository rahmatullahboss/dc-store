
import { getDatabase } from "../src/lib/cloudflare";
import { products, categories } from "../src/db/schema";
import { eq, sql } from "drizzle-orm";

async function verifyCategories() {
  console.log("Starting Category Verification...");
  const db = await getDatabase();

  // 1. Fetch all categories
  const allCategories = await db.select().from(categories);
  console.log(`Found ${allCategories.length} categories.`);

  for (const category of allCategories) {
    // 2. Count products for this category using direct SQL count
    const result = await db.select({
      count: sql<number>`count(*)`
    })
    .from(products)
    .where(eq(products.categoryId, category.id));
    
    const count = result[0].count;
    
    console.log(`Category: ${category.name} (ID: ${category.id})`);
    console.log(`  - Products Count (DB): ${count}`);
    
    // Check for products with this category but potentially inactive
    const inactiveCount = await db.select({
      count: sql<number>`count(*)`
    })
    .from(products)
    .where(sql`${products.categoryId} = ${category.id} AND ${products.isActive} = 0`);
    
    if (inactiveCount[0].count > 0) {
      console.log(`  - Inactive Products: ${inactiveCount[0].count}`);
    }
  }

  // 3. Check for products with NULL category
  const nullCategoryProducts = await db.select({
    count: sql<number>`count(*)`
  })
  .from(products)
  .where(sql`${products.categoryId} IS NULL`);

  if (nullCategoryProducts[0].count > 0) {
    console.log(`WARNING: Found ${nullCategoryProducts[0].count} products with NULL category!`);
    
    const sampleProducts = await db.select({
        id: products.id,
        name: products.name
    })
    .from(products)
    .where(sql`${products.categoryId} IS NULL`)
    .limit(5);
    
    console.log("  Sample products with NULL category:");
    sampleProducts.forEach(p => console.log(`    - ${p.name} (${p.id})`));
  }
  
  console.log("Verification Complete.");
}

verifyCategories().catch(console.error);
