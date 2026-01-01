"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { useRouter } from "@/i18n/routing";
import { formatPrice } from "@/lib/config";
import { Button } from "@/components/ui/button";
import { ArrowLeft, Package, MapPin, Phone, Mail, User } from "lucide-react";
import { cn } from "@/lib/utils";
import Image from "next/image";

interface OrderItem {
  productId: string;
  name: string;
  price: number;
  quantity: number;
  image?: string;
  total: number;
}

interface Address {
  name: string;
  phone: string;
  address: string;
  city: string;
  country: string;
}

interface Order {
  id: string;
  orderNumber: string;
  customerName: string;
  customerEmail: string | null;
  customerPhone: string;
  status: string;
  paymentStatus: string;
  paymentMethod: string | null;
  subtotal: number;
  discount: number;
  shippingCost: number;
  tax: number;
  total: number;
  shippingAddress: Address | null;
  notes: string | null;
  items: OrderItem[];
  createdAt: string;
}

const orderStatuses = [
  "pending",
  "confirmed",
  "processing",
  "shipped",
  "delivered",
  "cancelled",
];

const statusColors: Record<string, string> = {
  pending: "bg-yellow-500/20 text-yellow-400 border-yellow-500/30",
  confirmed: "bg-blue-500/20 text-blue-400 border-blue-500/30",
  processing: "bg-purple-500/20 text-purple-400 border-purple-500/30",
  shipped: "bg-cyan-500/20 text-cyan-400 border-cyan-500/30",
  delivered: "bg-green-500/20 text-green-400 border-green-500/30",
  cancelled: "bg-red-500/20 text-red-400 border-red-500/30",
};

