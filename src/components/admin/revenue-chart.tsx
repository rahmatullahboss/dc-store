"use client";

import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
} from "recharts";
import { formatPrice } from "@/lib/config";

interface RevenueChartProps {
  data: { date: string; revenue: number }[];
  title?: string;
}

interface TooltipProps {
  active?: boolean;
  payload?: { value: number }[];
  label?: string;
}

const CustomTooltip = ({ active, payload, label }: TooltipProps) => {
  if (active && payload && payload.length) {
    return (
      <div className="bg-slate-900 border border-slate-700 rounded-lg p-3 shadow-xl">
        <p className="text-slate-400 text-sm mb-1">{label}</p>
        <p className="text-amber-400 font-semibold">
          {formatPrice(payload[0].value)}
        </p>
      </div>
    );
  }
  return null;
};

export function RevenueChart({ data, title }: RevenueChartProps) {
  // Detect if data is hourly (format: "00:00") or daily (format: "2026-01-01")
  const isHourlyData = data.length > 0 && data[0].date.includes(":");
  
  const chartData = data.map((item) => ({
    ...item,
    // For hourly, use the time directly; for daily, format as "Jan 1"
    displayDate: isHourlyData 
      ? item.date 
      : new Date(item.date).toLocaleDateString("en", { 
          month: "short", 
          day: "numeric" 
        }),
  }));

  const maxRevenue = Math.max(...data.map((d) => d.revenue), 100);

  return (
    <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
      {title && (
        <h2 className="text-lg font-semibold text-white mb-4">{title}</h2>
      )}
      <div className="h-64">
        <ResponsiveContainer width="100%" height="100%">
          <BarChart
            data={chartData}
            margin={{ top: 10, right: 10, left: 10, bottom: 5 }}
          >
            <defs>
              <linearGradient id="revenueGradient" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#f59e0b" stopOpacity={1} />
                <stop offset="100%" stopColor="#d97706" stopOpacity={0.8} />
              </linearGradient>
            </defs>
            <CartesianGrid
              strokeDasharray="3 3"
              stroke="#334155"
              vertical={false}
            />
            <XAxis
              dataKey="displayDate"
              axisLine={false}
              tickLine={false}
              tick={{ fill: "#94a3b8", fontSize: 10 }}
            />
            <YAxis
              axisLine={false}
              tickLine={false}
              tick={{ fill: "#94a3b8", fontSize: 12 }}
              tickFormatter={(value) =>
                value >= 1000 ? `${(value / 1000).toFixed(0)}k` : value
              }
              domain={[0, maxRevenue * 1.1]}
            />
            <Tooltip
              content={<CustomTooltip />}
              cursor={{ fill: "rgba(148, 163, 184, 0.1)" }}
            />
            <Bar
              dataKey="revenue"
              fill="url(#revenueGradient)"
              radius={[4, 4, 0, 0]}
              maxBarSize={60}
            />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}
