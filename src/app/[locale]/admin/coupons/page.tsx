"use client";

import { useEffect, useState } from "react";
import { formatPrice } from "@/lib/config";
import { Button } from "@/components/ui/button";
import { Plus, Edit, Trash2, Ticket } from "lucide-react";
import { cn } from "@/lib/utils";
import Link from "next/link";

interface Coupon {
  id: string;
  code: string;
  description: string | null;
  discountType: "percentage" | "fixed";
  discountValue: number;
  minOrderAmount: number | null;
  usageLimit: number | null;
  usedCount: number;
  expiresAt: string | null;
  isActive: boolean;
}

export default function AdminCouponsPage() {
  const [coupons, setCoupons] = useState<Coupon[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  const fetchCoupons = async () => {
    try {
      const res = await fetch("/api/admin/coupons");
      if (res.ok) {
        const data = await res.json() as { coupons: Coupon[] };
        setCoupons(data.coupons || []);
      }
    } catch (error) {
      console.error("Failed to fetch coupons:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchCoupons();
  }, []);

  const handleDelete = async (id: string) => {
    if (!confirm("Are you sure you want to delete this coupon?")) return;

    try {
      const res = await fetch(`/api/admin/coupons/${id}`, {
        method: "DELETE",
      });
      if (res.ok) {
        setCoupons(coupons.filter((c) => c.id !== id));
      }
    } catch (error) {
      console.error("Failed to delete coupon:", error);
    }
  };

  const toggleStatus = async (id: string, currentStatus: boolean) => {
    try {
      const res = await fetch(`/api/admin/coupons/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ isActive: !currentStatus }),
      });
      if (res.ok) {
        setCoupons(
          coupons.map((c) =>
            c.id === id ? { ...c, isActive: !currentStatus } : c
          )
        );
      }
    } catch (error) {
      console.error("Failed to toggle status:", error);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-white">Coupons</h1>
        <Button asChild className="bg-primary hover:bg-amber-600 text-black">
          <Link href="/admin/coupons/new">
            <Plus className="h-4 w-4 mr-2" />
            Add Coupon
          </Link>
        </Button>
      </div>

      <div className="bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden">
        {isLoading ? (
          <div className="p-8 text-center text-slate-400">Loading...</div>
        ) : coupons.length === 0 ? (
          <div className="p-8 text-center">
            <Ticket className="h-12 w-12 mx-auto text-slate-600 mb-3" />
            <p className="text-slate-400">No coupons yet</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-slate-700">
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Code
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Discount
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Usage
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Expires
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Status
                  </th>
                  <th className="text-right text-xs font-medium text-slate-400 py-3 px-4">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody>
                {coupons.map((coupon) => (
                  <tr
                    key={coupon.id}
                    className="border-b border-slate-700/50 hover:bg-slate-800/50"
                  >
                    <td className="py-3 px-4">
                      <span className="font-mono text-sm font-medium text-amber-400">
                        {coupon.code}
                      </span>
                      {coupon.description && (
                        <p className="text-xs text-slate-400 mt-0.5">
                          {coupon.description}
                        </p>
                      )}
                    </td>
                    <td className="py-3 px-4 text-sm text-white">
                      {coupon.discountType === "percentage"
                        ? `${coupon.discountValue}%`
                        : formatPrice(coupon.discountValue)}
                      {coupon.minOrderAmount && (
                        <span className="text-xs text-slate-400 block">
                          Min: {formatPrice(coupon.minOrderAmount)}
                        </span>
                      )}
                    </td>
                    <td className="py-3 px-4 text-sm text-slate-300">
                      {coupon.usedCount}
                      {coupon.usageLimit && ` / ${coupon.usageLimit}`}
                    </td>
                    <td className="py-3 px-4 text-sm text-slate-400">
                      {coupon.expiresAt
                        ? new Date(coupon.expiresAt).toLocaleDateString()
                        : "Never"}
                    </td>
                    <td className="py-3 px-4">
                      <button
                        onClick={() => toggleStatus(coupon.id, coupon.isActive)}
                        className={cn(
                          "text-xs px-2 py-1 rounded-full",
                          coupon.isActive
                            ? "bg-green-500/20 text-green-400"
                            : "bg-slate-600/20 text-slate-400"
                        )}
                      >
                        {coupon.isActive ? "Active" : "Inactive"}
                      </button>
                    </td>
                    <td className="py-3 px-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        <Button
                          variant="ghost"
                          size="icon"
                          asChild
                          className="text-slate-400 hover:text-white"
                        >
                          <Link href={`/admin/coupons/${coupon.id}`}>
                            <Edit className="h-4 w-4" />
                          </Link>
                        </Button>
                        <Button
                          variant="ghost"
                          size="icon"
                          onClick={() => handleDelete(coupon.id)}
                          className="text-slate-400 hover:text-red-400"
                        >
                          <Trash2 className="h-4 w-4" />
                        </Button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
}
