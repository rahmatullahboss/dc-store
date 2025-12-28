"use client";

import {
  createContext,
  useContext,
  useReducer,
  useEffect,
  useCallback,
  type ReactNode,
} from "react";
import type { CartItem } from "@/db/schema";
import { toast } from "sonner";
import { authClient } from "@/lib/auth-client";

// ============================================
// Types
// ============================================

interface CartApiItem {
  id: string;
  productId: string;
  productName: string;
  productImage: string;
  price: number;
  quantity: number;
  variantId?: string;
  maxQuantity: number;
}

interface CartState {
  items: CartItem[];
  isLoading: boolean;
  isOpen: boolean;
  isSyncing: boolean;
}

type CartAction =
  | { type: "SET_ITEMS"; items: CartItem[] }
  | { type: "ADD_ITEM"; item: CartItem }
  | {
      type: "UPDATE_QUANTITY";
      productId: string;
      variantId?: string;
      quantity: number;
    }
  | { type: "REMOVE_ITEM"; productId: string; variantId?: string }
  | { type: "CLEAR_CART" }
  | { type: "SET_LOADING"; isLoading: boolean }
  | { type: "SET_SYNCING"; isSyncing: boolean }
  | { type: "TOGGLE_CART"; isOpen?: boolean };

interface CartContextType extends CartState {
  addItem: (item: CartItem) => void;
  updateQuantity: (
    productId: string,
    quantity: number,
    variantId?: string
  ) => void;
  removeItem: (productId: string, variantId?: string) => void;
  clearCart: () => void;
  toggleCart: (isOpen?: boolean) => void;
  refreshCart: () => Promise<void>;
  itemCount: number;
  subtotal: number;
}

// ============================================
// Reducer
// ============================================

function cartReducer(state: CartState, action: CartAction): CartState {
  switch (action.type) {
    case "SET_ITEMS":
      return { ...state, items: action.items, isLoading: false };

    case "ADD_ITEM": {
      const existingIndex = state.items.findIndex(
        (item) =>
          item.productId === action.item.productId &&
          item.variantId === action.item.variantId
      );

      if (existingIndex >= 0) {
        const newItems = [...state.items];
        newItems[existingIndex] = {
          ...newItems[existingIndex],
          quantity: newItems[existingIndex].quantity + action.item.quantity,
        };
        return { ...state, items: newItems };
      }

      return { ...state, items: [...state.items, action.item] };
    }

    case "UPDATE_QUANTITY": {
      if (action.quantity <= 0) {
        return {
          ...state,
          items: state.items.filter(
            (item) =>
              !(
                item.productId === action.productId &&
                item.variantId === action.variantId
              )
          ),
        };
      }

      return {
        ...state,
        items: state.items.map((item) =>
          item.productId === action.productId &&
          item.variantId === action.variantId
            ? { ...item, quantity: action.quantity }
            : item
        ),
      };
    }

    case "REMOVE_ITEM":
      return {
        ...state,
        items: state.items.filter(
          (item) =>
            !(
              item.productId === action.productId &&
              item.variantId === action.variantId
            )
        ),
      };

    case "CLEAR_CART":
      return { ...state, items: [] };

    case "SET_LOADING":
      return { ...state, isLoading: action.isLoading };

    case "SET_SYNCING":
      return { ...state, isSyncing: action.isSyncing };

    case "TOGGLE_CART":
      return { ...state, isOpen: action.isOpen ?? !state.isOpen };

    default:
      return state;
  }
}

// ============================================
// Context
// ============================================

const CartContext = createContext<CartContextType | undefined>(undefined);

const CART_STORAGE_KEY = "dc-store-cart";

interface CartProviderProps {
  children: ReactNode;
}

