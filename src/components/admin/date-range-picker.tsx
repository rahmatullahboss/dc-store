"use client";

import { Button } from "@/components/ui/button";
import { Calendar, ChevronDown } from "lucide-react";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { cn } from "@/lib/utils";

export type DateRangePreset = "today" | "7days" | "30days" | "90days" | "year" | "all";

interface DateRangePickerProps {
  value: DateRangePreset;
  onChange: (preset: DateRangePreset) => void;
  className?: string;
}

const presets: { value: DateRangePreset; label: string }[] = [
  { value: "today", label: "Today" },
  { value: "7days", label: "Last 7 Days" },
  { value: "30days", label: "Last 30 Days" },
  { value: "90days", label: "Last 90 Days" },
  { value: "year", label: "This Year" },
  { value: "all", label: "All Time" },
];

export function DateRangePicker({
  value,
  onChange,
  className,
}: DateRangePickerProps) {
  const currentLabel = presets.find((p) => p.value === value)?.label || "Select Range";

  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <Button
          variant="outline"
          className={cn(
            "bg-slate-800 border-slate-700 text-white hover:bg-slate-700",
            className
          )}
        >
          <Calendar className="h-4 w-4 mr-2 text-slate-400" />
          {currentLabel}
          <ChevronDown className="h-4 w-4 ml-2 text-slate-400" />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end" className="bg-slate-800 border-slate-700">
        {presets.map((preset) => (
          <DropdownMenuItem
            key={preset.value}
            onClick={() => onChange(preset.value)}
            className={cn(
              "cursor-pointer",
              value === preset.value
                ? "bg-primary/20 text-amber-400"
                : "text-slate-300"
            )}
          >
            {preset.label}
          </DropdownMenuItem>
        ))}
      </DropdownMenuContent>
    </DropdownMenu>
  );
}

// Helper function to get date range from preset
export function getDateRangeFromPreset(preset: DateRangePreset): {
  from: Date | null;
  to: Date;
} {
  const now = new Date();
  const to = new Date(now);
  to.setHours(23, 59, 59, 999);

  switch (preset) {
    case "today":
      const todayStart = new Date(now);
      todayStart.setHours(0, 0, 0, 0);
      return { from: todayStart, to };
    case "7days":
      const sevenDaysAgo = new Date(now);
      sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);
      sevenDaysAgo.setHours(0, 0, 0, 0);
      return { from: sevenDaysAgo, to };
    case "30days":
      const thirtyDaysAgo = new Date(now);
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      thirtyDaysAgo.setHours(0, 0, 0, 0);
      return { from: thirtyDaysAgo, to };
    case "90days":
      const ninetyDaysAgo = new Date(now);
      ninetyDaysAgo.setDate(ninetyDaysAgo.getDate() - 90);
      ninetyDaysAgo.setHours(0, 0, 0, 0);
      return { from: ninetyDaysAgo, to };
    case "year":
      const startOfYear = new Date(now.getFullYear(), 0, 1);
      return { from: startOfYear, to };
    case "all":
    default:
      return { from: null, to };
  }
}
