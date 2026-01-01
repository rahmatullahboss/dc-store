"use client";

import { useEffect, useState } from "react";
import { StatCard } from "@/components/admin/stat-card";
import { formatPrice } from "@/lib/config";
import {
  DollarSign,
  ShoppingCart,
  Package,
  Users,
  Plus,
  ArrowRight,
  Bell,
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Link } from "@/i18n/routing";
import { cn } from "@/lib/utils";
import { DateRangePicker, DateRangePreset, getDateRangeFromPreset } from "@/components/admin/date-range-picker";
import { LowStockAlert } from "@/components/admin/low-stock-alert";
import { TopProductsWidget } from "@/components/admin/top-products-widget";
import { RevenueChart } from "@/components/admin/revenue-chart";

interface Stats {
  totalRevenue: number;
  ordersToday: number;
  pendingOrders: number;
  activeProducts: number;
  totalUsers: number;
}

interface RecentOrder {
  id: string;
  orderNumber: string;
  customerName: string;
  total: number;
  status: string;
  createdAt: string;
}

interface RevenueDay {
  date: string;
  revenue: number;
}

interface TopProduct {
  id: string;
  name: string;
  featuredImage: string | null;
  totalSold: number;
  revenue: number;
}

interface LowStockProduct {
  id: string;
  name: string;
  quantity: number;
  featuredImage: string | null;
}

const statusColors: Record<string, string> = {
  pending: "bg-yellow-500/20 text-yellow-400",
  confirmed: "bg-blue-500/20 text-blue-400",
  processing: "bg-purple-500/20 text-purple-400",
  shipped: "bg-cyan-500/20 text-cyan-400",
  delivered: "bg-green-500/20 text-green-400",
  cancelled: "bg-red-500/20 text-red-400",
  refunded: "bg-muted0/20 text-muted-foreground",
};

