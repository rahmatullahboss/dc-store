"use client";

import { useEffect, useState } from "react";
import { Link } from "@/i18n/routing";
import { Button } from "@/components/ui/button";
import { Bell, ShoppingCart, AlertTriangle } from "lucide-react";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { cn } from "@/lib/utils";
import { formatPrice } from "@/lib/config";

interface Notification {
  id: string;
  type: "order" | "low_stock";
  title: string;
  message: string;
  href: string;
  createdAt: Date;
  read: boolean;
}

interface NotificationData {
  pendingOrders: number;
  lowStockCount: number;
  recentOrders: Array<{
    id: string;
    orderNumber: string;
    customerName: string;
    total: number;
    createdAt: string;
  }>;
  lowStockProducts: Array<{
    id: string;
    name: string;
    quantity: number;
  }>;
}

export function NotificationCenter() {
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [isOpen, setIsOpen] = useState(false);
  const [unreadCount, setUnreadCount] = useState(0);

  useEffect(() => {
    async function fetchNotifications() {
      try {
        const res = await fetch("/api/admin/stats");
        if (res.ok) {
          const data = await res.json() as NotificationData;
          const newNotifications: Notification[] = [];

          // Add pending order notifications
          if (data.recentOrders) {
            data.recentOrders.slice(0, 3).forEach((order) => {
              newNotifications.push({
                id: `order-${order.id}`,
                type: "order",
                title: `New Order #${order.orderNumber}`,
                message: `${order.customerName} - ${formatPrice(order.total)}`,
                href: `/admin/orders/${order.id}`,
                createdAt: new Date(order.createdAt),
                read: false,
              });
            });
          }

          // Add low stock notifications
          if (data.lowStockProducts) {
            data.lowStockProducts.slice(0, 3).forEach((product) => {
              newNotifications.push({
                id: `stock-${product.id}`,
                type: "low_stock",
                title: product.quantity === 0 ? "Out of Stock" : "Low Stock",
                message: `${product.name} - ${product.quantity} left`,
                href: `/admin/products/${product.id}`,
                createdAt: new Date(),
                read: false,
              });
            });
          }

          setNotifications(newNotifications);
          setUnreadCount(newNotifications.filter((n) => !n.read).length);
        }
      } catch (error) {
        console.error("Failed to fetch notifications:", error);
      }
    }

    fetchNotifications();
    // Refresh every 60 seconds
    const interval = setInterval(fetchNotifications, 60000);
    return () => clearInterval(interval);
  }, []);

  const handleOpenChange = (open: boolean) => {
    setIsOpen(open);
    // Auto-mark as seen when dropdown opens
    if (open && unreadCount > 0) {
      setNotifications((prev) => prev.map((n) => ({ ...n, read: true })));
      setUnreadCount(0);
    }
  };

  const markAsRead = (id: string) => {
    setNotifications((prev) =>
      prev.map((n) => (n.id === id ? { ...n, read: true } : n))
    );
    setUnreadCount((prev) => Math.max(0, prev - 1));
  };

  const clearAll = () => {
    setNotifications((prev) => prev.map((n) => ({ ...n, read: true })));
    setUnreadCount(0);
  };

  return (
    <DropdownMenu open={isOpen} onOpenChange={handleOpenChange}>
      <DropdownMenuTrigger asChild>
        <Button
          variant="ghost"
          size="icon"
          className="relative text-slate-400 hover:text-white"
        >
          <Bell className="h-5 w-5" />
          {unreadCount > 0 && (
            <span className="absolute -top-1 -right-1 h-5 w-5 bg-red-500 rounded-full text-xs text-white flex items-center justify-center">
              {unreadCount > 9 ? "9+" : unreadCount}
            </span>
          )}
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent
        align="end"
        className="w-80 bg-slate-800 border-slate-700 p-0"
      >
        <div className="flex items-center justify-between px-4 py-3 border-b border-slate-700">
          <span className="font-semibold text-white">Notifications</span>
          {unreadCount > 0 && (
            <button
              onClick={(e) => {
                e.preventDefault();
                e.stopPropagation();
                clearAll();
              }}
              className="text-xs text-slate-400 hover:text-white transition-colors"
            >
              Mark all as read
            </button>
          )}
        </div>

        {notifications.length === 0 ? (
          <div className="py-8 text-center text-slate-500">
            No notifications
          </div>
        ) : (
          <div className="max-h-80 overflow-y-auto">
            {notifications.map((notification) => (
              <DropdownMenuItem
                key={notification.id}
                asChild
                className="p-0 focus:bg-slate-700"
              >
                <Link
                  href={notification.href}
                  onClick={() => markAsRead(notification.id)}
                  className={cn(
                    "flex items-start gap-3 px-4 py-3 cursor-pointer",
                    !notification.read && "bg-slate-700/50"
                  )}
                >
                  <div
                    className={cn(
                      "p-2 rounded-lg flex-shrink-0",
                      notification.type === "order"
                        ? "bg-blue-500/20"
                        : "bg-amber-500/20"
                    )}
                  >
                    {notification.type === "order" ? (
                      <ShoppingCart className="h-4 w-4 text-blue-400" />
                    ) : (
                      <AlertTriangle className="h-4 w-4 text-amber-400" />
                    )}
                  </div>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium text-white">
                      {notification.title}
                    </p>
                    <p className="text-xs text-slate-400 truncate">
                      {notification.message}
                    </p>
                  </div>
                  {!notification.read && (
                    <div className="w-2 h-2 bg-amber-400 rounded-full flex-shrink-0 mt-2" />
                  )}
                </Link>
              </DropdownMenuItem>
            ))}
          </div>
        )}

        <div className="border-t border-slate-700 p-2">
          <Link
            href="/admin/orders"
            className="block text-center text-xs text-amber-400 hover:text-amber-300 py-2"
          >
            View all orders →
          </Link>
        </div>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
