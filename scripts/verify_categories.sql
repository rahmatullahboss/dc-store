-- check total products
SELECT 'Total Products' as check_name, COUNT(*) as count FROM products;

-- check total categories
SELECT 'Total Categories' as check_name, COUNT(*) as count FROM categories;

-- check products per category
SELECT 
  c.name as category_name, 
  c.id as category_id,
  COUNT(p.id) as product_count 
FROM categories c
LEFT JOIN products p ON p.category_id = c.id
GROUP BY c.id, c.name
ORDER BY product_count DESC;

-- check for products with null category
SELECT 
  'Products with NULL Category' as check_name, 
  COUNT(*) as count 
FROM products 
WHERE category_id IS NULL;

-- check for products with invalid category_id (orphaned)
SELECT 
  'Orphaned Products' as check_name, 
  COUNT(*) as count 
FROM products p
LEFT JOIN categories c ON p.category_id = c.id
WHERE p.category_id IS NOT NULL AND c.id IS NULL;

-- List top 5 products with null category (if any)
SELECT id, name FROM products WHERE category_id IS NULL LIMIT 5;
