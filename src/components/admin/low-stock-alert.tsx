"use client";

import { AlertTriangle, Package } from "lucide-react";
import { Link } from "@/i18n/routing";
import { cn } from "@/lib/utils";

interface LowStockProduct {
  id: string;
  name: string;
  quantity: number;
  featuredImage: string | null;
}

interface LowStockAlertProps {
  products: LowStockProduct[];
  threshold?: number;
  className?: string;
}

export function LowStockAlert({
  products,
  threshold = 5,
  className,
}: LowStockAlertProps) {
  if (products.length === 0) return null;

  const criticalProducts = products.filter((p) => p.quantity === 0);
  const lowProducts = products.filter((p) => p.quantity > 0 && p.quantity <= threshold);

  return (
    <div
      className={cn(
        "bg-slate-800/50 border border-slate-700 rounded-xl p-4",
        className
      )}
    >
      <div className="flex items-center gap-2 mb-3">
        <AlertTriangle className="h-5 w-5 text-amber-400" />
        <h3 className="font-semibold text-white">Low Stock Alert</h3>
        <span className="ml-auto text-xs bg-amber-500/20 text-amber-400 px-2 py-0.5 rounded-full">
          {products.length} items
        </span>
      </div>

      <div className="space-y-2 max-h-48 overflow-y-auto">
        {criticalProducts.length > 0 && (
          <div className="space-y-1">
            {criticalProducts.slice(0, 3).map((product) => (
              <Link
                key={product.id}
                href={`/admin/products/${product.id}`}
                className="flex items-center gap-2 p-2 rounded-lg hover:bg-slate-800 transition-colors"
              >
                <div className="w-8 h-8 rounded bg-slate-700 flex items-center justify-center flex-shrink-0">
                  <Package className="h-4 w-4 text-slate-500" />
                </div>
                <span className="text-sm text-white flex-1 line-clamp-1">
                  {product.name}
                </span>
                <span className="text-xs px-2 py-0.5 rounded-full bg-red-500/20 text-red-400">
                  Out of stock
                </span>
              </Link>
            ))}
          </div>
        )}

        {lowProducts.length > 0 && (
          <div className="space-y-1">
            {lowProducts.slice(0, 5 - criticalProducts.length).map((product) => (
              <Link
                key={product.id}
                href={`/admin/products/${product.id}`}
                className="flex items-center gap-2 p-2 rounded-lg hover:bg-slate-800 transition-colors"
              >
                <div className="w-8 h-8 rounded bg-slate-700 flex items-center justify-center flex-shrink-0">
                  <Package className="h-4 w-4 text-slate-500" />
                </div>
                <span className="text-sm text-white flex-1 line-clamp-1">
                  {product.name}
                </span>
                <span className="text-xs px-2 py-0.5 rounded-full bg-yellow-500/20 text-yellow-400">
                  {product.quantity} left
                </span>
              </Link>
            ))}
          </div>
        )}
      </div>

      {products.length > 5 && (
        <Link
          href="/admin/products?filter=low-stock"
          className="block text-center text-xs text-amber-400 hover:text-amber-300 mt-3"
        >
          View all {products.length} low stock items →
        </Link>
      )}
    </div>
  );
}
