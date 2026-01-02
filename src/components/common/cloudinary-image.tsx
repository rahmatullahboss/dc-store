"use client";

import { CldImage } from "next-cloudinary";

interface CloudinaryImageProps {
  src: string;
  alt: string;
  width: number;
  height: number;
  className?: string;
  priority?: boolean;
  sizes?: string;
}

/**
 * Optimized image component using Cloudinary
 * - Auto format (WebP/AVIF)
 * - Auto quality optimization
 * - Responsive sizing
 */
export function CloudinaryImage({
  src,
  alt,
  width,
  height,
  className,
  priority = false,
  sizes = "(max-width: 768px) 100vw, 50vw",
}: CloudinaryImageProps) {
  // If src is a Cloudinary public_id, use it directly
  // If it's a full URL, extract the public_id or use regular img
  const isCloudinaryUrl = src.includes("cloudinary.com") || !src.startsWith("http");
  
  if (!isCloudinaryUrl) {
    // For non-Cloudinary images, use regular img with loading optimization
    return (
      // eslint-disable-next-line @next/next/no-img-element
      <img
        src={src}
        alt={alt}
        width={width}
        height={height}
        className={className}
        loading={priority ? "eager" : "lazy"}
      />
    );
  }

  // Extract public_id from Cloudinary URL if needed
  let publicId = src;
  if (src.includes("cloudinary.com")) {
    // Extract public_id from URL like: https://res.cloudinary.com/xxx/image/upload/v123/folder/image.jpg
    const match = src.match(/\/upload\/(?:v\d+\/)?(.+?)(?:\.\w+)?$/);
    if (match) {
      publicId = match[1];
    }
  }

  return (
    <CldImage
      src={publicId}
      alt={alt}
      width={width}
      height={height}
      className={className}
      sizes={sizes}
      loading={priority ? "eager" : "lazy"}
      format="auto"
      quality="auto"
    />
  );
}
