"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { User, Mail, Phone, MapPin, Package, Heart, Edit, LogOut, Loader2, Save, X } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { useSession, signOut } from "@/lib/auth-client";
import { useRouter } from "next/navigation";
import { toast } from "sonner";

// Demo orders data
const demoOrders = [
  {
    id: "1",
    orderNumber: "ORD-2024-001",
    date: new Date("2024-12-20"),
    status: "delivered",
    total: 4999,
    items: 2,
  },
  {
    id: "2",
    orderNumber: "ORD-2024-002",
    date: new Date("2024-12-22"),
    status: "processing",
    total: 12999,
    items: 1,
  },
  {
    id: "3",
    orderNumber: "ORD-2024-003",
    date: new Date("2024-12-23"),
    status: "pending",
    total: 8499,
    items: 3,
  },
];

const statusColors: Record<string, string> = {
  pending: "bg-yellow-100 text-yellow-700",
  processing: "bg-blue-100 text-blue-700",
  shipped: "bg-purple-100 text-purple-700",
  delivered: "bg-green-100 text-green-700",
  cancelled: "bg-red-100 text-red-700",
};

interface UserProfile {
  name?: string;
  phone?: string;
  defaultAddress?: {
    division?: string;
    district?: string;
    address?: string;
  };
}

