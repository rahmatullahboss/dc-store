"use client";

import { useState, useEffect, use } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { formatPrice } from "@/lib/config";
import { Button } from "@/components/ui/button";
import { 
  ArrowLeft, 
  Mail, 
  Phone, 
  MapPin, 
  ShoppingCart, 
  Calendar, 
  User,
  Package
} from "lucide-react";
import { cn } from "@/lib/utils";
import Image from "next/image";

interface Order {
  id: string;
  orderNumber: string;
  total: number;
  status: string;
  createdAt: string;
  itemsCount: number;
}

interface Customer {
  id: string;
  name: string;
  email: string;
  phone: string | null;
  image: string | null;
  role: string;
  defaultAddress: {
    division?: string;
    district?: string;
    address?: string;
  } | null;
  ordersCount: number;
  totalSpent: number;
  createdAt: string;
  orders: Order[];
}

const statusColors: Record<string, string> = {
  pending: "bg-yellow-500/20 text-yellow-400",
  confirmed: "bg-blue-500/20 text-blue-400",
  processing: "bg-purple-500/20 text-purple-400",
  shipped: "bg-cyan-500/20 text-cyan-400",
  delivered: "bg-green-500/20 text-green-400",
  cancelled: "bg-red-500/20 text-red-400",
};

export default function CustomerDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = use(params);
  const router = useRouter();
  const [customer, setCustomer] = useState<Customer | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    async function fetchCustomer() {
      try {
        const res = await fetch(`/api/admin/customers/${id}`);
        const data = await res.json() as { customer?: Customer };
        if (data.customer) setCustomer(data.customer);
      } catch (error) {
        console.error(error);
      } finally {
        setIsLoading(false);
      }
    }
    fetchCustomer();
  }, [id]);

  if (isLoading) {
    return (
      <div className="flex items-center justify-center min-h-[400px]">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-amber-500" />
      </div>
    );
  }

  if (!customer) {
    return (
      <div className="text-center py-12">
        <p className="text-slate-400">Customer not found</p>
        <Button onClick={() => router.back()} className="mt-4">
          Go Back
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Button
          variant="ghost"
          size="icon"
          onClick={() => router.back()}
          className="text-slate-400 hover:text-white"
        >
          <ArrowLeft className="h-5 w-5" />
        </Button>
        <div className="flex items-center gap-4">
          <div className="relative w-12 h-12 rounded-full overflow-hidden bg-slate-700">
            {customer.image ? (
              <Image src={customer.image} alt="" fill className="object-cover" />
            ) : (
              <div className="w-full h-full flex items-center justify-center">
                <User className="h-6 w-6 text-slate-400" />
              </div>
            )}
          </div>
          <div>
            <h1 className="text-2xl font-bold text-white">{customer.name}</h1>
            <p className="text-sm text-slate-400">
              Customer since {new Date(customer.createdAt).toLocaleDateString()}
            </p>
          </div>
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-3">
        {/* Main Content */}
        <div className="lg:col-span-2 space-y-6">
          {/* Order History */}
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden">
            <div className="p-4 border-b border-slate-700">
              <h2 className="font-semibold text-white">Order History</h2>
            </div>
            {customer.orders.length > 0 ? (
              <div className="divide-y divide-slate-700/50">
                {customer.orders.map((order) => (
                  <Link
                    key={order.id}
                    href={`/admin/orders/${order.id}`}
                    className="flex items-center justify-between p-4 hover:bg-slate-800/50 transition-colors"
                  >
                    <div className="flex items-center gap-4">
                      <div className="w-10 h-10 rounded-lg bg-slate-700 flex items-center justify-center">
                        <Package className="h-5 w-5 text-slate-400" />
                      </div>
                      <div>
                        <p className="text-sm font-medium text-white">
                          #{order.orderNumber}
                        </p>
                        <p className="text-xs text-slate-400">
                          {order.itemsCount} items • {new Date(order.createdAt).toLocaleDateString()}
                        </p>
                      </div>
                    </div>
                    <div className="flex items-center gap-4">
                      <span className="text-sm font-medium text-white">
                        {formatPrice(order.total)}
                      </span>
                      <span
                        className={cn(
                          "text-xs px-2 py-1 rounded-full capitalize",
                          statusColors[order.status] || statusColors.pending
                        )}
                      >
                        {order.status}
                      </span>
                    </div>
                  </Link>
                ))}
              </div>
            ) : (
              <div className="p-8 text-center">
                <ShoppingCart className="h-12 w-12 mx-auto text-slate-600 mb-3" />
                <p className="text-slate-400">No orders yet</p>
              </div>
            )}
          </div>
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* Stats */}
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-4 space-y-4">
            <h2 className="font-semibold text-white">Customer Stats</h2>
            <div className="grid grid-cols-2 gap-4">
              <div className="bg-slate-900/50 rounded-lg p-3">
                <p className="text-2xl font-bold text-amber-400">
                  {customer.ordersCount}
                </p>
                <p className="text-xs text-slate-400">Total Orders</p>
              </div>
              <div className="bg-slate-900/50 rounded-lg p-3">
                <p className="text-2xl font-bold text-green-400">
                  {formatPrice(customer.totalSpent)}
                </p>
                <p className="text-xs text-slate-400">Total Spent</p>
              </div>
            </div>
          </div>

          {/* Contact */}
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-4 space-y-3">
            <h2 className="font-semibold text-white">Contact Information</h2>
            <div className="space-y-3">
              <div className="flex items-center gap-2 text-sm">
                <Mail className="h-4 w-4 text-slate-400" />
                <a href={`mailto:${customer.email}`} className="text-amber-400 hover:underline">
                  {customer.email}
                </a>
              </div>
              {customer.phone && (
                <div className="flex items-center gap-2 text-sm">
                  <Phone className="h-4 w-4 text-slate-400" />
                  <a href={`tel:${customer.phone}`} className="text-amber-400 hover:underline">
                    {customer.phone}
                  </a>
                </div>
              )}
              <div className="flex items-center gap-2 text-sm">
                <Calendar className="h-4 w-4 text-slate-400" />
                <span className="text-slate-300">
                  Joined {new Date(customer.createdAt).toLocaleDateString()}
                </span>
              </div>
            </div>
          </div>

          {/* Address */}
          {customer.defaultAddress && (
            <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-4 space-y-3">
              <h2 className="font-semibold text-white">Default Address</h2>
              <div className="flex gap-2 text-sm">
                <MapPin className="h-4 w-4 text-slate-400 flex-shrink-0 mt-0.5" />
                <div className="text-slate-300">
                  {customer.defaultAddress.address && (
                    <p>{customer.defaultAddress.address}</p>
                  )}
                  {(customer.defaultAddress.district || customer.defaultAddress.division) && (
                    <p>
                      {customer.defaultAddress.district}
                      {customer.defaultAddress.district && customer.defaultAddress.division && ", "}
                      {customer.defaultAddress.division}
                    </p>
                  )}
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
