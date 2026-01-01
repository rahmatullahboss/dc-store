"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { Link } from "@/i18n/routing";
import { 
  ArrowLeft,
  Plus,
  MapPin,
  Home,
  Building2,
  MoreHorizontal,
  Trash2,
  Edit,
  Star,
  Loader2
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { useSession } from "@/lib/auth-client";
import { toast } from "sonner";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

interface Address {
  id: string;
  userId: string;
  name: string;
  phone: string;
  addressLine1: string;
  addressLine2?: string;
  city: string;
  state?: string;
  zipCode?: string;
  country: string;
  type: "home" | "office" | "other";
  isDefault: boolean;
  createdAt?: string;
  updatedAt?: string;
}

const emptyAddress: Omit<Address, "id" | "userId" | "createdAt" | "updatedAt"> = {
  name: "",
  phone: "",
  addressLine1: "",
  addressLine2: "",
  city: "",
  state: "",
  zipCode: "",
  country: "Bangladesh",
  type: "home",
  isDefault: false,
};

export default function AddressesPage() {
  const router = useRouter();
  const { data: session } = useSession();
  const [addresses, setAddresses] = useState<Address[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isDialogOpen, setIsDialogOpen] = useState(false);
  const [isDeleting, setIsDeleting] = useState<string | null>(null);
  const [isSaving, setIsSaving] = useState(false);
  const [editingAddress, setEditingAddress] = useState<Address | null>(null);
  const [formData, setFormData] = useState(emptyAddress);

  useEffect(() => {
    if (!session) {
      router.push("/login?redirect=/profile/addresses");
      return;
    }
    fetchAddresses();
  }, [session, router]);

  const fetchAddresses = async () => {
    try {
      const res = await fetch("/api/user/addresses");
      if (res.ok) {
        const data = await res.json() as { addresses?: Address[] };
        setAddresses(data.addresses || []);
      }
    } catch (error) {
      console.error("Error fetching addresses:", error);
      toast.error("Failed to load addresses");
    } finally {
      setIsLoading(false);
    }
  };

  const handleOpenDialog = (address?: Address) => {
    if (address) {
      setEditingAddress(address);
      setFormData({
        name: address.name,
        phone: address.phone,
        addressLine1: address.addressLine1,
        addressLine2: address.addressLine2 || "",
        city: address.city,
        state: address.state || "",
        zipCode: address.zipCode || "",
        country: address.country,
        type: address.type,
        isDefault: address.isDefault,
      });
    } else {
      setEditingAddress(null);
      setFormData(emptyAddress);
    }
    setIsDialogOpen(true);
  };

  const handleSaveAddress = async () => {
    if (!formData.name || !formData.phone || !formData.addressLine1 || !formData.city) {
      toast.error("Please fill all required fields");
      return;
    }

    setIsSaving(true);
    try {
      const method = editingAddress ? "PUT" : "POST";
      const body = editingAddress 
        ? { id: editingAddress.id, ...formData }
        : formData;

      const res = await fetch("/api/user/addresses", {
        method,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });

      if (res.ok) {
        toast.success(editingAddress ? "Address updated" : "Address added");
        setIsDialogOpen(false);
        fetchAddresses();
      } else {
        const data = await res.json() as { error?: string };
        toast.error(data.error || "Failed to save address");
      }
    } catch (error) {
      console.error("Error saving address:", error);
      toast.error("Failed to save address");
    } finally {
      setIsSaving(false);
    }
  };

  const handleDeleteAddress = async (id: string) => {
    setIsDeleting(id);
    try {
      const res = await fetch(`/api/user/addresses?id=${id}`, {
        method: "DELETE",
      });

      if (res.ok) {
        toast.success("Address deleted");
        setAddresses(addresses.filter(a => a.id !== id));
      } else {
        toast.error("Failed to delete address");
      }
    } catch (error) {
      console.error("Error deleting address:", error);
      toast.error("Failed to delete address");
    } finally {
      setIsDeleting(null);
    }
  };

  const handleSetDefault = async (address: Address) => {
    try {
      const res = await fetch("/api/user/addresses", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ ...address, isDefault: true }),
      });

      if (res.ok) {
        toast.success("Default address updated");
        fetchAddresses();
      } else {
        toast.error("Failed to update default address");
      }
    } catch (error) {
      console.error("Error updating default:", error);
      toast.error("Failed to update default address");
    }
  };

  const getTypeIcon = (type: string) => {
    switch (type) {
      case "home": return <Home className="h-4 w-4" />;
      case "office": return <Building2 className="h-4 w-4" />;
      default: return <MapPin className="h-4 w-4" />;
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <div className="sticky top-0 z-10 bg-background border-b">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Button variant="ghost" size="icon" asChild>
              <Link href="/profile">
                <ArrowLeft className="h-5 w-5" />
              </Link>
            </Button>
            <h1 className="text-xl font-bold">My Addresses</h1>
          </div>
          <Button onClick={() => handleOpenDialog()}>
            <Plus className="h-4 w-4 mr-2" />
            Add Address
          </Button>
        </div>
      </div>

      <div className="container mx-auto px-4 py-8">
        {addresses.length === 0 ? (
          <div className="text-center py-16">
            <div className="w-16 h-16 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
              <MapPin className="h-8 w-8 text-muted-foreground" />
            </div>
            <h2 className="text-lg font-bold mb-2">No addresses yet</h2>
            <p className="text-muted-foreground mb-4">Add your first delivery address</p>
            <Button onClick={() => handleOpenDialog()}>
              <Plus className="h-4 w-4 mr-2" />
              Add Address
            </Button>
          </div>
        ) : (
          <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
            {addresses.map((address) => (
              <div
                key={address.id}
                className={`bg-card rounded-xl border p-4 relative ${
                  address.isDefault ? "border-primary ring-1 ring-primary" : ""
                }`}
              >
                {address.isDefault && (
                  <div className="absolute -top-2 left-4 bg-primary text-primary-foreground text-xs px-2 py-0.5 rounded-full flex items-center gap-1">
                    <Star className="h-3 w-3" />
                    Default
                  </div>
                )}

                <div className="flex items-start justify-between mt-2">
                  <div className="flex items-center gap-2 text-muted-foreground">
                    {getTypeIcon(address.type)}
                    <span className="text-sm capitalize">{address.type}</span>
                  </div>
                  
                  <DropdownMenu>
                    <DropdownMenuTrigger asChild>
                      <Button variant="ghost" size="icon" className="h-8 w-8">
                        <MoreHorizontal className="h-4 w-4" />
                      </Button>
                    </DropdownMenuTrigger>
                    <DropdownMenuContent align="end">
                      <DropdownMenuItem onClick={() => handleOpenDialog(address)}>
                        <Edit className="h-4 w-4 mr-2" />
                        Edit
                      </DropdownMenuItem>
                      {!address.isDefault && (
                        <DropdownMenuItem onClick={() => handleSetDefault(address)}>
                          <Star className="h-4 w-4 mr-2" />
                          Set as Default
                        </DropdownMenuItem>
                      )}
                      <DropdownMenuItem 
                        className="text-destructive"
                        onClick={() => handleDeleteAddress(address.id)}
                        disabled={isDeleting === address.id}
                      >
                        {isDeleting === address.id ? (
                          <Loader2 className="h-4 w-4 mr-2 animate-spin" />
                        ) : (
                          <Trash2 className="h-4 w-4 mr-2" />
                        )}
                        Delete
                      </DropdownMenuItem>
                    </DropdownMenuContent>
                  </DropdownMenu>
                </div>

                <div className="mt-3 space-y-1">
                  <p className="font-semibold">{address.name}</p>
                  <p className="text-sm text-muted-foreground">{address.phone}</p>
                  <p className="text-sm text-muted-foreground">
                    {address.addressLine1}
                    {address.addressLine2 && <>, {address.addressLine2}</>}
                  </p>
                  <p className="text-sm text-muted-foreground">
                    {address.city}
                    {address.state && `, ${address.state}`}
                    {address.zipCode && ` ${address.zipCode}`}
                  </p>
                  <p className="text-sm text-muted-foreground">{address.country}</p>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Add/Edit Address Dialog */}
      <Dialog open={isDialogOpen} onOpenChange={setIsDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>
              {editingAddress ? "Edit Address" : "Add New Address"}
            </DialogTitle>
            <DialogDescription>
              {editingAddress 
                ? "Update your delivery address details"
                : "Add a new delivery address to your account"
              }
            </DialogDescription>
          </DialogHeader>

          <div className="grid gap-4 py-4">
            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="name">Full Name *</Label>
                <Input
                  id="name"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  placeholder="John Doe"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="phone">Phone *</Label>
                <Input
                  id="phone"
                  value={formData.phone}
                  onChange={(e) => setFormData({ ...formData, phone: e.target.value })}
                  placeholder="01712345678"
                />
              </div>
            </div>

            <div className="space-y-2">
              <Label htmlFor="addressLine1">Address Line 1 *</Label>
              <Input
                id="addressLine1"
                value={formData.addressLine1}
                onChange={(e) => setFormData({ ...formData, addressLine1: e.target.value })}
                placeholder="House/Flat No, Street Name"
              />
            </div>

            <div className="space-y-2">
              <Label htmlFor="addressLine2">Address Line 2</Label>
              <Input
                id="addressLine2"
                value={formData.addressLine2}
                onChange={(e) => setFormData({ ...formData, addressLine2: e.target.value })}
                placeholder="Area, Landmark (Optional)"
              />
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="city">City *</Label>
                <Input
                  id="city"
                  value={formData.city}
                  onChange={(e) => setFormData({ ...formData, city: e.target.value })}
                  placeholder="Dhaka"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="state">State/Division</Label>
                <Input
                  id="state"
                  value={formData.state}
                  onChange={(e) => setFormData({ ...formData, state: e.target.value })}
                  placeholder="Dhaka"
                />
              </div>
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="zipCode">Postal Code</Label>
                <Input
                  id="zipCode"
                  value={formData.zipCode}
                  onChange={(e) => setFormData({ ...formData, zipCode: e.target.value })}
                  placeholder="1212"
                />
              </div>
              <div className="space-y-2">
                <Label htmlFor="type">Address Type</Label>
                <Select
                  value={formData.type}
                  onValueChange={(value: "home" | "office" | "other") => 
                    setFormData({ ...formData, type: value })
                  }
                >
                  <SelectTrigger>
                    <SelectValue />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectItem value="home">Home</SelectItem>
                    <SelectItem value="office">Office</SelectItem>
                    <SelectItem value="other">Other</SelectItem>
                  </SelectContent>
                </Select>
              </div>
            </div>
          </div>

          <DialogFooter>
            <Button variant="outline" onClick={() => setIsDialogOpen(false)}>
              Cancel
            </Button>
            <Button onClick={handleSaveAddress} disabled={isSaving}>
              {isSaving && <Loader2 className="h-4 w-4 mr-2 animate-spin" />}
              {editingAddress ? "Update" : "Add"} Address
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
