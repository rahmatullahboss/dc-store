"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Star, Check, X } from "lucide-react";
import { cn } from "@/lib/utils";

interface Review {
  id: string;
  productId: string;
  productName: string;
  userName: string | null;
  rating: number;
  title: string | null;
  content: string | null;
  isApproved: boolean;
  createdAt: string;
}

export default function AdminReviewsPage() {
  const [reviews, setReviews] = useState<Review[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [filter, setFilter] = useState<"all" | "pending" | "approved">("all");

  const fetchReviews = async () => {
    try {
      const params = new URLSearchParams();
      if (filter !== "all") params.set("status", filter);
      const res = await fetch(`/api/admin/reviews?${params}`);
      if (res.ok) {
        const data = await res.json() as { reviews: Review[] };
        setReviews(data.reviews || []);
      }
    } catch (error) {
      console.error("Failed to fetch reviews:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchReviews();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [filter]);

  const updateApproval = async (id: string, approved: boolean) => {
    try {
      const res = await fetch(`/api/admin/reviews/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ isApproved: approved }),
      });
      if (res.ok) {
        setReviews(
          reviews.map((r) => (r.id === id ? { ...r, isApproved: approved } : r))
        );
      }
    } catch (error) {
      console.error("Failed to update review:", error);
    }
  };

  const deleteReview = async (id: string) => {
    if (!confirm("Are you sure you want to delete this review?")) return;
    try {
      const res = await fetch(`/api/admin/reviews/${id}`, {
        method: "DELETE",
      });
      if (res.ok) {
        setReviews(reviews.filter((r) => r.id !== id));
      }
    } catch (error) {
      console.error("Failed to delete review:", error);
    }
  };

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-white">Reviews</h1>

      {/* Filter Tabs */}
      <div className="flex gap-2">
        {(["all", "pending", "approved"] as const).map((tab) => (
          <button
            key={tab}
            onClick={() => setFilter(tab)}
            className={cn(
              "px-4 py-2 rounded-lg text-sm font-medium capitalize transition-colors",
              filter === tab
                ? "bg-amber-500 text-black"
                : "bg-slate-800 text-slate-400 hover:text-white"
            )}
          >
            {tab}
          </button>
        ))}
      </div>

      {/* Reviews List */}
      <div className="space-y-4">
        {isLoading ? (
          <div className="p-8 text-center text-slate-400">Loading...</div>
        ) : reviews.length === 0 ? (
          <div className="bg-slate-800/50 border border-slate-700 rounded-xl p-8 text-center">
            <Star className="h-12 w-12 mx-auto text-slate-600 mb-3" />
            <p className="text-slate-400">No reviews found</p>
          </div>
        ) : (
          reviews.map((review) => (
            <div
              key={review.id}
              className="bg-slate-800/50 border border-slate-700 rounded-xl p-4"
            >
              <div className="flex items-start justify-between gap-4">
                <div className="flex-1">
                  <div className="flex items-center gap-2 mb-2">
                    <div className="flex items-center gap-0.5">
                      {[1, 2, 3, 4, 5].map((star) => (
                        <Star
                          key={star}
                          className={cn(
                            "h-4 w-4",
                            star <= review.rating
                              ? "text-amber-400 fill-amber-400"
                              : "text-slate-600"
                          )}
                        />
                      ))}
                    </div>
                    <span
                      className={cn(
                        "text-xs px-2 py-0.5 rounded-full",
                        review.isApproved
                          ? "bg-green-500/20 text-green-400"
                          : "bg-yellow-500/20 text-yellow-400"
                      )}
                    >
                      {review.isApproved ? "Approved" : "Pending"}
                    </span>
                  </div>
                  {review.title && (
                    <p className="font-medium text-white">{review.title}</p>
                  )}
                  {review.content && (
                    <p className="text-sm text-slate-300 mt-1">{review.content}</p>
                  )}
                  <div className="flex items-center gap-4 mt-3 text-xs text-slate-400">
                    <span>By: {review.userName || "Guest"}</span>
                    <span>Product: {review.productName}</span>
                    <span>{new Date(review.createdAt).toLocaleDateString()}</span>
                  </div>
                </div>

                <div className="flex items-center gap-1">
                  {!review.isApproved && (
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={() => updateApproval(review.id, true)}
                      className="text-green-400 hover:text-green-300 hover:bg-green-500/10"
                    >
                      <Check className="h-4 w-4" />
                    </Button>
                  )}
                  {review.isApproved && (
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={() => updateApproval(review.id, false)}
                      className="text-yellow-400 hover:text-yellow-300 hover:bg-yellow-500/10"
                    >
                      <X className="h-4 w-4" />
                    </Button>
                  )}
                  <Button
                    variant="ghost"
                    size="icon"
                    onClick={() => deleteReview(review.id)}
                    className="text-red-400 hover:text-red-300 hover:bg-red-500/10"
                  >
                    <X className="h-4 w-4" />
                  </Button>
                </div>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}
