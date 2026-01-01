"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { Link, useRouter } from "@/i18n/routing";
import Image from "next/image";
import { 
  ArrowLeft, 
  Package, 
  Truck, 
  CheckCircle, 
  Clock, 
  XCircle, 
  MapPin, 
  Phone, 
  Mail,
  Loader2,
  CreditCard,
  RefreshCw,
  FileText
} from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { formatPrice } from "@/lib/config";
import { useSession } from "@/lib/auth-client";

const statusConfig = {
  pending: { label: "Pending", color: "bg-yellow-100 text-yellow-800", icon: Clock },
  confirmed: { label: "Confirmed", color: "bg-blue-100 text-blue-800", icon: CheckCircle },
  processing: { label: "Processing", color: "bg-purple-100 text-purple-800", icon: Package },
  shipped: { label: "Shipped", color: "bg-indigo-100 text-indigo-800", icon: Truck },
  delivered: { label: "Delivered", color: "bg-green-100 text-green-800", icon: CheckCircle },
  cancelled: { label: "Cancelled", color: "bg-red-100 text-red-800", icon: XCircle },
  refunded: { label: "Refunded", color: "bg-muted text-foreground", icon: XCircle },
};

interface OrderItem {
  productId: string;
  name: string;
  price: number;
  quantity: number;
  image?: string;
}

interface ShippingAddress {
  name: string;
  phone: string;
  address: string;
  city: string;
  state?: string;
  country: string;
}

interface Order {
  id: string;
  orderNumber: string;
  status: string;
  paymentStatus: string;
  paymentMethod: string;
  subtotal: number;
  shippingCost: number;
  total: number;
  items: OrderItem[];
  shippingAddress: ShippingAddress;
  createdAt: string;
}

