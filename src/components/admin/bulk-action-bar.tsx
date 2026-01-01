"use client";

import { Button } from "@/components/ui/button";
import { X, Loader2 } from "lucide-react";
import { cn } from "@/lib/utils";

interface BulkActionBarProps {
  selectedCount: number;
  onClearSelection: () => void;
  actions: {
    label: string;
    icon?: React.ReactNode;
    onClick: () => void;
    variant?: "default" | "destructive";
    isLoading?: boolean;
  }[];
  className?: string;
}

export function BulkActionBar({
  selectedCount,
  onClearSelection,
  actions,
  className,
}: BulkActionBarProps) {
  if (selectedCount === 0) return null;

  return (
    <div
      className={cn(
        "fixed bottom-4 left-1/2 -translate-x-1/2 z-50",
        "bg-slate-900 border border-slate-700 rounded-xl px-4 py-3 shadow-2xl",
        "flex items-center gap-4",
        className
      )}
    >
      <div className="flex items-center gap-2">
        <span className="text-sm text-white font-medium">
          {selectedCount} selected
        </span>
        <Button
          variant="ghost"
          size="icon"
          onClick={onClearSelection}
          className="h-6 w-6 text-slate-400 hover:text-white"
        >
          <X className="h-4 w-4" />
        </Button>
      </div>

      <div className="w-px h-6 bg-slate-700" />

      <div className="flex items-center gap-2">
        {actions.map((action, i) => (
          <Button
            key={i}
            onClick={action.onClick}
            disabled={action.isLoading}
            className={cn(
              "h-8 text-sm",
              action.variant === "destructive"
                ? "bg-red-500/20 text-red-400 hover:bg-red-500/30"
                : "bg-primary/20 text-amber-400 hover:bg-primary/30"
            )}
          >
            {action.isLoading ? (
              <Loader2 className="h-4 w-4 mr-1 animate-spin" />
            ) : (
              action.icon
            )}
            {action.label}
          </Button>
        ))}
      </div>
    </div>
  );
}

// Hook for managing selection state
export function useSelection<T extends { id: string }>(items: T[]) {
  const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());

  const isSelected = (id: string) => selectedIds.has(id);
  const isAllSelected = items.length > 0 && selectedIds.size === items.length;
  const isPartiallySelected = selectedIds.size > 0 && selectedIds.size < items.length;

  const toggleSelect = (id: string) => {
    const newSet = new Set(selectedIds);
    if (newSet.has(id)) {
      newSet.delete(id);
    } else {
      newSet.add(id);
    }
    setSelectedIds(newSet);
  };

  const toggleSelectAll = () => {
    if (isAllSelected) {
      setSelectedIds(new Set());
    } else {
      setSelectedIds(new Set(items.map((item) => item.id)));
    }
  };

  const clearSelection = () => setSelectedIds(new Set());

  return {
    selectedIds,
    selectedCount: selectedIds.size,
    isSelected,
    isAllSelected,
    isPartiallySelected,
    toggleSelect,
    toggleSelectAll,
    clearSelection,
  };
}

import { useState } from "react";