export default function OrderDetailPage() {
  const params = useParams();
  const router = useRouter();
  const [order, setOrder] = useState<Order | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);

  useEffect(() => {
    async function fetchOrder() {
      try {
        const res = await fetch(`/api/admin/orders/${params.id}`);
        if (res.ok) {
          const data = await res.json() as { order: Order };
          setOrder(data.order);
        }
      } catch (error) {
        console.error("Failed to fetch order:", error);
      } finally {
        setIsLoading(false);
      }
    }
    if (params.id) fetchOrder();
  }, [params.id]);

  const updateStatus = async (newStatus: string) => {
    if (!order) return;
    setIsSaving(true);
    try {
      const res = await fetch(`/api/admin/orders/${order.id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status: newStatus }),
      });
      if (res.ok) {
        setOrder({ ...order, status: newStatus });
      }
    } catch (error) {
      console.error("Failed to update status:", error);
    } finally {
      setIsSaving(false);
    }
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-amber-500" />
      </div>
    );
  }

  if (!order) {
    return (
      <div className="text-center py-12">
        <p className="text-slate-400">Order not found</p>
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
        <div>
          <h1 className="text-2xl font-bold text-white">
            Order #{order.orderNumber}
          </h1>
          <p className="text-sm text-slate-400">
            {new Date(order.createdAt).toLocaleString()}
          </p>
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-3">
        {/* Order Items */}
        <div className="lg:col-span-2 space-y-6">
          {/* Items */}
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden">
            <div className="p-4 border-b border-slate-700">
              <h2 className="font-semibold text-white">Order Items</h2>
            </div>
            <div className="divide-y divide-slate-700/50">
              {order.items.map((item, i) => (
                <div key={i} className="p-4 flex gap-4">
                  <div className="relative w-16 h-16 rounded-lg overflow-hidden bg-slate-700 flex-shrink-0">
                    {item.image ? (
                      <Image
                        src={item.image}
                        alt={item.name}
                        fill
                        className="object-cover"
                      />
                    ) : (
                      <div className="w-full h-full flex items-center justify-center">
                        <Package className="h-6 w-6 text-slate-500" />
                      </div>
                    )}
                  </div>
                  <div className="flex-1">
                    <p className="font-medium text-white">{item.name}</p>
                    <p className="text-sm text-slate-400">
                      {formatPrice(item.price)} × {item.quantity}
                    </p>
                  </div>
                  <p className="font-medium text-white">
                    {formatPrice(item.total)}
                  </p>
                </div>
              ))}
            </div>

            {/* Totals */}
            <div className="p-4 border-t border-slate-700 space-y-2">
              <div className="flex justify-between text-sm">
                <span className="text-slate-400">Subtotal</span>
                <span className="text-white">{formatPrice(order.subtotal)}</span>
              </div>
              {order.discount > 0 && (
                <div className="flex justify-between text-sm">
                  <span className="text-slate-400">Discount</span>
                  <span className="text-green-400">
                    -{formatPrice(order.discount)}
                  </span>
                </div>
              )}
              <div className="flex justify-between text-sm">
                <span className="text-slate-400">Shipping</span>
                <span className="text-white">
                  {formatPrice(order.shippingCost)}
                </span>
              </div>
              <div className="flex justify-between font-semibold pt-2 border-t border-slate-700">
                <span className="text-white">Total</span>
                <span className="text-amber-400">{formatPrice(order.total)}</span>
              </div>
            </div>
          </div>

          {/* Notes */}
          {order.notes && (
            <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-4">
              <h2 className="font-semibold text-white mb-2">Order Notes</h2>
              <p className="text-sm text-slate-300">{order.notes}</p>
            </div>
          )}
        </div>

        {/* Sidebar */}
        <div className="space-y-6">
          {/* Status */}
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-4">
            <h2 className="font-semibold text-white mb-4">Order Status</h2>
            <div className="space-y-2">
              {orderStatuses.map((status) => (
                <button
                  key={status}
                  onClick={() => updateStatus(status)}
                  disabled={isSaving || order.status === status}
                  className={cn(
                    "w-full text-left px-3 py-2 rounded-lg text-sm capitalize border transition-colors",
                    order.status === status
                      ? statusColors[status]
                      : "border-slate-700 text-slate-400 hover:border-slate-600"
                  )}
                >
                  {status}
                </button>
              ))}
            </div>
          </div>

          {/* Customer */}
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-4">
            <h2 className="font-semibold text-white mb-4">Customer</h2>
            <div className="space-y-3">
              <div className="flex items-center gap-2 text-sm">
                <User className="h-4 w-4 text-slate-400" />
                <span className="text-white">{order.customerName}</span>
              </div>
              <div className="flex items-center gap-2 text-sm">
                <Phone className="h-4 w-4 text-slate-400" />
                <a
                  href={`tel:${order.customerPhone}`}
                  className="text-amber-400 hover:underline"
                >
                  {order.customerPhone}
                </a>
              </div>
              {order.customerEmail && (
                <div className="flex items-center gap-2 text-sm">
                  <Mail className="h-4 w-4 text-slate-400" />
                  <a
                    href={`mailto:${order.customerEmail}`}
                    className="text-amber-400 hover:underline"
                  >
                    {order.customerEmail}
                  </a>
                </div>
              )}
            </div>
          </div>

          {/* Shipping Address */}
          {order.shippingAddress && (
            <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-4">
              <h2 className="font-semibold text-white mb-4">Shipping Address</h2>
              <div className="flex gap-2 text-sm">
                <MapPin className="h-4 w-4 text-slate-400 flex-shrink-0 mt-0.5" />
                <div className="text-slate-300">
                  <p>{order.shippingAddress.name}</p>
                  <p>{order.shippingAddress.address}</p>
                  <p>
                    {order.shippingAddress.city}, {order.shippingAddress.country}
                  </p>
                </div>
              </div>
            </div>
          )}

          {/* Payment */}
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-4">
            <h2 className="font-semibold text-white mb-4">Payment</h2>
            <div className="space-y-2 text-sm">
              <div className="flex justify-between">
                <span className="text-slate-400">Status</span>
                <span
                  className={cn(
                    "capitalize",
                    order.paymentStatus === "paid"
                      ? "text-green-400"
                      : "text-yellow-400"
                  )}
                >
                  {order.paymentStatus}
                </span>
              </div>
              {order.paymentMethod && (
                <div className="flex justify-between">
                  <span className="text-slate-400">Method</span>
                  <span className="text-white capitalize">
                    {order.paymentMethod}
                  </span>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
