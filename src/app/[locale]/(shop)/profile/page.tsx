"use client";

import Image from "next/image";
import { Link, useRouter } from "@/i18n/routing";
import { useState, useEffect } from "react";
import { 
  User, 
  MapPin, 
  CreditCard,
  LogOut,
  ShoppingBag,
  Heart,
  Star,
  Loader2,
  Mail,
  Phone,
  Clock,
  CheckCircle2,
  XCircle,
  Package,
  ChevronRight,
  RefreshCw,
  Sparkles,
  Camera
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { useSession, signOut } from "@/lib/auth-client";
import { formatPrice } from "@/lib/config";
import { toast } from "sonner";
import { useTranslations } from "next-intl";

interface Order {
  id: string;
  orderNumber: string;
  date: string;
  status: "pending" | "processing" | "shipped" | "delivered" | "cancelled";
  total: number;
  items: number;
}

interface UserProfile {
  name: string;
  email: string;
  phone?: string;
  image?: string;
  defaultAddress?: {
    division?: string;
    district?: string;
    address?: string;
  };
  createdAt: string;
}

interface DashboardStats {
  orderCount: number;
  totalSpent: number;
  wishlistCount: number;
  rewardPoints: number;
}

interface WishlistProduct {
  id: string;
  name: string;
  slug: string;
  price: number;
  compareAtPrice?: number;
  featuredImage?: string;
}

interface WishlistPreviewItem {
  id: string;
  productId: string;
  product: WishlistProduct;
}

interface BuyAgainProduct {
  id: string;
  name: string;
  slug: string;
  price: number;
  compareAtPrice?: number;
  featuredImage?: string;
  inStock: boolean;
}

interface ProfileCompletion {
  hasName: boolean;
  hasEmail: boolean;
  hasPhone: boolean;
  hasAddress: boolean;
  hasImage: boolean;
  percentage: number;
}

interface ProfileResponse {
  profile: UserProfile;
  stats: DashboardStats;
  recentOrders: Order[];
  wishlistPreview: WishlistPreviewItem[];
  buyAgainProducts: BuyAgainProduct[];
  profileCompletion: ProfileCompletion;
}

export default function ProfilePage() {
  const t = useTranslations("Profile");
  const router = useRouter();
  const { data: session } = useSession();
  const [activeTab, setActiveTab] = useState<"overview" | "orders" | "settings">("overview");
  const [isLoading, setIsLoading] = useState(true);
  const [isUpdating, setIsUpdating] = useState(false);
  const [profile, setProfile] = useState<UserProfile | null>(null);
  const [stats, setStats] = useState<DashboardStats>({
    orderCount: 0,
    totalSpent: 0,
    wishlistCount: 0,
    rewardPoints: 0
  });
  const [recentOrders, setRecentOrders] = useState<Order[]>([]);
  const [wishlistPreview, setWishlistPreview] = useState<WishlistPreviewItem[]>([]);
  const [buyAgainProducts, setBuyAgainProducts] = useState<BuyAgainProduct[]>([]);
  const [profileCompletion, setProfileCompletion] = useState<ProfileCompletion>({
    hasName: false,
    hasEmail: false,
    hasPhone: false,
    hasAddress: false,
    hasImage: false,
    percentage: 0
  });
  const [isEditing, setIsEditing] = useState(false);
  const [editForm, setEditForm] = useState({
    name: "",
    phone: "",
  });

  useEffect(() => {
    async function fetchProfileData() {
      try {
        const res = await fetch("/api/user/profile");
        if (res.ok) {
          const data = await res.json() as ProfileResponse;
          
          // Parse default address if needed
          let parsedAddress = data.profile.defaultAddress;
          if (typeof parsedAddress === 'string') {
            try {
              parsedAddress = JSON.parse(parsedAddress);
              // Handle double encoding
              if (typeof parsedAddress === 'string') {
                parsedAddress = JSON.parse(parsedAddress);
              }
            } catch (e) {
              console.error("Error parsing address:", e);
            }
          }

          setProfile({
            ...data.profile,
            defaultAddress: parsedAddress
          });
          setStats(data.stats);
          setRecentOrders(data.recentOrders);
          setWishlistPreview(data.wishlistPreview || []);
          setBuyAgainProducts(data.buyAgainProducts || []);
          setProfileCompletion(data.profileCompletion || {
            hasName: false,
            hasEmail: false,
            hasPhone: false,
            hasAddress: false,
            hasImage: false,
            percentage: 0
          });
          
          setEditForm({
            name: data.profile.name || "",
            phone: data.profile.phone || "",
          });
        }
      } catch (error) {
        console.error("Error fetching profile:", error);
      } finally {
        setIsLoading(false);
      }
    }
    
    if (session) {
      fetchProfileData();
    } else {
      // If no session, wait a bit then redirect if still no session
      const timer = setTimeout(() => {
        if (!session) {
          router.push("/login?redirect=/profile");
        }
      }, 1000);
      return () => clearTimeout(timer);
    }
  }, [session, router]);

  const handleUpdateProfile = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsUpdating(true);
    
    try {
      const res = await fetch("/api/user/profile", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(editForm),
      });
      
      if (res.ok) {
        setProfile(prev => prev ? { ...prev, ...editForm } : null);
        setIsEditing(false);
        toast.success(t("notifications.success"));
        router.refresh();
      } else {
        toast.error(t("notifications.error"));
      }
    } catch {
      toast.error(t("notifications.error"));
    } finally {
      setIsUpdating(false);
    }
  };

  const handleSignOut = async () => {
    await signOut();
    router.push("/");
    router.refresh();
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="flex flex-col items-center gap-4">
          <Loader2 className="h-8 w-8 animate-spin text-primary" />
          <p className="text-muted-foreground">{t("loading")}</p>
        </div>
      </div>
    );
  }



  const getStatusIcon = (status: string) => {
    switch (status) {
      case "delivered": return <CheckCircle2 className="h-4 w-4" />;
      case "cancelled": return <XCircle className="h-4 w-4" />;
      case "processing": return <Clock className="h-4 w-4" />;
      default: return <Clock className="h-4 w-4" />;
    }
  };

  return (
    <div className="min-h-screen bg-background pb-20">
      {/* Header Background */}
      <div className="h-48 brand-gradient relative overflow-hidden">
        <div className="absolute inset-0 bg-black/10" />
        <div className="absolute bottom-0 left-0 right-0 h-24 bg-gradient-to-t from-background to-transparent" />
      </div>

      <div className="container mx-auto px-4 -mt-24 relative z-10">
        <div className="grid lg:grid-cols-4 gap-8">
          {/* Sidebar */}
          <div className="lg:col-span-1 space-y-6">
            {/* User Card */}
            <div className="bg-card rounded-2xl p-6 shadow-lg border border-border text-center">
              <div className="relative w-24 h-24 mx-auto mb-4">
                <div className="w-full h-full rounded-full overflow-hidden border-4 border-background bg-muted">
                  {profile?.image ? (
                    <Image
                      src={profile.image}
                      alt={profile.name}
                      fill
                      className="object-cover"
                    />
                  ) : (
                    <div className="w-full h-full flex items-center justify-center bg-primary/10 text-primary text-2xl font-bold">
                      {profile?.name?.charAt(0)}
                    </div>
                  )}
                </div>
                {/* <button className="absolute bottom-0 right-0 p-2 bg-primary text-white rounded-full hover:bg-primary/90 transition-colors shadow-lg">
                  <Camera className="h-4 w-4" />
                </button> */}
              </div>
              
              <h2 className="text-xl font-bold text-foreground mb-1">
                {profile?.name}
              </h2>
              <p className="text-muted-foreground text-sm mb-6">
                {profile?.email}
              </p>

              <div className="flex flex-col gap-2">
                <Button 
                  variant={activeTab === "overview" ? "default" : "ghost"}
                  className={`justify-start ${activeTab === "overview" ? "bg-primary text-white" : ""}`}
                  onClick={() => setActiveTab("overview")}
                >
                  <User className="mr-2 h-4 w-4" />
                  {t("tabs.info")}
                </Button>
                <Button 
                  variant={activeTab === "orders" ? "default" : "ghost"}
                  className={`justify-start ${activeTab === "orders" ? "bg-primary text-white" : ""}`}
                  onClick={() => setActiveTab("orders")}
                >
                  <Package className="mr-2 h-4 w-4" />
                  {t("tabs.orders")}
                </Button>
                {/* <Button 
                  variant={activeTab === "settings" ? "default" : "ghost"}
                  className={`justify-start ${activeTab === "settings" ? "bg-primary text-white" : ""}`}
                  onClick={() => setActiveTab("settings")}
                >
                  <Settings className="mr-2 h-4 w-4" />
                  Settings
                </Button> */}
                <Button 
                  variant="ghost" 
                  className="justify-start text-red-500 hover:text-red-600 hover:bg-red-50"
                  onClick={handleSignOut}
                >
                  <LogOut className="mr-2 h-4 w-4" />
                  {t("actions.logout")}
                </Button>
              </div>
            </div>

            {/* Stats Card */}
            <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
              <h3 className="font-bold text-foreground mb-4">{t("stats.title")}</h3>
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <ShoppingBag className="w-4 h-4 text-muted-foreground" />
                    <span className="text-muted-foreground">{t("stats.totalOrders")}</span>
                  </div>
                  <span className="font-bold">{stats.orderCount}</span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <CreditCard className="w-4 h-4 text-muted-foreground" />
                    <span className="text-muted-foreground">{t("stats.totalSpent")}</span>
                  </div>
                  <span className="font-bold text-primary">{formatPrice(stats.totalSpent)}</span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Heart className="w-4 h-4 text-muted-foreground" />
                    <span className="text-muted-foreground">{t("stats.wishlist")}</span>
                  </div>
                  <span className="font-bold text-accent">{stats.wishlistCount}</span>
                </div>
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <Star className="w-4 h-4 text-muted-foreground" />
                    <span className="text-muted-foreground">{t("stats.points")}</span>
                  </div>
                  <span className="font-bold text-amber-500">{stats.rewardPoints}</span>
                </div>
              </div>
            </div>
          </div>

          {/* Main Content */}
          <div className="lg:col-span-3">
            {activeTab === "overview" && (
              <div className="space-y-6">
                <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
                  <div className="flex items-center justify-between mb-6">
                    <h2 className="text-xl font-bold text-foreground">{t("personalInfo.title")}</h2>
                    <Button 
                      variant="outline" 
                      onClick={() => setIsEditing(!isEditing)}
                    >
                      {isEditing ? t("actions.cancel") : t("actions.edit")}
                    </Button>
                  </div>

                  {isEditing ? (
                    <form onSubmit={handleUpdateProfile} className="space-y-4">
                      <div className="grid sm:grid-cols-2 gap-4">
                        <div className="space-y-2">
                          <Label htmlFor="name">{t("personalInfo.labels.name")}</Label>
                          <Input
                            id="name"
                            value={editForm.name}
                            onChange={(e) => setEditForm(prev => ({ ...prev, name: e.target.value }))}
                          />
                        </div>
                        <div className="space-y-2">
                          <Label htmlFor="phone">{t("personalInfo.labels.phone")}</Label>
                          <Input
                            id="phone"
                            value={editForm.phone}
                            onChange={(e) => setEditForm(prev => ({ ...prev, phone: e.target.value }))}
                          />
                        </div>
                      </div>
                      <Button type="submit" disabled={isUpdating}>
                        {isUpdating && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                        {t("actions.save")}
                      </Button>
                    </form>
                  ) : (
                    <div className="grid sm:grid-cols-2 gap-8">
                      <div className="space-y-4">
                        <div className="flex items-start gap-3">
                          <User className="h-5 w-5 text-muted-foreground mt-0.5" />
                          <div>
                            <p className="text-sm text-muted-foreground">{t("personalInfo.labels.name")}</p>
                            <p className="font-medium">{profile?.name}</p>
                          </div>
                        </div>
                        <div className="flex items-start gap-3">
                          <Mail className="h-5 w-5 text-muted-foreground mt-0.5" />
                          <div>
                            <p className="text-sm text-muted-foreground">{t("personalInfo.labels.email")}</p>
                            <p className="font-medium">{profile?.email}</p>
                          </div>
                        </div>
                      </div>
                      <div className="space-y-4">
                        <div className="flex items-start gap-3">
                          <Phone className="h-5 w-5 text-muted-foreground mt-0.5" />
                          <div>
                            <p className="text-sm text-muted-foreground">{t("personalInfo.labels.phone")}</p>
                            <p className="font-medium">{profile?.phone || t("personalInfo.notSet")}</p>
                          </div>
                        </div>
                        <div className="flex items-start gap-3">
                          <MapPin className="h-5 w-5 text-muted-foreground mt-0.5" />
                          <div>
                            <p className="text-sm text-muted-foreground">{t("personalInfo.labels.address")}</p>
                            <p className="font-medium">
                              {profile?.defaultAddress ? (
                                <>
                                  {profile.defaultAddress.address && <span>{profile.defaultAddress.address}, </span>}
                                  {profile.defaultAddress.district && <span>{profile.defaultAddress.district}, </span>}
                                  {profile.defaultAddress.division}
                                </>
                              ) : (
                                t("personalInfo.notSet")
                              )}
                            </p>
                            <Button variant="link" className="p-0 h-auto mt-1 text-primary" asChild>
                              <Link href="/profile/addresses">{t("actions.manageAddresses")}</Link>
                            </Button>
                          </div>
                        </div>
                      </div>
                    </div>
                  )}
                </div>

                {/* Profile Completion Progress */}
                {profileCompletion.percentage < 100 && (
                  <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
                    <div className="flex items-center justify-between mb-4">
                      <div className="flex items-center gap-2">
                        <Sparkles className="h-5 w-5 text-amber-500" />
                        <h3 className="font-bold text-foreground">Complete Your Profile</h3>
                      </div>
                      <span className="text-sm font-medium text-primary">{profileCompletion.percentage}%</span>
                    </div>
                    
                    <div className="w-full bg-muted rounded-full h-2 mb-4">
                      <div 
                        className="h-2 rounded-full bg-gradient-to-r from-primary to-primary/70 transition-all duration-500"
                        style={{ width: `${profileCompletion.percentage}%` }}
                      />
                    </div>
                    
                    <div className="flex flex-wrap gap-2">
                      {profileCompletion.hasName && (
                        <span className="text-xs px-2 py-1 rounded-full bg-green-100 text-green-700 flex items-center gap-1">
                          <CheckCircle2 className="h-3 w-3" /> Name
                        </span>
                      )}
                      {profileCompletion.hasEmail && (
                        <span className="text-xs px-2 py-1 rounded-full bg-green-100 text-green-700 flex items-center gap-1">
                          <CheckCircle2 className="h-3 w-3" /> Email
                        </span>
                      )}
                      {!profileCompletion.hasPhone && (
                        <span className="text-xs px-2 py-1 rounded-full bg-muted text-muted-foreground flex items-center gap-1">
                          <Phone className="h-3 w-3" /> Add Phone
                        </span>
                      )}
                      {!profileCompletion.hasAddress && (
                        <span className="text-xs px-2 py-1 rounded-full bg-muted text-muted-foreground flex items-center gap-1">
                          <MapPin className="h-3 w-3" /> Add Address
                        </span>
                      )}
                      {!profileCompletion.hasImage && (
                        <span className="text-xs px-2 py-1 rounded-full bg-muted text-muted-foreground flex items-center gap-1">
                          <Camera className="h-3 w-3" /> Add Photo
                        </span>
                      )}
                    </div>
                  </div>
                )}

                {/* Buy Again Section */}
                {buyAgainProducts.length > 0 && (
                  <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
                    <div className="flex items-center justify-between mb-4">
                      <div className="flex items-center gap-2">
                        <RefreshCw className="h-5 w-5 text-primary" />
                        <h3 className="font-bold text-foreground">Buy Again</h3>
                      </div>
                      <Button variant="ghost" size="sm" className="gap-1" asChild>
                        <Link href="/orders">
                          View Orders
                          <ChevronRight className="h-4 w-4" />
                        </Link>
                      </Button>
                    </div>
                    
                    <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                      {buyAgainProducts.map((product) => (
                        <Link 
                          key={product.id} 
                          href={`/products/${product.slug}`}
                          className="group"
                        >
                          <div className="bg-muted/50 rounded-xl p-3 border border-border group-hover:border-primary/50 transition-colors">
                            <div className="aspect-square relative mb-2 rounded-lg overflow-hidden bg-background">
                              {product.featuredImage ? (
                                <Image
                                  src={product.featuredImage}
                                  alt={product.name}
                                  fill
                                  className="object-cover group-hover:scale-105 transition-transform"
                                />
                              ) : (
                                <div className="w-full h-full flex items-center justify-center">
                                  <Package className="h-8 w-8 text-muted-foreground" />
                                </div>
                              )}
                              {!product.inStock && (
                                <div className="absolute inset-0 bg-black/50 flex items-center justify-center">
                                  <span className="text-xs text-white font-medium">Out of Stock</span>
                                </div>
                              )}
                            </div>
                            <p className="text-sm font-medium text-foreground truncate">{product.name}</p>
                            <p className="text-sm font-bold text-primary">{formatPrice(product.price)}</p>
                          </div>
                        </Link>
                      ))}
                    </div>
                  </div>
                )}

                {/* Wishlist Preview */}
                {wishlistPreview.length > 0 && (
                  <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
                    <div className="flex items-center justify-between mb-4">
                      <div className="flex items-center gap-2">
                        <Heart className="h-5 w-5 text-red-500" />
                        <h3 className="font-bold text-foreground">My Wishlist</h3>
                        <span className="text-xs bg-muted px-2 py-0.5 rounded-full text-muted-foreground">
                          {stats.wishlistCount} items
                        </span>
                      </div>
                      <Button variant="ghost" size="sm" className="gap-1" asChild>
                        <Link href="/wishlist">
                          View All
                          <ChevronRight className="h-4 w-4" />
                        </Link>
                      </Button>
                    </div>
                    
                    <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                      {wishlistPreview.map((item) => (
                        <Link 
                          key={item.id} 
                          href={`/products/${item.product.slug}`}
                          className="group"
                        >
                          <div className="bg-muted/50 rounded-xl p-3 border border-border group-hover:border-primary/50 transition-colors">
                            <div className="aspect-square relative mb-2 rounded-lg overflow-hidden bg-background">
                              {item.product.featuredImage ? (
                                <Image
                                  src={item.product.featuredImage}
                                  alt={item.product.name}
                                  fill
                                  className="object-cover group-hover:scale-105 transition-transform"
                                />
                              ) : (
                                <div className="w-full h-full flex items-center justify-center">
                                  <Heart className="h-8 w-8 text-muted-foreground" />
                                </div>
                              )}
                            </div>
                            <p className="text-sm font-medium text-foreground truncate">{item.product.name}</p>
                            <div className="flex items-center gap-2">
                              <p className="text-sm font-bold text-primary">{formatPrice(item.product.price)}</p>
                              {item.product.compareAtPrice && item.product.compareAtPrice > item.product.price && (
                                <p className="text-xs text-muted-foreground line-through">
                                  {formatPrice(item.product.compareAtPrice)}
                                </p>
                              )}
                            </div>
                          </div>
                        </Link>
                      ))}
                    </div>
                  </div>
                )}

                {/* Recent Orders Preview */}
                <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
                  <div className="flex items-center justify-between mb-6">
                    <h2 className="text-xl font-bold text-foreground">{t("recentOrders.title")}</h2>
                    <Button variant="ghost" className="gap-2" onClick={() => setActiveTab("orders")}>
                      {t("actions.viewAll")}
                      <ChevronRight className="h-4 w-4" />
                    </Button>
                  </div>

                  {recentOrders.length > 0 ? (
                    <div className="space-y-4">
                      {recentOrders.map((order) => (
                        <div key={order.id} className="flex items-center justify-between p-4 bg-muted/50 rounded-xl border border-border">
                          <div className="flex items-center gap-4">
                            <div className="p-3 bg-background rounded-lg border border-border">
                              <Package className="h-6 w-6 text-primary" />
                            </div>
                            <div>
                              <p className="font-bold text-foreground">#{order.orderNumber}</p>
                              <p className="text-sm text-muted-foreground">
                                {new Date(order.date).toLocaleDateString()} • {order.items} {t("recentOrders.items")}
                              </p>
                            </div>
                          </div>
                          <div className="text-right">
                            <p className="font-bold text-foreground">
                              {formatPrice(order.total)}
                            </p>
                            <div className={`text-xs px-2 py-1 rounded-full inline-flex items-center gap-1 mt-1 font-medium bg-background border
                              ${order.status === 'delivered' ? 'text-green-600 border-green-200' : 
                                order.status === 'cancelled' ? 'text-red-600 border-red-200' : 
                                'text-amber-600 border-amber-200'}`}
                            >
                              {getStatusIcon(order.status)}
                              {t(`status.${order.status}`)}
                            </div>
                          </div>
                        </div>
                      ))}
                    </div>
                  ) : (
                    <div className="text-center py-8">
                      <p className="text-muted-foreground mb-4">{t("recentOrders.empty")}</p>
                      <Button asChild variant="outline">
                        <Link href="/products">{t("orders.empty.action")}</Link>
                      </Button>
                    </div>
                  )}
                </div>
              </div>
            )}

            {activeTab === "orders" && (
              <div className="bg-card rounded-2xl p-6 shadow-lg border border-border">
                <h2 className="text-xl font-bold text-foreground mb-6">{t("orders.title")}</h2>
                
                {recentOrders.length > 0 ? (
                  <div className="space-y-4">
                    {recentOrders.map((order) => (
                      <div key={order.id} className="flex items-center justify-between p-4 bg-muted/50 rounded-xl border border-border hover:border-primary/50 transition-colors">
                        <div className="flex items-center gap-4">
                          <div className="p-3 bg-background rounded-lg border border-border">
                            <Package className="h-6 w-6 text-primary" />
                          </div>
                          <div>
                            <div className="flex items-center gap-2">
                              <p className="font-bold text-foreground">#{order.orderNumber}</p>
                              <div className={`text-xs px-2 py-0.5 rounded-full inline-flex items-center gap-1 font-medium bg-background border
                                ${order.status === 'delivered' ? 'text-green-600 border-green-200' : 
                                  order.status === 'cancelled' ? 'text-red-600 border-red-200' : 
                                  'text-amber-600 border-amber-200'}`}
                              >
                                {t(`status.${order.status}`)}
                              </div>
                            </div>
                            <p className="text-sm text-muted-foreground mt-1">
                              {new Date(order.date).toLocaleDateString()} • {order.items} {t("recentOrders.items")}
                            </p>
                          </div>
                        </div>
                        <div className="flex items-center gap-4">
                          <p className="font-bold text-foreground text-lg">
                            {formatPrice(order.total)}
                          </p>
                          <Button variant="outline" size="sm" asChild>
                            <Link href={`/orders/${order.id}`}>
                              {t("actions.viewDetails")}
                            </Link>
                          </Button>
                        </div>
                      </div>
                    ))}
                  </div>
                ) : (
                  <div className="text-center py-16">
                    <div className="w-16 h-16 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
                      <Package className="h-8 w-8 text-muted-foreground" />
                    </div>
                    <h3 className="text-lg font-bold text-foreground mb-2">{t("orders.empty.title")}</h3>
                    <Button asChild>
                      <Link href="/products">{t("orders.empty.action")}</Link>
                    </Button>
                  </div>
                )}
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
