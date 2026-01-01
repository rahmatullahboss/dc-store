"use client";

import { Link } from "@/i18n/routing";
import { formatPrice } from "@/lib/config";
import { TrendingUp, Package } from "lucide-react";
import { cn } from "@/lib/utils";

interface TopProduct {
  id: string;
  name: string;
  featuredImage: string | null;
  totalSold: number;
  revenue: number;
}

interface TopProductsWidgetProps {
  products: TopProduct[];
  className?: string;
}

export function TopProductsWidget({
  products,
  className,
}: TopProductsWidgetProps) {
  if (products.length === 0) {
    return (
      <div className={cn("bg-slate-800/50 border border-slate-700 rounded-xl p-4", className)}>
        <div className="flex items-center gap-2 mb-3">
          <TrendingUp className="h-5 w-5 text-green-400" />
          <h3 className="font-semibold text-white">Top Selling Products</h3>
        </div>
        <p className="text-sm text-slate-400">No sales data yet</p>
      </div>
    );
  }

  const maxRevenue = Math.max(...products.map((p) => p.revenue));

  return (
    <div className={cn("bg-slate-800/50 border border-slate-700 rounded-xl p-4", className)}>
      <div className="flex items-center gap-2 mb-4">
        <TrendingUp className="h-5 w-5 text-green-400" />
        <h3 className="font-semibold text-white">Top Selling Products</h3>
      </div>

      <div className="space-y-3">
        {products.slice(0, 5).map((product, index) => (
          <Link
            key={product.id}
            href={`/admin/products/${product.id}`}
            className="flex items-center gap-3 group"
          >
            <span className="text-xs text-slate-500 w-4">{index + 1}.</span>
            <div className="w-8 h-8 rounded bg-slate-700 flex items-center justify-center flex-shrink-0">
              <Package className="h-4 w-4 text-slate-500" />
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm text-white line-clamp-1 group-hover:text-amber-400 transition-colors">
                {product.name}
              </p>
              <div className="flex items-center gap-2 mt-1">
                <div className="flex-1 h-1.5 bg-slate-700 rounded-full overflow-hidden">
                  <div
                    className="h-full bg-gradient-to-r from-green-500 to-emerald-400 rounded-full"
                    style={{ width: `${(product.revenue / maxRevenue) * 100}%` }}
                  />
                </div>
                <span className="text-xs text-slate-400 whitespace-nowrap">
                  {product.totalSold} sold
                </span>
              </div>
            </div>
            <span className="text-sm font-medium text-green-400">
              {formatPrice(product.revenue)}
            </span>
          </Link>
        ))}
      </div>
    </div>
  );
}
