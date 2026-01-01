"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Download, Loader2 } from "lucide-react";
import { cn } from "@/lib/utils";

interface ExportButtonProps<T> {
  data: T[];
  filename: string;
  columns: {
    key: keyof T | ((item: T) => string | number);
    header: string;
  }[];
  className?: string;
}

export function ExportButton<T>({
  data,
  filename,
  columns,
  className,
}: ExportButtonProps<T>) {
  const [isExporting, setIsExporting] = useState(false);

  const handleExport = async () => {
    setIsExporting(true);
    try {
      // Build CSV content
      const headers = columns.map((col) => col.header).join(",");
      const rows = data.map((item) =>
        columns
          .map((col) => {
            const value =
              typeof col.key === "function"
                ? col.key(item)
                : item[col.key];
            // Escape quotes and wrap in quotes if contains comma
            const stringValue = String(value ?? "");
            if (stringValue.includes(",") || stringValue.includes('"')) {
              return `"${stringValue.replace(/"/g, '""')}"`;
            }
            return stringValue;
          })
          .join(",")
      );
      const csv = [headers, ...rows].join("\n");

      // Create and trigger download
      const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
      const link = document.createElement("a");
      link.href = URL.createObjectURL(blob);
      link.download = `${filename}_${new Date().toISOString().split("T")[0]}.csv`;
      link.click();
      URL.revokeObjectURL(link.href);
    } catch (error) {
      console.error("Export failed:", error);
    } finally {
      setIsExporting(false);
    }
  };

  return (
    <Button
      onClick={handleExport}
      disabled={isExporting || data.length === 0}
      variant="outline"
      className={cn(
        "bg-slate-800 border-slate-700 text-white hover:bg-slate-700",
        className
      )}
    >
      {isExporting ? (
        <Loader2 className="h-4 w-4 mr-2 animate-spin" />
      ) : (
        <Download className="h-4 w-4 mr-2" />
      )}
      Export CSV
    </Button>
  );
}
