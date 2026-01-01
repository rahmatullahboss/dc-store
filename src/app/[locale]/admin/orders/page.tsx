"use client";

import { useEffect, useState } from "react";
import { Link } from "@/i18n/routing";
import { formatPrice } from "@/lib/config";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Search, Eye, ShoppingCart } from "lucide-react";
import { cn } from "@/lib/utils";
import { Pagination } from "@/components/admin/pagination";
import { ExportButton } from "@/components/admin/export-button";

interface Order {
  id: string;
  orderNumber: string;
  customerName: string;
  customerEmail: string | null;
  customerPhone: string;
  status: string;
  paymentStatus: string;
  total: number;
  createdAt: string;
}

const statusColors: Record<string, string> = {
  pending: "bg-yellow-500/20 text-yellow-400",
  confirmed: "bg-blue-500/20 text-blue-400",
  processing: "bg-purple-500/20 text-purple-400",
  shipped: "bg-cyan-500/20 text-cyan-400",
  delivered: "bg-green-500/20 text-green-400",
  cancelled: "bg-red-500/20 text-red-400",
  refunded: "bg-slate-500/20 text-slate-400",
};

const paymentColors: Record<string, string> = {
  pending: "text-yellow-400",
  paid: "text-green-400",
  failed: "text-red-400",
  refunded: "text-slate-400",
};

const ITEMS_PER_PAGE = 20;

export default function AdminOrdersPage() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [status, setStatus] = useState("all");
  const [search, setSearch] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  const fetchOrders = async (page = 1) => {
    setIsLoading(true);
    try {
      const params = new URLSearchParams();
      if (status && status !== "all") params.set("status", status);
      if (search) params.set("search", search);
      params.set("page", String(page));
      params.set("limit", String(ITEMS_PER_PAGE));
      
      const res = await fetch(`/api/admin/orders?${params}`);
      if (res.ok) {
        const data = await res.json() as { orders: Order[]; total?: number; totalPages?: number };
        setOrders(data.orders || []);
        if (data.totalPages) {
          setTotalPages(data.totalPages);
        } else if (data.total) {
          setTotalPages(Math.ceil(data.total / ITEMS_PER_PAGE));
        }
        setCurrentPage(page);
      }
    } catch (error) {
      console.error("Failed to fetch orders:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchOrders(1);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [status]);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    fetchOrders(1);
  };

  const handlePageChange = (page: number) => {
    fetchOrders(page);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <h1 className="text-2xl font-bold text-white">Orders</h1>
        <ExportButton
          data={orders}
          filename="orders"
          columns={[
            { key: "orderNumber", header: "Order #" },
            { key: "customerName", header: "Customer" },
            { key: "customerPhone", header: "Phone" },
            { key: "total", header: "Total" },
            { key: "status", header: "Status" },
            { key: "paymentStatus", header: "Payment" },
            { key: (o) => new Date(o.createdAt).toLocaleDateString(), header: "Date" },
          ]}
        />
      </div>

      {/* Status Tabs */}
      <Tabs value={status} onValueChange={setStatus}>
        <TabsList className="bg-slate-800 border border-slate-700">
          <TabsTrigger value="all" className="data-[state=active]:bg-amber-500/20 data-[state=active]:text-amber-400">
            All
          </TabsTrigger>
          <TabsTrigger value="pending" className="data-[state=active]:bg-amber-500/20 data-[state=active]:text-amber-400">
            Pending
          </TabsTrigger>
          <TabsTrigger value="confirmed" className="data-[state=active]:bg-amber-500/20 data-[state=active]:text-amber-400">
            Confirmed
          </TabsTrigger>
          <TabsTrigger value="shipped" className="data-[state=active]:bg-amber-500/20 data-[state=active]:text-amber-400">
            Shipped
          </TabsTrigger>
          <TabsTrigger value="delivered" className="data-[state=active]:bg-amber-500/20 data-[state=active]:text-amber-400">
            Delivered
          </TabsTrigger>
        </TabsList>
      </Tabs>

      {/* Search */}
      <form onSubmit={handleSearch} className="flex gap-2 max-w-md">
        <Input
          placeholder="Search by order # or customer..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="bg-slate-800 border-slate-700 text-white placeholder:text-slate-400"
        />
        <Button type="submit" variant="secondary" className="bg-slate-700 hover:bg-slate-600">
          <Search className="h-4 w-4" />
        </Button>
      </form>

      {/* Orders Table */}
      <div className="bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden">
        {isLoading ? (
          <div className="p-8 text-center text-slate-400">Loading...</div>
        ) : orders.length === 0 ? (
          <div className="p-8 text-center">
            <ShoppingCart className="h-12 w-12 mx-auto text-slate-600 mb-3" />
            <p className="text-slate-400">No orders found</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-slate-700">
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Order
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Customer
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Date
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Total
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Payment
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
                {orders.map((order) => (
                  <tr
                    key={order.id}
                    className="border-b border-slate-700/50 hover:bg-slate-800/50"
                  >
                    <td className="py-3 px-4">
                      <span className="text-sm font-medium text-white">
                        #{order.orderNumber}
                      </span>
                    </td>
                    <td className="py-3 px-4">
                      <div>
                        <p className="text-sm text-white">{order.customerName}</p>
                        <p className="text-xs text-slate-400">{order.customerPhone}</p>
                      </div>
                    </td>
                    <td className="py-3 px-4 text-sm text-slate-400">
                      {new Date(order.createdAt).toLocaleDateString()}
                    </td>
                    <td className="py-3 px-4 text-sm font-medium text-white">
                      {formatPrice(order.total)}
                    </td>
                    <td className="py-3 px-4">
                      <span
                        className={cn(
                          "text-xs capitalize",
                          paymentColors[order.paymentStatus] || paymentColors.pending
                        )}
                      >
                        {order.paymentStatus}
                      </span>
                    </td>
                    <td className="py-3 px-4">
                      <span
                        className={cn(
                          "text-xs px-2 py-1 rounded-full capitalize",
                          statusColors[order.status] || statusColors.pending
                        )}
                      >
                        {order.status}
                      </span>
                    </td>
                    <td className="py-3 px-4 text-right">
                      <Button
                        asChild
                        variant="ghost"
                        size="icon"
                        className="text-slate-400 hover:text-white"
                      >
                        <Link href={`/admin/orders/${order.id}`}>
                          <Eye className="h-4 w-4" />
                        </Link>
                      </Button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <Pagination
          currentPage={currentPage}
          totalPages={totalPages}
          onPageChange={handlePageChange}
        />
      )}
    </div>
  );
}
