"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Settings, Save, Loader2 } from "lucide-react";

export default function AdminSettingsPage() {
  const [isSaving, setIsSaving] = useState(false);
  const [settings, setSettings] = useState({
    storeName: "DC Store",
    storeEmail: "contact@dcstore.com",
    storePhone: "+880123456789",
    storeAddress: "Dhaka, Bangladesh",
    deliveryInsideDhaka: 60,
    deliveryOutsideDhaka: 120,
  });

  const handleSave = async () => {
    setIsSaving(true);
    try {
      // TODO: Implement settings save API
      await new Promise((resolve) => setTimeout(resolve, 1000));
      alert("Settings saved successfully!");
    } catch (error) {
      console.error("Failed to save settings:", error);
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="space-y-6 max-w-2xl">
      <h1 className="text-2xl font-bold text-white">Settings</h1>

      {/* Store Info */}
      <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-6">
        <div className="flex items-center gap-2 mb-4">
          <Settings className="h-5 w-5 text-amber-400" />
          <h2 className="font-semibold text-white">Store Information</h2>
        </div>
        <div className="space-y-4">
          <div>
            <label className="block text-sm text-slate-400 mb-1">
              Store Name
            </label>
            <Input
              value={settings.storeName}
              onChange={(e) =>
                setSettings({ ...settings, storeName: e.target.value })
              }
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
              onChange={(e) =>
                setSettings({ ...settings, storeEmail: e.target.value })
              }
              className="bg-slate-700 border-slate-600 text-white"
            />
          </div>
          <div>
            <label className="block text-sm text-slate-400 mb-1">
              Phone
            </label>
            <Input
              value={settings.storePhone}
              onChange={(e) =>
                setSettings({ ...settings, storePhone: e.target.value })
              }
              className="bg-slate-700 border-slate-600 text-white"
            />
          </div>
          <div>
            <label className="block text-sm text-slate-400 mb-1">
              Address
            </label>
            <Input
              value={settings.storeAddress}
              onChange={(e) =>
                setSettings({ ...settings, storeAddress: e.target.value })
              }
              className="bg-slate-700 border-slate-600 text-white"
            />
          </div>
        </div>
      </div>

      {/* Delivery Settings */}
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
                setSettings({
                  ...settings,
                  deliveryInsideDhaka: parseInt(e.target.value) || 0,
                })
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
                setSettings({
                  ...settings,
                  deliveryOutsideDhaka: parseInt(e.target.value) || 0,
                })
              }
              className="bg-slate-700 border-slate-600 text-white"
            />
          </div>
        </div>
      </div>

      {/* Save Button */}
      <div className="flex justify-end">
        <Button
          onClick={handleSave}
          disabled={isSaving}
          className="bg-amber-500 hover:bg-amber-600 text-black"
        >
          {isSaving ? (
            <Loader2 className="h-4 w-4 mr-2 animate-spin" />
          ) : (
            <Save className="h-4 w-4 mr-2" />
          )}
          Save Settings
        </Button>
      </div>
    </div>
  );
}