export function CartProvider({ children }: CartProviderProps) {
  const [state, dispatch] = useReducer(cartReducer, {
    items: [],
    isLoading: true,
    isOpen: false,
    isSyncing: false,
  });

  // Fetch cart from server if logged in, otherwise load from localStorage
  const fetchCart = useCallback(async () => {
    dispatch({ type: "SET_LOADING", isLoading: true });

    try {
      // Check if user is logged in
      const session = await authClient.getSession();

      if (session?.data?.user) {
        // Fetch cart from server
        const response = await fetch("/api/cart");
        if (response.ok) {
          const data = (await response.json()) as { cart?: { items?: CartApiItem[] } };
          const serverItems: CartItem[] = (data.cart?.items || []).map(
            (item: CartApiItem) => ({
              productId: item.productId,
              variantId: item.variantId,
              name: item.productName,
              price: item.price,
              quantity: item.quantity,
              image: item.productImage,
            })
          );
          dispatch({ type: "SET_ITEMS", items: serverItems });
          // Also save to localStorage as backup
          localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(serverItems));
          return;
        }
      }

      // Fallback to localStorage for guests or if server fails
      const savedCart = localStorage.getItem(CART_STORAGE_KEY);
      if (savedCart) {
        const items = JSON.parse(savedCart) as CartItem[];
        dispatch({ type: "SET_ITEMS", items });
      } else {
        dispatch({ type: "SET_LOADING", isLoading: false });
      }
    } catch {
      // Fallback to localStorage on error
      try {
        const savedCart = localStorage.getItem(CART_STORAGE_KEY);
        if (savedCart) {
          const items = JSON.parse(savedCart) as CartItem[];
          dispatch({ type: "SET_ITEMS", items });
        } else {
          dispatch({ type: "SET_LOADING", isLoading: false });
        }
      } catch {
        dispatch({ type: "SET_LOADING", isLoading: false });
      }
    }
  }, []);

  // Load cart on mount
  useEffect(() => {
    fetchCart();
  }, [fetchCart]);

  // Sync cart to server (debounced)
  const syncToServer = useCallback(async (items: CartItem[]) => {
    try {
      const session = await authClient.getSession();
      if (!session?.data?.user) return;

      // For now, we sync by clearing and re-adding items
      // In a production app, you'd want a more efficient sync strategy
      dispatch({ type: "SET_SYNCING", isSyncing: true });

      // Clear server cart first
      await fetch("/api/cart", { method: "DELETE" });

      // Add all items
      for (const item of items) {
        await fetch("/api/cart", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            productId: item.productId,
            quantity: item.quantity,
            variantId: item.variantId,
          }),
        });
      }

      dispatch({ type: "SET_SYNCING", isSyncing: false });
    } catch (error) {
      console.error("Cart sync error:", error);
      dispatch({ type: "SET_SYNCING", isSyncing: false });
    }
  }, []);

  // Save cart to localStorage and sync to server whenever items change
  useEffect(() => {
    if (!state.isLoading) {
      localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(state.items));
      // Debounce server sync
      const timer = setTimeout(() => {
        syncToServer(state.items);
      }, 1000);
      return () => clearTimeout(timer);
    }
  }, [state.items, state.isLoading, syncToServer]);

  const addItem = useCallback(async (item: CartItem) => {
    dispatch({ type: "ADD_ITEM", item });
    toast.success(`${item.name} added to cart`);
  }, []);

  const updateQuantity = useCallback(
    (productId: string, quantity: number, variantId?: string) => {
      dispatch({ type: "UPDATE_QUANTITY", productId, variantId, quantity });
    },
    []
  );

  const removeItem = useCallback((productId: string, variantId?: string) => {
    dispatch({ type: "REMOVE_ITEM", productId, variantId });
    toast.success("Item removed from cart");
  }, []);

  const clearCart = useCallback(async () => {
    dispatch({ type: "CLEAR_CART" });
    // Also clear on server
    try {
      const session = await authClient.getSession();
      if (session?.data?.user) {
        await fetch("/api/cart", { method: "DELETE" });
      }
    } catch {
      // Ignore
    }
  }, []);

  const toggleCart = useCallback((isOpen?: boolean) => {
    dispatch({ type: "TOGGLE_CART", isOpen });
  }, []);

  const itemCount = state.items.reduce((sum, item) => sum + item.quantity, 0);
  const subtotal = state.items.reduce(
    (sum, item) => sum + item.price * item.quantity,
    0
  );

  return (
    <CartContext.Provider
      value={{
        ...state,
        addItem,
        updateQuantity,
        removeItem,
        clearCart,
        toggleCart,
        refreshCart: fetchCart,
        itemCount,
        subtotal,
      }}
    >
      {children}
    </CartContext.Provider>
  );
}

export function useCart() {
  const context = useContext(CartContext);
  if (!context) {
    throw new Error("useCart must be used within a CartProvider");
  }
  return context;
}
