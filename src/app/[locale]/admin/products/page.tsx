"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import Image from "next/image";
import { formatPrice } from "@/lib/config";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import {
  Plus,
  Search,
  Edit,
  Trash2,
  MoreHorizontal,
  Package,
} from "lucide-react";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { cn } from "@/lib/utils";

interface Product {
  id: string;
  name: string;
  slug: string;
  price: number;
  compareAtPrice: number | null;
  quantity: number;
  featuredImage: string | null;
  isActive: boolean;
  isFeatured: boolean;
  categoryName: string | null;
  createdAt: string;
}

export default function AdminProductsPage() {
  const [products, setProducts] = useState<Product[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState("");

  const fetchProducts = async () => {
    try {
      const params = new URLSearchParams();
      if (search) params.set("search", search);
      const res = await fetch(`/api/admin/products?${params}`);
      if (res.ok) {
        const data = await res.json() as { products: Product[] };
        setProducts(data.products || []);
      }
    } catch (error) {
      console.error("Failed to fetch products:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchProducts();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    fetchProducts();
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Are you sure you want to delete this product?")) return;

    try {
      const res = await fetch(`/api/admin/products/${id}`, {
        method: "DELETE",
      });
      if (res.ok) {
        setProducts(products.filter((p) => p.id !== id));
      }
    } catch (error) {
      console.error("Failed to delete product:", error);
    }
  };

  const toggleStatus = async (id: string, currentStatus: boolean) => {
    try {
      const res = await fetch(`/api/admin/products/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ isActive: !currentStatus }),
      });
      if (res.ok) {
        setProducts(
          products.map((p) =>
            p.id === id ? { ...p, isActive: !currentStatus } : p
          )
        );
      }
    } catch (error) {
      console.error("Failed to toggle status:", error);
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <h1 className="text-2xl font-bold text-white">Products</h1>
        <Button asChild className="bg-primary hover:bg-amber-600 text-black">
          <Link href="/admin/products/new">
            <Plus className="h-4 w-4 mr-2" />
            Add Product
          </Link>
        </Button>
      </div>

      {/* Search */}
      <form onSubmit={handleSearch} className="flex gap-2 max-w-md">
        <Input
          placeholder="Search products..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="bg-slate-800 border-slate-700 text-white placeholder:text-slate-400"
        />
        <Button type="submit" variant="secondary" className="bg-slate-700 hover:bg-slate-600">
          <Search className="h-4 w-4" />
        </Button>
      </form>

      {/* Products Table */}
      <div className="bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden">
        {isLoading ? (
          <div className="p-8 text-center text-slate-400">Loading...</div>
        ) : products.length === 0 ? (
          <div className="p-8 text-center">
            <Package className="h-12 w-12 mx-auto text-slate-600 mb-3" />
            <p className="text-slate-400">No products found</p>
            <Button asChild className="mt-4 bg-primary hover:bg-amber-600 text-black">
              <Link href="/admin/products/new">Add Your First Product</Link>
            </Button>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-slate-700">
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Product
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Price
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Stock
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Category
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
                {products.map((product) => (
                  <tr
                    key={product.id}
                    className="border-b border-slate-700/50 hover:bg-slate-800/50"
                  >
                    <td className="py-3 px-4">
                      <div className="flex items-center gap-3">
                        <div className="relative w-10 h-10 rounded-lg overflow-hidden bg-slate-700 flex-shrink-0">
                          {product.featuredImage ? (
                            <Image
                              src={product.featuredImage}
                              alt={product.name}
                              fill
                              className="object-cover"
                            />
                          ) : (
                            <div className="w-full h-full flex items-center justify-center">
                              <Package className="h-5 w-5 text-slate-500" />
                            </div>
                          )}
                        </div>
                        <div>
                          <p className="text-sm font-medium text-white line-clamp-1">
                            {product.name}
                          </p>
                          {product.isFeatured && (
                            <span className="text-xs text-amber-400">Featured</span>
                          )}
                        </div>
                      </div>
                    </td>
                    <td className="py-3 px-4">
                      <p className="text-sm text-white">
                        {formatPrice(product.price)}
                      </p>
                      {product.compareAtPrice && (
                        <p className="text-xs text-slate-400 line-through">
                          {formatPrice(product.compareAtPrice)}
                        </p>
                      )}
                    </td>
                    <td className="py-3 px-4">
                      <span
                        className={cn(
                          "text-sm",
                          product.quantity > 10
                            ? "text-green-400"
                            : product.quantity > 0
                            ? "text-yellow-400"
                            : "text-red-400"
                        )}
                      >
                        {product.quantity}
                      </span>
                    </td>
                    <td className="py-3 px-4 text-sm text-slate-400">
                      {product.categoryName || "—"}
                    </td>
                    <td className="py-3 px-4">
                      <button
                        onClick={() => toggleStatus(product.id, product.isActive)}
                        className={cn(
                          "text-xs px-2 py-1 rounded-full",
                          product.isActive
                            ? "bg-green-500/20 text-green-400"
                            : "bg-slate-600/20 text-slate-400"
                        )}
                      >
                        {product.isActive ? "Active" : "Inactive"}
                      </button>
                    </td>
                    <td className="py-3 px-4 text-right">
                      <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                          <Button
                            variant="ghost"
                            size="icon"
                            className="text-slate-400 hover:text-white"
                          >
                            <MoreHorizontal className="h-4 w-4" />
                          </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent
                          align="end"
                          className="bg-slate-800 border-slate-700"
                        >
                          <DropdownMenuItem asChild>
                            <Link
                              href={`/admin/products/${product.id}`}
                              className="text-slate-300 cursor-pointer"
                            >
                              <Edit className="mr-2 h-4 w-4" />
                              Edit
                            </Link>
                          </DropdownMenuItem>
                          <DropdownMenuItem
                            onClick={() => handleDelete(product.id)}
                            className="text-red-400 cursor-pointer"
                          >
                            <Trash2 className="mr-2 h-4 w-4" />
                            Delete
                          </DropdownMenuItem>
                        </DropdownMenuContent>
                      </DropdownMenu>
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
