import { cn } from "@/lib/utils";
import { LucideIcon } from "lucide-react";

interface StatCardProps {
  title: string;
  value: string | number;
  icon: LucideIcon;
  trend?: {
    value: number;
    isPositive: boolean;
  };
  className?: string;
}

export function StatCard({ title, value, icon: Icon, trend, className }: StatCardProps) {
  return (
    <div
      className={cn(
        "bg-slate-800/50 border border-slate-700 rounded-xl p-6",
        className
      )}
    >
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-slate-400">{title}</p>
          <p className="text-2xl font-bold text-white mt-1">{value}</p>
          {trend && (
            <p
              className={cn(
                "text-xs mt-2",
                trend.isPositive ? "text-green-400" : "text-red-400"
              )}
            >
              {trend.isPositive ? "+" : "-"}{Math.abs(trend.value)}% from last period
            </p>
          )}
        </div>
        <div className="h-12 w-12 rounded-lg bg-primary/20 flex items-center justify-center">
          <Icon className="h-6 w-6 text-amber-400" />
        </div>
      </div>
    </div>
  );
}
