import { NextRequest, NextResponse } from 'next/server';
import { db } from '@/db';
import { products, productImages } from '@/db/schema';
import { eq, or } from 'drizzle-orm';

export const runtime = 'edge';

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params;
    
    if (!id) {
      return NextResponse.json(
        { error: 'Product ID is required' },
        { status: 400 }
      );
    }

    // Try to find by ID first, then by slug
    const productResult = await db
      .select()
      .from(products)
      .where(or(eq(products.id, id), eq(products.slug, id)))
      .limit(1);

    if (productResult.length === 0) {
      return NextResponse.json(
        { error: 'Product not found' },
        { status: 404 }
      );
    }

    const product = productResult[0];

    // Get product images
    const images = await db
      .select()
      .from(productImages)
      .where(eq(productImages.productId, product.id));

    // Format product for response
    const formattedProduct = {
      id: product.id,
      name: product.name,
      slug: product.slug,
      description: product.description,
      price: Number(product.price),
      compareAtPrice: product.compareAtPrice ? Number(product.compareAtPrice) : null,
      featuredImage: product.featuredImage,
      images: images.map(img => img.imageUrl),
      categoryId: product.categoryId,
      stock: product.stock,
      sku: product.sku,
      isActive: product.isActive,
      isFeatured: product.isFeatured,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    };

    return NextResponse.json({ product: formattedProduct });
  } catch (error) {
    console.error('Error fetching product:', error);
    return NextResponse.json(
      { error: 'Failed to fetch product' },
      { status: 500 }
    );
  }
}
