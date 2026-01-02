"use client";

import { LanguageSwitcher } from "@/components/common/language-switcher";
import { Link, useRouter } from "@/i18n/routing";
import { useState } from "react";
import { Menu, Search, ShoppingCart, User, X, LogOut } from "lucide-react";
import { ThemeToggle } from "@/components/common/theme-toggle";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Sheet, SheetContent, SheetTrigger } from "@/components/ui/sheet";
import { Badge } from "@/components/ui/badge";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import { useCart } from "@/lib/cart-context";
import { useSession, signOut } from "@/lib/auth-client";
import { siteConfig } from "@/lib/config";



import { useTranslations } from "next-intl";

export function Header() {
  const t = useTranslations();
  const [isSearchOpen, setIsSearchOpen] = useState(false);
  const { itemCount, toggleCart } = useCart();
  const { data: session, isPending } = useSession();
  const router = useRouter();

  const navigation = [
    { name: t('Navigation.home'), href: "/" },
    { name: t('Navigation.products'), href: "/products" },
    { name: t('Navigation.categories'), href: "/categories" },
    { name: t('Navigation.about'), href: "/about" },
    { name: t('Navigation.contact'), href: "/contact" },
  ];

  const handleSignOut = async () => {
    await signOut();
    router.push("/");
    router.refresh();
  };

  return (
    <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
      <div className="container mx-auto flex h-16 items-center px-4">
        {/* Mobile Menu */}
        <Sheet>
          <SheetTrigger asChild className="md:hidden">
            <Button variant="ghost" size="icon">
              <Menu className="h-5 w-5" />
              <span className="sr-only">{t('Common.toggleMenu')}</span>
            </Button>
          </SheetTrigger>
          <SheetContent side="left" className="w-[300px] p-6">
            <nav className="flex flex-col gap-4 mt-6">
              {navigation.map((item) => (
                <Link
                  key={item.href} // Changed key to href as name is now localized and might change
                  href={item.href}
                  className="text-lg font-medium hover:text-primary transition-colors"
                >
                  {item.name}
                </Link>
              ))}
              {session?.user && (
                <>
                  <Link
                    href="/profile"
                    className="text-lg font-medium hover:text-primary transition-colors"
                  >
                    {t('Common.profile')}
                  </Link>
                  <Link
                    href="/orders"
                    className="text-lg font-medium hover:text-primary transition-colors"
                  >
                    {t('Common.orders')}
                  </Link>
                </>
              )}
            </nav>
          </SheetContent>
        </Sheet>

        {/* Logo - Centered on mobile */}
        <Link href="/" className="flex items-center gap-2 flex-1 justify-center md:flex-none md:justify-start md:mr-6">
          {/* eslint-disable-next-line @next/next/no-img-element */}
          <img src="https://res.cloudinary.com/dpnccgsja/image/upload/f_auto,q_auto,w_64/dc-store/logo" alt="DC Store" className="h-8 w-8 object-contain" />
          <span className="text-xl font-bold tracking-tight">
            {siteConfig.name}
          </span>
        </Link>

        {/* Desktop Navigation - Centered */}
        <nav className="hidden md:flex items-center justify-center gap-6 flex-1">
          {navigation.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              className="text-sm font-medium text-muted-foreground hover:text-primary transition-colors"
            >
              {item.name}
            </Link>
          ))}
        </nav>

        {/* Actions */}
        <div className="flex items-center gap-2 ml-auto md:ml-0">
          {/* Search */}
          {isSearchOpen ? (
            <form 
              onSubmit={(e) => {
                e.preventDefault();
                const formData = new FormData(e.currentTarget);
                const query = formData.get("search") as string;
                if (query.trim()) {
                  router.push(`/products?search=${encodeURIComponent(query.trim())}`);
                  setIsSearchOpen(false);
                }
              }}
              className="absolute left-0 right-0 top-0 z-50 flex h-16 items-center gap-2 bg-background px-4"
            >
              <Input
                name="search"
                placeholder={t('Common.searchPlaceholder')}
                className="flex-1"
                autoFocus
              />
              <Button
                type="button"
                variant="ghost"
                size="icon"
                onClick={() => setIsSearchOpen(false)}
              >
                <X className="h-5 w-5" />
              </Button>
            </form>
          ) : (
            <Button
              variant="ghost"
              size="icon"
              onClick={() => setIsSearchOpen(true)}
            >
              <Search className="h-5 w-5" />
              <span className="sr-only">{t('Common.search')}</span>
            </Button>
          )}

          {/* Theme Toggle */}
          <LanguageSwitcher />
          <ThemeToggle />

          {/* User - Session Aware */}
          {isPending ? (
            <Button variant="ghost" size="icon" disabled>
              <User className="h-5 w-5 animate-pulse" />
            </Button>
          ) : session?.user ? (
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="icon" className="relative">
                  <Avatar className="h-8 w-8">
                    <AvatarImage src={session.user.image || undefined} alt={session.user.name || ""} />
                    <AvatarFallback className="text-xs brand-gradient text-white">
                      {session.user.name?.charAt(0).toUpperCase() || "U"}
                    </AvatarFallback>
                  </Avatar>
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent align="end" className="w-48">
                <div className="px-2 py-1.5">
                  <p className="text-sm font-medium">{session.user.name}</p>
                  <p className="text-xs text-muted-foreground truncate">{session.user.email}</p>
                </div>
                <DropdownMenuSeparator />
                <DropdownMenuItem asChild>
                  <Link href="/profile" className="cursor-pointer">
                    <User className="mr-2 h-4 w-4" />
                    Profile
                  </Link>
                </DropdownMenuItem>
                <DropdownMenuItem asChild>
                  <Link href="/orders" className="cursor-pointer">
                    <ShoppingCart className="mr-2 h-4 w-4" />
                    My Orders
                  </Link>
                </DropdownMenuItem>
                <DropdownMenuSeparator />
                <DropdownMenuItem onClick={handleSignOut} className="cursor-pointer text-red-600">
                  <LogOut className="mr-2 h-4 w-4" />
                  Sign Out
                </DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          ) : (
            <Link href="/login">
              <Button variant="ghost" size="icon">
                <User className="h-5 w-5" />
                <span className="sr-only">Account</span>
              </Button>
            </Link>
          )}

          {/* Cart */}
          <Button
            variant="ghost"
            size="icon"
            className="relative"
            onClick={() => toggleCart()}
          >
            <ShoppingCart className="h-5 w-5" />
            {itemCount > 0 && (
              <Badge
                variant="destructive"
                className="absolute -top-1 -right-1 h-5 w-5 rounded-full p-0 flex items-center justify-center text-xs"
              >
                {itemCount > 99 ? "99+" : itemCount}
              </Badge>
            )}
            <span className="sr-only">Cart</span>
          </Button>
        </div>
      </div>
    </header>
  );
}