export default function AdminDashboard() {
  const [stats, setStats] = useState<Stats | null>(null);
  const [recentOrders, setRecentOrders] = useState<RecentOrder[]>([]);
  const [revenueByDay, setRevenueByDay] = useState<RevenueDay[]>([]);
  const [topProducts, setTopProducts] = useState<TopProduct[]>([]);
  const [lowStockProducts, setLowStockProducts] = useState<LowStockProduct[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [dateRange, setDateRange] = useState<DateRangePreset>("7days");

  useEffect(() => {
    async function fetchStats() {
      try {
        const range = getDateRangeFromPreset(dateRange);
        const params = new URLSearchParams();
        if (range.from) {
          params.set("dateFrom", range.from.toISOString());
          params.set("dateTo", range.to.toISOString());
        }
        
        // Set days for chart based on preset
        const daysMap: Record<DateRangePreset, string> = {
          today: "1",
          "7days": "7",
          "30days": "30",
          "90days": "90",
          year: "365",
          all: "30",
        };
        params.set("days", daysMap[dateRange]);

        const res = await fetch(`/api/admin/stats?${params}`);
        if (res.ok) {
          const data = await res.json() as {
            stats: Stats;
            recentOrders: RecentOrder[];
            revenueByDay: RevenueDay[];
            topProducts: TopProduct[];
            lowStockProducts: LowStockProduct[];
          };
          setStats(data.stats);
          setRecentOrders(data.recentOrders || []);
          setRevenueByDay(data.revenueByDay || []);
          setTopProducts(data.topProducts || []);
          setLowStockProducts(data.lowStockProducts || []);
        }
      } catch (error) {
        console.error("Failed to fetch stats:", error);
      } finally {
        setIsLoading(false);
      }
    }
    fetchStats();
  }, [dateRange]);

  if (isLoading) {
    return (
      <div className="space-y-6">
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          {[...Array(4)].map((_, i) => (
            <div
              key={i}
              className="bg-slate-800/50 border border-slate-700 rounded-xl p-6 animate-pulse"
            >
              <div className="h-4 bg-slate-700 rounded w-1/3 mb-2" />
              <div className="h-8 bg-slate-700 rounded w-1/2" />
            </div>
          ))}
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Page Title with Date Range */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <div className="flex items-center gap-4">
          <h1 className="text-2xl font-bold text-white">Dashboard Overview</h1>
          {(stats?.pendingOrders ?? 0) > 0 && (
            <Link
              href="/admin/orders?status=pending"
              className="flex items-center gap-1 px-2 py-1 bg-yellow-500/20 text-yellow-400 rounded-full text-xs hover:bg-yellow-500/30 transition-colors"
            >
              <Bell className="h-3 w-3" />
              {stats?.pendingOrders} pending
            </Link>
          )}
        </div>
        <div className="flex gap-2">
          <DateRangePicker value={dateRange} onChange={setDateRange} />
          <Button asChild className="bg-primary hover:bg-amber-600 text-black">
            <Link href="/admin/products/new">
              <Plus className="h-4 w-4 mr-2" />
              Add Product
            </Link>
          </Button>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <StatCard
          title="Total Revenue"
          value={formatPrice(stats?.totalRevenue || 0)}
          icon={DollarSign}
        />
        <StatCard
          title="Orders Today"
          value={stats?.ordersToday || 0}
          icon={ShoppingCart}
        />
        <StatCard
          title="Active Products"
          value={stats?.activeProducts || 0}
          icon={Package}
        />
        <StatCard
          title="Total Users"
          value={stats?.totalUsers || 0}
          icon={Users}
        />
      </div>

      {/* Main Content Grid */}
      <div className="grid gap-6 lg:grid-cols-3">
        {/* Revenue Chart - Takes 2 columns */}
        <div className="lg:col-span-2">
          <RevenueChart
            data={revenueByDay}
            title={`Revenue (${dateRange === "today" ? "Today" : `Last ${dateRange === "year" ? "Year" : dateRange.replace("days", " Days")}`})`}
          />
        </div>

        {/* Top Products Widget */}
        <TopProductsWidget products={topProducts} />
      </div>

      {/* Low Stock Alert */}
      {lowStockProducts.length > 0 && (
        <LowStockAlert products={lowStockProducts} />
      )}

      {/* Recent Orders */}
      <div className="bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden">
        <div className="p-4 border-b border-slate-700 flex items-center justify-between">
          <h2 className="text-lg font-semibold text-white">Recent Orders</h2>
          <Link
            href="/admin/orders"
            className="text-sm text-amber-400 hover:text-amber-300 flex items-center gap-1"
          >
            View All <ArrowRight className="h-4 w-4" />
          </Link>
        </div>
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
                  Status
                </th>
              </tr>
            </thead>
            <tbody>
              {recentOrders.length > 0 ? (
                recentOrders.map((order) => (
                  <tr
                    key={order.id}
                    className="border-b border-slate-700/50 hover:bg-slate-800/50"
                  >
                    <td className="py-3 px-4">
                      <Link
                        href={`/admin/orders/${order.id}`}
                        className="text-sm font-medium text-white hover:text-amber-400"
                      >
                        #{order.orderNumber}
                      </Link>
                    </td>
                    <td className="py-3 px-4 text-sm text-slate-300">
                      {order.customerName}
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
                          "text-xs px-2 py-1 rounded-full capitalize",
                          statusColors[order.status] || statusColors.pending
                        )}
                      >
                        {order.status}
                      </span>
                    </td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td
                    colSpan={5}
                    className="py-8 text-center text-slate-500"
                  >
                    No orders yet
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="grid gap-4 md:grid-cols-3">
        <Link
          href="/admin/products"
          className="bg-slate-800/50 border border-slate-700 rounded-xl p-6 hover:border-amber-500/50 transition-colors group"
        >
          <Package className="h-8 w-8 text-amber-400 mb-3" />
          <h3 className="font-semibold text-white group-hover:text-amber-400 transition-colors">
            Manage Products
          </h3>
          <p className="text-sm text-slate-400 mt-1">
            Add, edit, or remove products
          </p>
        </Link>
        <Link
          href="/admin/orders"
          className="bg-slate-800/50 border border-slate-700 rounded-xl p-6 hover:border-amber-500/50 transition-colors group"
        >
          <ShoppingCart className="h-8 w-8 text-amber-400 mb-3" />
          <h3 className="font-semibold text-white group-hover:text-amber-400 transition-colors">
            View Orders
          </h3>
          <p className="text-sm text-slate-400 mt-1">
            Process and track orders
          </p>
        </Link>
        <Link
          href="/admin/customers"
          className="bg-slate-800/50 border border-slate-700 rounded-xl p-6 hover:border-amber-500/50 transition-colors group"
        >
          <Users className="h-8 w-8 text-amber-400 mb-3" />
          <h3 className="font-semibold text-white group-hover:text-amber-400 transition-colors">
            Customers
          </h3>
          <p className="text-sm text-slate-400 mt-1">
            View customer information
          </p>
        </Link>
      </div>
    </div>
  );
}
