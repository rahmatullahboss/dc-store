"use client";

import { useEffect, useState } from "react";
import { formatPrice } from "@/lib/config";
import { Input } from "@/components/ui/input";
import { Search, Users, ShoppingCart } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Pagination } from "@/components/admin/pagination";
import { ExportButton } from "@/components/admin/export-button";

interface Customer {
  id: string;
  name: string;
  email: string;
  phone: string | null;
  ordersCount: number;
  totalSpent: number;
  createdAt: string;
}

const ITEMS_PER_PAGE = 20;

export default function AdminCustomersPage() {
  const [customers, setCustomers] = useState<Customer[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [search, setSearch] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  const fetchCustomers = async (page = 1) => {
    setIsLoading(true);
    try {
      const params = new URLSearchParams();
      if (search) params.set("search", search);
      params.set("page", String(page));
      params.set("limit", String(ITEMS_PER_PAGE));
      const res = await fetch(`/api/admin/customers?${params}`);
      if (res.ok) {
        const data = await res.json() as { 
          customers: Customer[]; 
          total?: number; 
          totalPages?: number 
        };
        setCustomers(data.customers || []);
        if (data.totalPages) {
          setTotalPages(data.totalPages);
        } else if (data.total) {
          setTotalPages(Math.ceil(data.total / ITEMS_PER_PAGE));
        }
        setCurrentPage(page);
      }
    } catch (error) {
      console.error("Failed to fetch customers:", error);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    fetchCustomers(1);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    fetchCustomers(1);
  };

  const handlePageChange = (page: number) => {
    fetchCustomers(page);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
        <h1 className="text-2xl font-bold text-white">Customers</h1>
        <ExportButton
          data={customers}
          filename="customers"
          columns={[
            { key: "name", header: "Name" },
            { key: "email", header: "Email" },
            { key: "phone", header: "Phone" },
            { key: "ordersCount", header: "Orders" },
            { key: "totalSpent", header: "Total Spent" },
            { key: (c) => new Date(c.createdAt).toLocaleDateString(), header: "Joined" },
          ]}
        />
      </div>

      {/* Search */}
      <form onSubmit={handleSearch} className="flex gap-2 max-w-md">
        <Input
          placeholder="Search by name or email..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="bg-slate-800 border-slate-700 text-white placeholder:text-slate-400"
        />
        <Button type="submit" variant="secondary" className="bg-slate-700 hover:bg-slate-600">
          <Search className="h-4 w-4" />
        </Button>
      </form>

      {/* Customers Table */}
      <div className="bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden">
        {isLoading ? (
          <div className="p-8 text-center text-slate-400">Loading...</div>
        ) : customers.length === 0 ? (
          <div className="p-8 text-center">
            <Users className="h-12 w-12 mx-auto text-slate-600 mb-3" />
            <p className="text-slate-400">No customers found</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-slate-700">
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Customer
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Phone
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Orders
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Total Spent
                  </th>
                  <th className="text-left text-xs font-medium text-slate-400 py-3 px-4">
                    Joined
                  </th>
                </tr>
              </thead>
              <tbody>
                {customers.map((customer) => (
                  <tr
                    key={customer.id}
                    className="border-b border-slate-700/50 hover:bg-slate-800/50 cursor-pointer"
                    onClick={() => window.location.href = `/admin/customers/${customer.id}`}
                  >
                    <td className="py-3 px-4">
                      <p className="text-sm font-medium text-white hover:text-amber-400">
                        {customer.name}
                      </p>
                      <p className="text-xs text-slate-400">{customer.email}</p>
                    </td>
                    <td className="py-3 px-4 text-sm text-slate-300">
                      {customer.phone || "—"}
                    </td>
                    <td className="py-3 px-4">
                      <div className="flex items-center gap-1 text-sm text-slate-300">
                        <ShoppingCart className="h-4 w-4 text-slate-400" />
                        {customer.ordersCount}
                      </div>
                    </td>
                    <td className="py-3 px-4 text-sm font-medium text-amber-400">
                      {formatPrice(customer.totalSpent)}
                    </td>
                    <td className="py-3 px-4 text-sm text-slate-400">
                      {new Date(customer.createdAt).toLocaleDateString()}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Pagination */}
      {totalPages > 1 && (
        <Pagination
          currentPage={currentPage}
          totalPages={totalPages}
          onPageChange={handlePageChange}
        />
      )}
    </div>
  );
}
