"use client";

import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Switch } from "@/components/ui/switch";
import {
  Settings,
  Save,
  Loader2,
  Store,
  Truck,
  CreditCard,
  Bell,
} from "lucide-react";

interface SettingsData {
  // General
  storeName: string;
  storeEmail: string;
  storePhone: string;
  storeAddress: string;
  // Delivery
  deliveryInsideDhaka: number;
  deliveryOutsideDhaka: number;
  freeDeliveryThreshold: number;
  enableFreeDelivery: boolean;
  // Payments
  enableCOD: boolean;
  enableStripe: boolean;
  enableBkash: boolean;
  // Notifications
  notifyNewOrder: boolean;
  notifyLowStock: boolean;
  lowStockThreshold: number;
}

const defaultSettings: SettingsData = {
  storeName: "DC Store",
  storeEmail: "contact@dcstore.com",
  storePhone: "+880123456789",
  storeAddress: "Dhaka, Bangladesh",
  deliveryInsideDhaka: 60,
  deliveryOutsideDhaka: 120,
  freeDeliveryThreshold: 1500,
  enableFreeDelivery: true,
  enableCOD: true,
  enableStripe: true,
  enableBkash: false,
  notifyNewOrder: true,
  notifyLowStock: true,
  lowStockThreshold: 5,
};

