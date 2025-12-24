"use client";

import { usePathname } from "next/navigation";
import { Header } from "@/components/layout/header";
import { Footer } from "@/components/layout/footer";
import { MobileBottomNav } from "@/components/layout/mobile-bottom-nav";
import { CartSheet } from "@/components/cart/cart-sheet";
import { FloatingContactButtons } from "@/components/common/floating-contact-buttons";
import { ChatBot } from "@/components/chat/chat-bot";

interface LayoutWrapperProps {
  children: React.ReactNode;
}

export function LayoutWrapper({ children }: LayoutWrapperProps) {
  const pathname = usePathname();
  const isAdminRoute = pathname?.startsWith("/admin");

  // Admin routes have their own layout - no shop components
  if (isAdminRoute) {
    return <>{children}</>;
  }

  // Shop routes get full layout with Header, Footer, etc.
  return (
    <>
      <div className="relative flex min-h-screen flex-col">
        <Header />
        <main className="flex-1 pb-16 md:pb-0">{children}</main>
        <Footer />
      </div>
      <CartSheet />
      <MobileBottomNav />
      <FloatingContactButtons />
      <ChatBot />
    </>
  );
}