export default function OrderDetailsPage() {
  const params = useParams();
  const router = useRouter();
  const { data: session, isPending: isSessionLoading } = useSession();
  const [order, setOrder] = useState<Order | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    async function fetchOrder() {
      if (!session?.user || !params.id) return;
      
      try {
        const res = await fetch(`/api/user/orders/${params.id}`);
        if (res.ok) {
          const data = await res.json() as { order: Order };
          setOrder(data.order);
        } else if (res.status === 404) {
          setError("Order not found");
        } else {
          setError("Failed to load order");
        }
      } catch {
        setError("Failed to load order");
      } finally {
        setIsLoading(false);
      }
    }

    if (session?.user) {
      fetchOrder();
    } else if (!isSessionLoading) {
      router.push("/login?redirect=/orders");
    }
  }, [session, isSessionLoading, params.id, router]);

  if (isSessionLoading || isLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (error || !order) {
    return (
      <div className="min-h-screen bg-background">
        <div className="container mx-auto px-4 py-16 text-center">
          <Package className="h-16 w-16 mx-auto mb-4 text-muted-foreground" />
          <h1 className="text-2xl font-bold text-foreground mb-2">
            {error || "Order not found"}
          </h1>
          <p className="text-muted-foreground mb-6">
          The order you&apos;re looking for doesn&apos;t exist or you don&apos;t have access to it.
          </p>
          <Button asChild>
            <Link href="/orders">Back to Orders</Link>
          </Button>
        </div>
      </div>
    );
  }

  const status = statusConfig[order.status as keyof typeof statusConfig] || statusConfig.pending;
  const StatusIcon = status.icon;

  return (
    <div className="min-h-screen bg-background">
      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Header */}
        <div className="flex items-center gap-4 mb-8">
          <Button variant="ghost" size="icon" asChild>
            <Link href="/orders">
              <ArrowLeft className="h-5 w-5" />
            </Link>
          </Button>
          <div className="flex-1">
            <h1 className="text-2xl font-bold text-foreground">
              Order #{order.orderNumber}
            </h1>
            <p className="text-muted-foreground">
              Placed on {new Date(order.createdAt).toLocaleDateString("en-US", {
                year: "numeric",
                month: "long",
                day: "numeric",
              })}
            </p>
          </div>
          <Badge className={`${status.color} gap-1 text-sm px-3 py-1`}>
            <StatusIcon className="h-4 w-4" />
            {status.label}
          </Badge>
        </div>

        <div className="grid lg:grid-cols-3 gap-6">
          {/* Order Items */}
          <div className="lg:col-span-2 space-y-6">
            <Card className="shadow-lg border-0">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <Package className="h-5 w-5 text-primary" />
                  Order Items ({order.items?.length || 0})
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-4">
                  {order.items?.map((item, index) => (
                    <div key={index} className="flex gap-4">
                      <div className="relative h-20 w-20 flex-shrink-0 rounded-xl bg-muted overflow-hidden">
                        {item.image ? (
                          <Image
                            src={item.image}
                            alt={item.name}
                            fill
                            className="object-cover"
                          />
                        ) : (
                          <div className="flex h-full items-center justify-center text-muted-foreground">
                            <Package className="h-8 w-8" />
                          </div>
                        )}
                      </div>
                      <div className="flex-1 min-w-0">
                        <h4 className="font-medium text-foreground line-clamp-2">
                          {item.name}
                        </h4>
                        <p className="text-sm text-muted-foreground">Qty: {item.quantity}</p>
                        <p className="font-bold text-primary">
                          {formatPrice(item.price * item.quantity)}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Shipping Address */}
            <Card className="shadow-lg border-0">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <MapPin className="h-5 w-5 text-primary" />
                  Shipping Address
                </CardTitle>
              </CardHeader>
              <CardContent>
                {order.shippingAddress && (
                  <div className="space-y-2">
                    <p className="font-medium text-foreground">{order.shippingAddress.name}</p>
                    <p className="text-muted-foreground flex items-center gap-2">
                      <Phone className="h-4 w-4" />
                      {order.shippingAddress.phone}
                    </p>
                    <p className="text-muted-foreground">
                      {order.shippingAddress.address}
                    </p>
                    <p className="text-muted-foreground">
                      {order.shippingAddress.city}
                      {order.shippingAddress.state && `, ${order.shippingAddress.state}`}
                    </p>
                    <p className="text-muted-foreground">{order.shippingAddress.country}</p>
                  </div>
                )}
              </CardContent>
            </Card>

            {/* Shipping Progress Tracker */}
            {order.status !== "cancelled" && order.status !== "refunded" && (
              <Card className="shadow-lg border-0">
                <CardHeader>
                  <CardTitle className="flex items-center gap-2">
                    <Truck className="h-5 w-5 text-primary" />
                    Shipping Progress
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  {(() => {
                    const stages = [
                      { key: "pending", label: "Order Placed", icon: Clock, description: "We received your order" },
                      { key: "confirmed", label: "Confirmed", icon: CheckCircle, description: "Order confirmed by seller" },
                      { key: "processing", label: "Processing", icon: Package, description: "Preparing your order" },
                      { key: "shipped", label: "Shipped", icon: Truck, description: "On the way to you" },
                      { key: "delivered", label: "Delivered", icon: CheckCircle, description: "Successfully delivered" },
                    ];
                    
                    const currentIndex = stages.findIndex(s => s.key === order.status);
                    const orderDate = new Date(order.createdAt);
                    
                    return (
                      <div className="space-y-4">
                        {stages.map((stage, index) => {
                          const StageIcon = stage.icon;
                          const isCompleted = index <= currentIndex;
                          const isCurrent = index === currentIndex;
                          const isLast = index === stages.length - 1;
                          
                          // Estimate date for each stage
                          const stageDate = new Date(orderDate);
                          stageDate.setDate(stageDate.getDate() + index);
                          
                          return (
                            <div key={stage.key} className="relative">
                              <div className="flex items-start gap-4">
                                {/* Timeline connector */}
                                <div className="flex flex-col items-center">
                                  <div className={`w-10 h-10 rounded-full flex items-center justify-center ${
                                    isCompleted 
                                      ? "bg-primary text-white" 
                                      : "bg-muted text-muted-foreground"
                                  } ${isCurrent ? "ring-4 ring-amber-200" : ""}`}>
                                    <StageIcon className="h-5 w-5" />
                                  </div>
                                  {!isLast && (
                                    <div className={`w-0.5 h-12 ${
                                      index < currentIndex ? "bg-primary" : "bg-muted"
                                    }`} />
                                  )}
                                </div>
                                
                                {/* Stage info */}
                                <div className="flex-1 pb-8">
                                  <div className="flex items-center justify-between">
                                    <h4 className={`font-semibold ${
                                      isCompleted ? "text-foreground" : "text-muted-foreground"
                                    }`}>
                                      {stage.label}
                                      {isCurrent && (
                                        <Badge className="ml-2 bg-amber-100 text-amber-700 text-xs">
                                          Current
                                        </Badge>
                                      )}
                                    </h4>
                                    {isCompleted && (
                                      <span className="text-xs text-muted-foreground">
                                        {index === currentIndex 
                                          ? new Date(order.createdAt).toLocaleDateString()
                                          : stageDate.toLocaleDateString()
                                        }
                                      </span>
                                    )}
                                  </div>
                                  <p className={`text-sm ${
                                    isCompleted ? "text-muted-foreground" : "text-muted-foreground"
                                  }`}>
                                    {stage.description}
                                  </p>
                                </div>
                              </div>
                            </div>
                          );
                        })}
                        
                        {/* Estimated Delivery */}
                        {order.status !== "delivered" && (
                          <div className="mt-4 p-4 bg-amber-50 rounded-xl">
                            <p className="text-sm text-amber-800">
                              <strong>Estimated Delivery:</strong>{" "}
                              {(() => {
                                const deliveryDate = new Date(orderDate);
                                deliveryDate.setDate(deliveryDate.getDate() + 5); // 5 days estimate
                                return deliveryDate.toLocaleDateString("en-US", {
                                  weekday: "long",
                                  month: "long",
                                  day: "numeric"
                                });
                              })()}
                            </p>
                          </div>
                        )}
                      </div>
                    );
                  })()}
                </CardContent>
              </Card>
            )}
          </div>

          {/* Order Summary Sidebar */}
          <div className="space-y-6">
            <Card className="shadow-lg border-0">
              <CardHeader>
                <CardTitle>Order Summary</CardTitle>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="flex justify-between text-muted-foreground">
                  <span>Subtotal</span>
                  <span>{formatPrice(order.subtotal)}</span>
                </div>
                <div className="flex justify-between text-muted-foreground">
                  <span>Shipping</span>
                  <span className={order.shippingCost === 0 ? "text-green-600 font-medium" : ""}>
                    {order.shippingCost === 0 ? "FREE" : formatPrice(order.shippingCost)}
                  </span>
                </div>
                <Separator />
                <div className="flex justify-between text-lg font-bold">
                  <span>Total</span>
                  <span className="text-primary">{formatPrice(order.total)}</span>
                </div>
              </CardContent>
            </Card>

            <Card className="shadow-lg border-0">
              <CardHeader>
                <CardTitle className="flex items-center gap-2">
                  <CreditCard className="h-5 w-5 text-primary" />
                  Payment
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Method</span>
                    <span className="font-medium">
                      {order.paymentMethod === "cod" ? "Cash on Delivery" : order.paymentMethod}
                    </span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-muted-foreground">Status</span>
                    <Badge variant={order.paymentStatus === "paid" ? "default" : "secondary"}>
                      {order.paymentStatus}
                    </Badge>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Actions */}
            <div className="space-y-3">
              {order.status === "shipped" && (
                <Button className="w-full bg-primary text-white" asChild>
                  <Link href={`/track-order?order=${order.orderNumber}`}>
                    <Truck className="h-4 w-4 mr-2" />
                    Track Order
                  </Link>
                </Button>
              )}
              {order.status === "delivered" && (
                <Button className="w-full" variant="outline">
                  <RefreshCw className="h-4 w-4 mr-2" />
                  Reorder
                </Button>
              )}
              <Button 
                variant="outline" 
                className="w-full"
                onClick={() => window.open(`/api/user/orders/${order.id}/invoice`, '_blank')}
              >
                <FileText className="h-4 w-4 mr-2" />
                Download Invoice
              </Button>
              <Button 
                variant="outline" 
                className="w-full"
                onClick={() => window.dispatchEvent(new CustomEvent("open-chatbot"))}
              >
                <Mail className="h-4 w-4 mr-2" />
                Need Help?
              </Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