export default function AdminSettingsPage() {
  const [isSaving, setIsSaving] = useState(false);
  const [isLoading, setIsLoading] = useState(true);
  const [settings, setSettings] = useState<SettingsData>(defaultSettings);
  const [activeTab, setActiveTab] = useState("general");

  useEffect(() => {
    async function loadSettings() {
      try {
        const res = await fetch("/api/admin/settings");
        if (res.ok) {
          const data = await res.json() as { settings?: Partial<SettingsData> };
          if (data.settings) {
            setSettings({ ...defaultSettings, ...data.settings });
          }
        }
      } catch (error) {
        console.error("Failed to load settings:", error);
      } finally {
        setIsLoading(false);
      }
    }
    loadSettings();
  }, []);

  const handleSave = async () => {
    setIsSaving(true);
    try {
      const response = await fetch("/api/admin/settings", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(settings),
      });

      if (!response.ok) {
        const data = await response.json() as { error?: string };
        alert(data.error || "Failed to save settings");
      }
    } catch (error) {
      console.error("Failed to save settings:", error);
      alert("Failed to save settings");
    } finally {
      setIsSaving(false);
    }
  };

  const updateSetting = <K extends keyof SettingsData>(
    key: K,
    value: SettingsData[K]
  ) => {
    setSettings((prev) => ({ ...prev, [key]: value }));
  };

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-64">
        <Loader2 className="h-8 w-8 animate-spin text-amber-400" />
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-white">Settings</h1>
        <Button
          onClick={handleSave}
          disabled={isSaving}
          className="bg-primary hover:bg-amber-600 text-black"
        >
          {isSaving ? (
            <Loader2 className="h-4 w-4 mr-2 animate-spin" />
          ) : (
            <Save className="h-4 w-4 mr-2" />
          )}
          Save All Settings
        </Button>
      </div>

      <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
        <TabsList className="bg-slate-800 border border-slate-700 p-1">
          <TabsTrigger
            value="general"
            className="data-[state=active]:bg-amber-500/20 data-[state=active]:text-amber-400"
          >
            <Store className="h-4 w-4 mr-2" />
            General
          </TabsTrigger>
          <TabsTrigger
            value="delivery"
            className="data-[state=active]:bg-amber-500/20 data-[state=active]:text-amber-400"
          >
            <Truck className="h-4 w-4 mr-2" />
            Delivery
          </TabsTrigger>
          <TabsTrigger
            value="payments"
            className="data-[state=active]:bg-amber-500/20 data-[state=active]:text-amber-400"
          >
            <CreditCard className="h-4 w-4 mr-2" />
            Payments
          </TabsTrigger>
          <TabsTrigger
            value="notifications"
            className="data-[state=active]:bg-amber-500/20 data-[state=active]:text-amber-400"
          >
            <Bell className="h-4 w-4 mr-2" />
            Notifications
          </TabsTrigger>
        </TabsList>

        {/* General Tab */}
        <TabsContent value="general" className="space-y-6">
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
            <div className="flex items-center gap-2 mb-4">
              <Settings className="h-5 w-5 text-amber-400" />
              <h2 className="font-semibold text-white">Store Information</h2>
            </div>
            <div className="grid gap-4 sm:grid-cols-2">
              <div>
                <label className="block text-sm text-slate-400 mb-1">
                  Store Name
                </label>
                <Input
                  value={settings.storeName}
                  onChange={(e) => updateSetting("storeName", e.target.value)}
                  className="bg-slate-700 border-slate-600 text-white"
                />
              </div>
              <div>
                <label className="block text-sm text-slate-400 mb-1">
                  Email
                </label>
                <Input
                  type="email"
                  value={settings.storeEmail}
                  onChange={(e) => updateSetting("storeEmail", e.target.value)}
                  className="bg-slate-700 border-slate-600 text-white"
                />
              </div>
              <div>
                <label className="block text-sm text-slate-400 mb-1">
                  Phone
                </label>
                <Input
                  value={settings.storePhone}
                  onChange={(e) => updateSetting("storePhone", e.target.value)}
                  className="bg-slate-700 border-slate-600 text-white"
                />
              </div>
              <div>
                <label className="block text-sm text-slate-400 mb-1">
                  Address
                </label>
                <Input
                  value={settings.storeAddress}
                  onChange={(e) => updateSetting("storeAddress", e.target.value)}
                  className="bg-slate-700 border-slate-600 text-white"
                />
              </div>
            </div>
          </div>
        </TabsContent>

        {/* Delivery Tab */}
        <TabsContent value="delivery" className="space-y-6">
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
            <h2 className="font-semibold text-white mb-4">Delivery Charges</h2>
            <div className="grid gap-4 sm:grid-cols-2">
              <div>
                <label className="block text-sm text-slate-400 mb-1">
                  Inside Dhaka (৳)
                </label>
                <Input
                  type="number"
                  value={settings.deliveryInsideDhaka}
                  onChange={(e) =>
                    updateSetting("deliveryInsideDhaka", parseInt(e.target.value) || 0)
                  }
                  className="bg-slate-700 border-slate-600 text-white"
                />
              </div>
              <div>
                <label className="block text-sm text-slate-400 mb-1">
                  Outside Dhaka (৳)
                </label>
                <Input
                  type="number"
                  value={settings.deliveryOutsideDhaka}
                  onChange={(e) =>
                    updateSetting("deliveryOutsideDhaka", parseInt(e.target.value) || 0)
                  }
                  className="bg-slate-700 border-slate-600 text-white"
                />
              </div>
            </div>
          </div>

          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
            <h2 className="font-semibold text-white mb-4">Free Delivery</h2>
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-white">Enable Free Delivery</p>
                  <p className="text-sm text-slate-400">
                    Offer free delivery above a certain order amount
                  </p>
                </div>
                <Switch
                  checked={settings.enableFreeDelivery}
                  onCheckedChange={(checked) =>
                    updateSetting("enableFreeDelivery", checked)
                  }
                />
              </div>
              {settings.enableFreeDelivery && (
                <div>
                  <label className="block text-sm text-slate-400 mb-1">
                    Minimum Order Amount (৳)
                  </label>
                  <Input
                    type="number"
                    value={settings.freeDeliveryThreshold}
                    onChange={(e) =>
                      updateSetting("freeDeliveryThreshold", parseInt(e.target.value) || 0)
                    }
                    className="bg-slate-700 border-slate-600 text-white max-w-xs"
                  />
                </div>
              )}
            </div>
          </div>
        </TabsContent>

        {/* Payments Tab */}
        <TabsContent value="payments" className="space-y-6">
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
            <h2 className="font-semibold text-white mb-4">Payment Methods</h2>
            <div className="space-y-4">
              <div className="flex items-center justify-between py-3 border-b border-slate-700">
                <div>
                  <p className="text-white font-medium">Cash on Delivery</p>
                  <p className="text-sm text-slate-400">
                    Accept cash payment on delivery
                  </p>
                </div>
                <Switch
                  checked={settings.enableCOD}
                  onCheckedChange={(checked) => updateSetting("enableCOD", checked)}
                />
              </div>
              <div className="flex items-center justify-between py-3 border-b border-slate-700">
                <div>
                  <p className="text-white font-medium">Stripe</p>
                  <p className="text-sm text-slate-400">
                    Accept credit/debit card payments
                  </p>
                </div>
                <Switch
                  checked={settings.enableStripe}
                  onCheckedChange={(checked) => updateSetting("enableStripe", checked)}
                />
              </div>
              <div className="flex items-center justify-between py-3">
                <div>
                  <p className="text-white font-medium">bKash</p>
                  <p className="text-sm text-slate-400">
                    Accept mobile payment via bKash
                  </p>
                </div>
                <Switch
                  checked={settings.enableBkash}
                  onCheckedChange={(checked) => updateSetting("enableBkash", checked)}
                />
              </div>
            </div>
          </div>
        </TabsContent>

        {/* Notifications Tab */}
        <TabsContent value="notifications" className="space-y-6">
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
            <h2 className="font-semibold text-white mb-4">Admin Notifications</h2>
            <div className="space-y-4">
              <div className="flex items-center justify-between py-3 border-b border-slate-700">
                <div>
                  <p className="text-white font-medium">New Order Alerts</p>
                  <p className="text-sm text-slate-400">
                    Get notified when a new order is placed
                  </p>
                </div>
                <Switch
                  checked={settings.notifyNewOrder}
                  onCheckedChange={(checked) =>
                    updateSetting("notifyNewOrder", checked)
                  }
                />
              </div>
              <div className="flex items-center justify-between py-3">
                <div>
                  <p className="text-white font-medium">Low Stock Alerts</p>
                  <p className="text-sm text-slate-400">
                    Get notified when products are running low
                  </p>
                </div>
                <Switch
                  checked={settings.notifyLowStock}
                  onCheckedChange={(checked) =>
                    updateSetting("notifyLowStock", checked)
                  }
                />
              </div>
            </div>
          </div>

          {settings.notifyLowStock && (
            <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
              <h2 className="font-semibold text-white mb-4">Low Stock Threshold</h2>
              <div>
                <label className="block text-sm text-slate-400 mb-1">
                  Alert when stock falls below
                </label>
                <Input
                  type="number"
                  value={settings.lowStockThreshold}
                  onChange={(e) =>
                    updateSetting("lowStockThreshold", parseInt(e.target.value) || 1)
                  }
                  className="bg-slate-700 border-slate-600 text-white max-w-xs"
                />
              </div>
            </div>
          )}
        </TabsContent>
      </Tabs>
    </div>
  );
}
