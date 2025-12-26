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

const statusColors: Record<string, string> = {
  pending: "bg-yellow-100 text-yellow-700",
  confirmed: "bg-blue-100 text-blue-700",
  processing: "bg-blue-100 text-blue-700",
  shipped: "bg-purple-100 text-purple-700",
  delivered: "bg-green-100 text-green-700",
  cancelled: "bg-red-100 text-red-700",
  refunded: "bg-gray-100 text-gray-700",
};

interface UserProfile {
  name?: string;
  phone?: string;
  createdAt?: string;
  defaultAddress?: {
    division?: string;
    district?: string;
    address?: string;
  };
}

interface UserStats {
  orderCount: number;
  totalSpent: number;
  wishlistCount: number;
  rewardPoints: number;
}

interface Order {
  id: string;
  orderNumber: string;
  date: string;
  status: string;
  total: number;
  items: number;
}

export default function ProfilePage() {
  const { data: session, isPending } = useSession();
  const router = useRouter();
  const [isLoggingOut, setIsLoggingOut] = useState(false);
  const [isEditing, setIsEditing] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [isLoadingProfile, setIsLoadingProfile] = useState(true);
  const [profile, setProfile] = useState<UserProfile>({});
  const [stats, setStats] = useState<UserStats>({
    orderCount: 0,
    totalSpent: 0,
    wishlistCount: 0,
    rewardPoints: 0,
  });
  const [recentOrders, setRecentOrders] = useState<Order[]>([]);
  const [formData, setFormData] = useState({
    name: "",
    phone: "",
    address: "",
  });

  // Fetch user profile on mount
  useEffect(() => {
    async function fetchProfile() {
      setIsLoadingProfile(true);
      try {
        const res = await fetch("/api/user/profile");
        if (res.ok) {
          const data = await res.json() as { 
            profile?: UserProfile;
            stats?: UserStats;
            recentOrders?: Order[];
          };
          if (data.profile) {
            setProfile(data.profile);
            setFormData({
              name: data.profile.name || "",
              phone: data.profile.phone || "",
              address: data.profile.defaultAddress?.address || "",
            });
          }
          if (data.stats) {
            setStats(data.stats);
          }
          if (data.recentOrders) {
            setRecentOrders(data.recentOrders);
          }
        }
      } catch {
        console.error("Failed to fetch profile");
      } finally {
        setIsLoadingProfile(false);
      }
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

  // Format member since date
  const getMemberSinceText = () => {
    if (!profile.createdAt) return "Member";
    const date = new Date(profile.createdAt);
    const year = date.getFullYear();
    const month = date.toLocaleString('default', { month: 'short' });
    return `Member since ${month} ${year}`;
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
              <h1 className="text-2xl sm:text-3xl font-bold">{profile.name || user.name}</h1>
              <p className="text-white/80">{user.email}</p>
              <div className="mt-2 flex flex-wrap gap-2 justify-center sm:justify-start">
                <Badge className="bg-white/20 text-white border-0">
                  {getMemberSinceText()}
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
              {isLoadingProfile ? (
                <Loader2 className="h-6 w-6 mx-auto animate-spin text-gray-400" />
              ) : (
                <p className="text-2xl font-bold text-gray-800">{stats.orderCount}</p>
              )}
              <p className="text-sm text-gray-500">Total Orders</p>
            </CardContent>
          </Card>
          <Card className="bg-white/80 backdrop-blur">
            <CardContent className="pt-6 text-center">
              <Heart className="h-8 w-8 mx-auto text-rose-500 mb-2" />
              {isLoadingProfile ? (
                <Loader2 className="h-6 w-6 mx-auto animate-spin text-gray-400" />
              ) : (
                <p className="text-2xl font-bold text-gray-800">{stats.wishlistCount}</p>
              )}
              <p className="text-sm text-gray-500">Wishlist Items</p>
            </CardContent>
          </Card>
          <Card className="bg-white/80 backdrop-blur">
            <CardContent className="pt-6 text-center">
              <div className="h-8 w-8 mx-auto bg-green-100 rounded-full flex items-center justify-center mb-2">
                <span className="text-green-600 font-bold">৳</span>
              </div>
              {isLoadingProfile ? (
                <Loader2 className="h-6 w-6 mx-auto animate-spin text-gray-400" />
              ) : (
                <p className="text-2xl font-bold text-gray-800">
                  {stats.totalSpent.toLocaleString()}
                </p>
              )}
              <p className="text-sm text-gray-500">Total Spent</p>
            </CardContent>
          </Card>
          <Card className="bg-white/80 backdrop-blur">
            <CardContent className="pt-6 text-center">
              <div className="h-8 w-8 mx-auto bg-purple-100 rounded-full flex items-center justify-center mb-2">
                <span className="text-purple-600 font-bold">🎁</span>
              </div>
              {isLoadingProfile ? (
                <Loader2 className="h-6 w-6 mx-auto animate-spin text-gray-400" />
              ) : (
                <p className="text-2xl font-bold text-gray-800">{stats.rewardPoints}</p>
              )}
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
                {isLoadingProfile ? (
                  <div className="flex items-center justify-center py-8">
                    <Loader2 className="h-8 w-8 animate-spin text-amber-500" />
                  </div>
                ) : recentOrders.length === 0 ? (
                  <div className="text-center py-8">
                    <Package className="h-12 w-12 mx-auto text-gray-300 mb-3" />
                    <p className="text-gray-500">No orders yet</p>
                    <Link href="/products">
                      <Button className="mt-4 bg-gradient-to-r from-amber-500 to-rose-500 text-white">
                        Start Shopping
                      </Button>
                    </Link>
                  </div>
                ) : (
                  <div className="space-y-4">
                    {recentOrders.map((order) => (
                      <div
                        key={order.id}
                        className="flex items-center justify-between p-4 rounded-lg border border-gray-100 hover:bg-gray-50 transition-colors"
                      >
                        <div>
                          <p className="font-medium text-gray-800">{order.orderNumber}</p>
                          <p className="text-sm text-gray-500">
                            {new Date(order.date).toLocaleDateString()} • {order.items} items
                          </p>
                        </div>
                        <div className="text-right">
                          <p className="font-bold text-gray-800">৳{order.total.toLocaleString()}</p>
                          <Badge className={`${statusColors[order.status] || statusColors.pending} border-0 text-xs`}>
                            {order.status.charAt(0).toUpperCase() + order.status.slice(1)}
                          </Badge>
                        </div>
                      </div>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          </div>
        </div>
      </div>
    </div>
  );
}