export default function ProfilePage() {
  const { data: session, isPending } = useSession();
  const router = useRouter();
  const [isLoggingOut, setIsLoggingOut] = useState(false);
  const [isEditing, setIsEditing] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [profile, setProfile] = useState<UserProfile>({});
  const [formData, setFormData] = useState({
    name: "",
    phone: "",
    address: "",
  });

  // Fetch user profile on mount
  useEffect(() => {
    async function fetchProfile() {
      try {
        const res = await fetch("/api/user/profile");
        if (res.ok) {
          const data = await res.json() as { profile?: UserProfile };
          if (data.profile) {
            setProfile(data.profile);
            setFormData({
              name: data.profile.name || "",
              phone: data.profile.phone || "",
              address: data.profile.defaultAddress?.address || "",
            });
          }
        }
      } catch {}
    }
    if (session?.user) fetchProfile();
  }, [session?.user]);

  const handleSave = async () => {
    setIsSaving(true);
    try {
      const res = await fetch("/api/user/profile", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name: formData.name,
          phone: formData.phone,
          defaultAddress: {
            ...profile.defaultAddress,
            address: formData.address,
          },
        }),
      });
      
      if (res.ok) {
        setProfile(prev => ({
          ...prev,
          name: formData.name,
          phone: formData.phone,
          defaultAddress: { ...prev.defaultAddress, address: formData.address },
        }));
        setIsEditing(false);
        toast.success("Profile updated successfully!");
        router.refresh();
      } else {
        toast.error("Failed to update profile");
      }
    } catch {
      toast.error("Failed to update profile");
    } finally {
      setIsSaving(false);
    }
  };

  const handleLogout = async () => {
    setIsLoggingOut(true);
    await signOut();
    router.push("/");
    router.refresh();
  };

  if (isPending) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-amber-50 via-white to-rose-50 flex items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-amber-500" />
      </div>
    );
  }

  if (!session?.user) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-amber-50 via-white to-rose-50">
        <div className="container mx-auto px-4 py-16">
          <Card className="max-w-md mx-auto text-center">
            <CardContent className="pt-6">
              <User className="h-16 w-16 mx-auto text-gray-300 mb-4" />
              <h2 className="text-xl font-bold text-gray-800 mb-2">Please Sign In</h2>
              <p className="text-gray-500 mb-6">You need to be logged in to view your profile.</p>
              <div className="flex gap-3 justify-center">
                <Link href="/login">
                  <Button className="bg-gradient-to-r from-amber-500 to-rose-500 text-white">
                    Sign In
                  </Button>
                </Link>
                <Link href="/register">
                  <Button variant="outline">Create Account</Button>
                </Link>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    );
  }

  const user = session.user;

  return (
    <div className="min-h-screen bg-gradient-to-br from-amber-50 via-white to-rose-50">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Profile Header */}
        <div className="bg-gradient-to-r from-amber-500 via-rose-500 to-purple-600 rounded-2xl p-8 mb-8 text-white relative overflow-hidden">
          <div className="absolute inset-0 overflow-hidden pointer-events-none">
            <div className="absolute -top-20 -right-20 w-60 h-60 bg-white/10 rounded-full blur-3xl" />
            <div className="absolute -bottom-20 -left-20 w-60 h-60 bg-white/10 rounded-full blur-3xl" />
          </div>
          
          <div className="relative z-10 flex flex-col sm:flex-row items-center gap-6">
            <Avatar className="h-24 w-24 border-4 border-white/30">
              <AvatarImage src={user.image || undefined} alt={user.name} />
              <AvatarFallback className="text-2xl bg-white/20 text-white">
                {user.name?.charAt(0).toUpperCase() || "U"}
              </AvatarFallback>
            </Avatar>
            
            <div className="text-center sm:text-left flex-1">
              <h1 className="text-2xl sm:text-3xl font-bold">{user.name}</h1>
              <p className="text-white/80">{user.email}</p>
              <div className="mt-2 flex flex-wrap gap-2 justify-center sm:justify-start">
                <Badge className="bg-white/20 text-white border-0">
                  Member since 2024
                </Badge>
              </div>
            </div>

            <div className="flex gap-2">
              <Button 
                variant="secondary" 
                size="sm" 
                className="gap-2"
                onClick={() => setIsEditing(!isEditing)}
              >
                {isEditing ? <X className="h-4 w-4" /> : <Edit className="h-4 w-4" />}
                {isEditing ? "Cancel" : "Edit Profile"}
              </Button>
              <Button 
                variant="secondary" 
                size="sm" 
                className="gap-2"
                onClick={handleLogout}
                disabled={isLoggingOut}
              >
                {isLoggingOut ? (
                  <Loader2 className="h-4 w-4 animate-spin" />
                ) : (
                  <LogOut className="h-4 w-4" />
                )}
                Logout
              </Button>
            </div>
          </div>
        </div>

        {/* Stats Cards */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
          <Card className="bg-white/80 backdrop-blur">
            <CardContent className="pt-6 text-center">
              <Package className="h-8 w-8 mx-auto text-amber-500 mb-2" />
              <p className="text-2xl font-bold text-gray-800">{demoOrders.length}</p>
              <p className="text-sm text-gray-500">Total Orders</p>
            </CardContent>
          </Card>
          <Card className="bg-white/80 backdrop-blur">
            <CardContent className="pt-6 text-center">
              <Heart className="h-8 w-8 mx-auto text-rose-500 mb-2" />
              <p className="text-2xl font-bold text-gray-800">5</p>
              <p className="text-sm text-gray-500">Wishlist Items</p>
            </CardContent>
          </Card>
          <Card className="bg-white/80 backdrop-blur">
            <CardContent className="pt-6 text-center">
              <div className="h-8 w-8 mx-auto bg-green-100 rounded-full flex items-center justify-center mb-2">
                <span className="text-green-600 font-bold">৳</span>
              </div>
              <p className="text-2xl font-bold text-gray-800">26,497</p>
              <p className="text-sm text-gray-500">Total Spent</p>
            </CardContent>
          </Card>
          <Card className="bg-white/80 backdrop-blur">
            <CardContent className="pt-6 text-center">
              <div className="h-8 w-8 mx-auto bg-purple-100 rounded-full flex items-center justify-center mb-2">
                <span className="text-purple-600 font-bold">🎁</span>
              </div>
              <p className="text-2xl font-bold text-gray-800">150</p>
              <p className="text-sm text-gray-500">Reward Points</p>
            </CardContent>
          </Card>
        </div>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Personal Information */}
          <div className="lg:col-span-1">
            <Card className="bg-white/80 backdrop-blur">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <User className="h-5 w-5 text-amber-500" />
                  Personal Information
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div>
                  <label className="text-sm font-medium text-gray-500">Full Name</label>
                  <Input 
                    value={isEditing ? formData.name : (profile.name || user.name || "")}
                    onChange={(e) => setFormData(prev => ({ ...prev, name: e.target.value }))}
                    disabled={!isEditing}
                    className="mt-1" 
                  />
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500 flex items-center gap-1">
                    <Mail className="h-4 w-4" /> Email
                  </label>
                  <Input value={user.email || ""} disabled className="mt-1" />
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500 flex items-center gap-1">
                    <Phone className="h-4 w-4" /> Phone
                  </label>
                  <Input 
                    value={isEditing ? formData.phone : (profile.phone || "")}
                    onChange={(e) => setFormData(prev => ({ ...prev, phone: e.target.value }))}
                    disabled={!isEditing}
                    placeholder="+880 1XXX XXXXXX"
                    className="mt-1" 
                  />
                </div>
                <div>
                  <label className="text-sm font-medium text-gray-500 flex items-center gap-1">
                    <MapPin className="h-4 w-4" /> Address
                  </label>
                  <Input 
                    value={isEditing ? formData.address : (profile.defaultAddress?.address || "")}
                    onChange={(e) => setFormData(prev => ({ ...prev, address: e.target.value }))}
                    disabled={!isEditing}
                    placeholder="Enter your address"
                    className="mt-1" 
                  />
                </div>
                {isEditing ? (
                  <Button 
                    className="w-full mt-4 bg-gradient-to-r from-amber-500 to-rose-500 text-white"
                    onClick={handleSave}
                    disabled={isSaving}
                  >
                    {isSaving ? <Loader2 className="h-4 w-4 mr-2 animate-spin" /> : <Save className="h-4 w-4 mr-2" />}
                    Save Changes
                  </Button>
                ) : (
                  <Button variant="outline" className="w-full mt-4" onClick={() => setIsEditing(true)}>
                    <Edit className="h-4 w-4 mr-2" />
                    Edit Information
                  </Button>
                )}
              </CardContent>
            </Card>
          </div>

          {/* Recent Orders */}
          <div className="lg:col-span-2">
            <Card className="bg-white/80 backdrop-blur">
              <CardHeader className="flex flex-row items-center justify-between">
                <div>
                  <CardTitle className="flex items-center gap-2">
                    <Package className="h-5 w-5 text-amber-500" />
                    Recent Orders
                  </CardTitle>
                  <CardDescription>Your latest order history</CardDescription>
                </div>
                <Link href="/orders">
                  <Button variant="outline" size="sm">View All</Button>
                </Link>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {demoOrders.map((order) => (
                    <div
                      key={order.id}
                      className="flex items-center justify-between p-4 rounded-lg border border-gray-100 hover:bg-gray-50 transition-colors"
                    >
                      <div>
                        <p className="font-medium text-gray-800">{order.orderNumber}</p>
                        <p className="text-sm text-gray-500">
                          {order.date.toLocaleDateString()} • {order.items} items
                        </p>
                      </div>
                      <div className="text-right">
                        <p className="font-bold text-gray-800">৳{order.total.toLocaleString()}</p>
                        <Badge className={`${statusColors[order.status]} border-0 text-xs`}>
                          {order.status.charAt(0).toUpperCase() + order.status.slice(1)}
                        </Badge>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
}
