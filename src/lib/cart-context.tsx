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

// ============================================
// Types
// ============================================

interface CartState {
  items: CartItem[];
  isLoading: boolean;
  isOpen: boolean;
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
  });

  // Load cart from localStorage on mount
  useEffect(() => {
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
  }, []);

  // Save cart to localStorage whenever items change
  useEffect(() => {
    if (!state.isLoading) {
      localStorage.setItem(CART_STORAGE_KEY, JSON.stringify(state.items));
    }
  }, [state.items, state.isLoading]);

  const addItem = useCallback((item: CartItem) => {
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

  const clearCart = useCallback(() => {
    dispatch({ type: "CLEAR_CART" });
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
