/**
 * Cloudinary Image Loader for Next.js
 * This loader transforms images through Cloudinary for optimization
 * 
 * Features:
 * - Auto format (f_auto): Serves WebP/AVIF based on browser support
 * - Auto quality (q_auto): Optimizes quality based on content
 * - Responsive sizing: Creates optimized versions for each size
 */

interface CloudinaryLoaderParams {
  src: string;
  width: number;
  quality?: number;
}

const CLOUD_NAME = process.env.NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME || "dpnccgsja";

export function cloudinaryLoader({ src, width, quality = 80 }: CloudinaryLoaderParams): string {
  // If already a Cloudinary URL, add transformations
  if (src.includes("cloudinary.com")) {
    // Insert transformations before the version/public_id
    const parts = src.split("/upload/");
    if (parts.length === 2) {
      const transformations = `f_auto,q_auto,w_${width}`;
      return `${parts[0]}/upload/${transformations}/${parts[1]}`;
    }
    return src;
  }

  // If it's a relative URL (local image), use Cloudinary fetch
  // This allows Cloudinary to optimize external images too
  if (src.startsWith("/")) {
    const appUrl = process.env.NEXT_PUBLIC_APP_URL || "https://store.digitalcare.site";
    const fullUrl = `${appUrl}${src}`;
    return `https://res.cloudinary.com/${CLOUD_NAME}/image/fetch/f_auto,q_${quality},w_${width}/${fullUrl}`;
  }

  // For external URLs, use Cloudinary fetch
  if (src.startsWith("http")) {
    return `https://res.cloudinary.com/${CLOUD_NAME}/image/fetch/f_auto,q_${quality},w_${width}/${src}`;
  }

  // Default: assume it's a Cloudinary public_id
  return `https://res.cloudinary.com/${CLOUD_NAME}/image/upload/f_auto,q_auto,w_${width}/${src}`;
}
