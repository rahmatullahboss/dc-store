"use client";

import { useEffect, useState } from "react";
import { formatPrice } from "@/lib/config";
import { Button } from "@/components/ui/button";
import {
  DollarSign,
  ShoppingCart,
  Users,
  TrendingUp,
  Download,
  Loader2,
} from "lucide-react";
import { DateRangePicker, DateRangePreset } from "@/components/admin/date-range-picker";
import { RevenueChart } from "@/components/admin/revenue-chart";

interface Summary {
  totalRevenue: number;
  totalOrders: number;
  avgOrderValue: number;
  newCustomers: number;
}

interface RevenueDay {
  date: string;
  revenue: number;
  orders: number;
}

interface CategoryRevenue {
  name: string;
  revenue: number;
}

interface TopCustomer {
  customerName: string;
  customerEmail: string | null;
  totalSpent: number;
  orderCount: number;
}

interface ReportsData {
  summary: Summary;
  revenueByDay: RevenueDay[];
  revenueByCategory: CategoryRevenue[];
  topCustomers: TopCustomer[];
}

const presetToDays: Record<DateRangePreset, number> = {
  today: 1,
  "7days": 7,
  "30days": 30,
  "90days": 90,
  year: 365,
  all: 9999,
};

export default function AdminReportsPage() {
  const [summary, setSummary] = useState<Summary | null>(null);
  const [revenueByDay, setRevenueByDay] = useState<RevenueDay[]>([]);
  const [revenueByCategory, setRevenueByCategory] = useState<CategoryRevenue[]>([]);
  const [topCustomers, setTopCustomers] = useState<TopCustomer[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isExporting, setIsExporting] = useState(false);
  const [dateRange, setDateRange] = useState<DateRangePreset>("30days");

  useEffect(() => {
    async function fetchReports() {
      setIsLoading(true);
      try {
        const days = presetToDays[dateRange];
        const res = await fetch(`/api/admin/reports?days=${days}`);
        if (res.ok) {
          const data = await res.json() as ReportsData;
          setSummary(data.summary);
          setRevenueByDay(data.revenueByDay || []);
          setRevenueByCategory(data.revenueByCategory || []);
          setTopCustomers(data.topCustomers || []);
        }
      } catch (error) {
        console.error("Failed to fetch reports:", error);
      } finally {
        setIsLoading(false);
      }
    }
    fetchReports();
  }, [dateRange]);

  const handleExport = () => {
    setIsExporting(true);
    try {
      const lines = [
        "Date,Revenue,Orders",
        ...revenueByDay.map((d) => `${d.date},${d.revenue},${d.orders}`),
      ];
      const csv = lines.join("\n");
      const blob = new Blob([csv], { type: "text/csv" });
      const url = URL.createObjectURL(blob);
      const link = document.createElement("a");
      link.href = url;
      link.download = `sales-report-${dateRange}.csv`;
      link.click();
      URL.revokeObjectURL(url);
    } finally {
      setIsExporting(false);
    }
  };

  const maxCategoryRevenue = Math.max(...revenueByCategory.map((c) => c.revenue), 1);

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <Loader2 className="h-8 w-8 animate-spin text-amber-400" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <h1 className="text-2xl font-bold text-white">Sales Reports</h1>
        <div className="flex gap-2">
          <DateRangePicker value={dateRange} onChange={setDateRange} />
          <Button
            onClick={handleExport}
            disabled={isExporting || revenueByDay.length === 0}
            variant="outline"
            className="bg-slate-800 border-slate-700 text-white hover:bg-slate-700"
          >
            {isExporting ? (
              <Loader2 className="h-4 w-4 mr-2 animate-spin" />
            ) : (
              <Download className="h-4 w-4 mr-2" />
            )}
            Export CSV
          </Button>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
          <div className="flex items-center gap-3 mb-2">
            <div className="p-2 rounded-lg bg-green-500/20">
              <DollarSign className="h-5 w-5 text-green-400" />
            </div>
            <span className="text-sm text-slate-400">Total Revenue</span>
          </div>
          <p className="text-2xl font-bold text-white">
            {formatPrice(summary?.totalRevenue || 0)}
          </p>
        </div>

        <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
          <div className="flex items-center gap-3 mb-2">
            <div className="p-2 rounded-lg bg-blue-500/20">
              <ShoppingCart className="h-5 w-5 text-blue-400" />
            </div>
            <span className="text-sm text-slate-400">Total Orders</span>
          </div>
          <p className="text-2xl font-bold text-white">
            {summary?.totalOrders || 0}
          </p>
        </div>

        <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
          <div className="flex items-center gap-3 mb-2">
            <div className="p-2 rounded-lg bg-purple-500/20">
              <TrendingUp className="h-5 w-5 text-purple-400" />
            </div>
            <span className="text-sm text-slate-400">Avg. Order Value</span>
          </div>
          <p className="text-2xl font-bold text-white">
            {formatPrice(summary?.avgOrderValue || 0)}
          </p>
        </div>

        <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
          <div className="flex items-center gap-3 mb-2">
            <div className="p-2 rounded-lg bg-amber-500/20">
              <Users className="h-5 w-5 text-amber-400" />
            </div>
            <span className="text-sm text-slate-400">New Customers</span>
          </div>
          <p className="text-2xl font-bold text-white">
            {summary?.newCustomers || 0}
          </p>
        </div>
      </div>

      {/* Charts Row */}
      <div className="grid gap-6 lg:grid-cols-2">
        {/* Revenue Chart */}
        <RevenueChart data={revenueByDay} title="Revenue Over Time" />

        {/* Revenue by Category */}
        <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
          <h2 className="text-lg font-semibold text-white mb-4">Revenue by Category</h2>
          {revenueByCategory.length > 0 ? (
            <div className="space-y-3">
              {revenueByCategory.slice(0, 6).map((cat, i) => (
                <div key={i} className="flex items-center gap-3">
                  <span className="text-sm text-slate-300 w-28 truncate">
                    {cat.name}
                  </span>
                  <div className="flex-1 h-3 bg-slate-700 rounded-full overflow-hidden">
                    <div
                      className="h-full bg-gradient-to-r from-green-500 to-emerald-400 rounded-full"
                      style={{ width: `${(cat.revenue / maxCategoryRevenue) * 100}%` }}
                    />
                  </div>
                  <span className="text-sm text-white w-24 text-right">
                    {formatPrice(cat.revenue)}
                  </span>
                </div>
              ))}
            </div>
          ) : (
            <div className="h-40 flex items-center justify-center text-slate-500">
              No category data
            </div>
          )}
        </div>
      </div>

      {/* Top Customers */}
      <div className="bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden">
        <div className="p-4 border-b border-slate-700">
          <h2 className="text-lg font-semibold text-white">Top Customers</h2>
        </div>
        {topCustomers.length > 0 ? (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-slate-700">
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Customer
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Orders
                  </th>
                  <th className="text-right text-xs font-medium text-slate-400 py-3 px-4">
                    Total Spent
                  </th>
                </tr>
              </thead>
              <tbody>
                {topCustomers.map((customer, i) => (
                  <tr
                    key={i}
                    className="border-b border-slate-700/50 hover:bg-slate-800/50"
                  >
                    <td className="py-3 px-4">
                      <div>
                        <p className="text-sm font-medium text-white">
                          {customer.customerName}
                        </p>
                        {customer.customerEmail && (
                          <p className="text-xs text-slate-400">
                            {customer.customerEmail}
                          </p>
                        )}
                      </div>
                    </td>
                    <td className="py-3 px-4 text-sm text-slate-300">
                      {customer.orderCount}
                    </td>
                    <td className="py-3 px-4 text-right">
                      <span className="text-sm font-medium text-green-400">
                        {formatPrice(customer.totalSpent)}
                      </span>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="p-8 text-center text-slate-500">No customer data</div>
        )}
      </div>
    </div>
  );
}
