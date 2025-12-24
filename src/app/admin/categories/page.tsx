"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Plus, Edit, Trash2, FolderTree } from "lucide-react";
import { cn } from "@/lib/utils";

interface Category {
  id: string;
  name: string;
  slug: string;
  description: string | null;
  isActive: boolean;
  sortOrder: number;
  productsCount: number;
}

export default function AdminCategoriesPage() {
  const [categories, setCategories] = useState<Category[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isAdding, setIsAdding] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [newName, setNewName] = useState("");
  const [editName, setEditName] = useState("");

  const fetchCategories = async () => {
    try {
      const res = await fetch("/api/admin/categories");
      if (res.ok) {
        const data = await res.json() as { categories: Category[] };
        setCategories(data.categories || []);
      }
    } catch (error) {
      console.error("Failed to fetch categories:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchCategories();
  }, []);

  const handleAdd = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!newName.trim()) return;

    try {
      const res = await fetch("/api/admin/categories", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name: newName.trim() }),
      });
      if (res.ok) {
        setNewName("");
        setIsAdding(false);
        fetchCategories();
      }
    } catch (error) {
      console.error("Failed to add category:", error);
    }
  };

  const handleUpdate = async (id: string) => {
    if (!editName.trim()) return;

    try {
      const res = await fetch(`/api/admin/categories/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name: editName.trim() }),
      });
      if (res.ok) {
        setEditingId(null);
        fetchCategories();
      }
    } catch (error) {
      console.error("Failed to update category:", error);
    }
  };

  const handleDelete = async (id: string) => {
    if (!confirm("Are you sure you want to delete this category?")) return;

    try {
      const res = await fetch(`/api/admin/categories/${id}`, {
        method: "DELETE",
      });
      if (res.ok) {
        fetchCategories();
      }
    } catch (error) {
      console.error("Failed to delete category:", error);
    }
  };

  const toggleStatus = async (id: string, currentStatus: boolean) => {
    try {
      const res = await fetch(`/api/admin/categories/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ isActive: !currentStatus }),
      });
      if (res.ok) {
        fetchCategories();
      }
    } catch (error) {
      console.error("Failed to toggle status:", error);
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-white">Categories</h1>
        <Button
          onClick={() => setIsAdding(true)}
          className="bg-amber-500 hover:bg-amber-600 text-black"
        >
          <Plus className="h-4 w-4 mr-2" />
          Add Category
        </Button>
      </div>

      {/* Add Form */}
      {isAdding && (
        <form onSubmit={handleAdd} className="flex gap-2 max-w-md">
          <Input
            placeholder="Category name..."
            value={newName}
            onChange={(e) => setNewName(e.target.value)}
            className="bg-slate-800 border-slate-700 text-white"
            autoFocus
          />
          <Button type="submit" className="bg-amber-500 hover:bg-amber-600 text-black">
            Add
          </Button>
          <Button
            type="button"
            variant="ghost"
            onClick={() => {
              setIsAdding(false);
              setNewName("");
            }}
            className="text-slate-400"
          >
            Cancel
          </Button>
        </form>
      )}

      {/* Categories List */}
      <div className="bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden">
        {isLoading ? (
          <div className="p-8 text-center text-slate-400">Loading...</div>
        ) : categories.length === 0 ? (
          <div className="p-8 text-center">
            <FolderTree className="h-12 w-12 mx-auto text-slate-600 mb-3" />
            <p className="text-slate-400">No categories yet</p>
          </div>
        ) : (
          <div className="divide-y divide-slate-700/50">
            {categories.map((category) => (
              <div
                key={category.id}
                className="p-4 flex items-center justify-between hover:bg-slate-800/50"
              >
                <div className="flex-1">
                  {editingId === category.id ? (
                    <form
                      onSubmit={(e) => {
                        e.preventDefault();
                        handleUpdate(category.id);
                      }}
                      className="flex gap-2 max-w-md"
                    >
                      <Input
                        value={editName}
                        onChange={(e) => setEditName(e.target.value)}
                        className="bg-slate-700 border-slate-600 text-white"
                        autoFocus
                      />
                      <Button type="submit" size="sm" className="bg-amber-500 text-black">
                        Save
                      </Button>
                      <Button
                        type="button"
                        variant="ghost"
                        size="sm"
                        onClick={() => setEditingId(null)}
                      >
                        Cancel
                      </Button>
                    </form>
                  ) : (
                    <div>
                      <p className="font-medium text-white">{category.name}</p>
                      <p className="text-xs text-slate-400">
                        {category.productsCount} products • /{category.slug}
                      </p>
                    </div>
                  )}
                </div>

                {editingId !== category.id && (
                  <div className="flex items-center gap-2">
                    <button
                      onClick={() => toggleStatus(category.id, category.isActive)}
                      className={cn(
                        "text-xs px-2 py-1 rounded-full",
                        category.isActive
                          ? "bg-green-500/20 text-green-400"
                          : "bg-slate-600/20 text-slate-400"
                      )}
                    >
                      {category.isActive ? "Active" : "Inactive"}
                    </button>
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={() => {
                        setEditingId(category.id);
                        setEditName(category.name);
                      }}
                      className="text-slate-400 hover:text-white"
                    >
                      <Edit className="h-4 w-4" />
                    </Button>
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={() => handleDelete(category.id)}
                      className="text-slate-400 hover:text-red-400"
                    >
                      <Trash2 className="h-4 w-4" />
                    </Button>
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
