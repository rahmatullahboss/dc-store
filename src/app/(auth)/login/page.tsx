"use client";

import React, { useState, Suspense } from "react";
import Link from "next/link";
import { useRouter, useSearchParams } from "next/navigation";
import { Mail, Lock, ArrowLeft, Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Checkbox } from "@/components/ui/checkbox";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { signIn } from "@/lib/auth-client";
import { siteConfig } from "@/lib/config";

function LoginForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [formData, setFormData] = useState({
    email: "",
    password: "",
  });
  const [rememberMe, setRememberMe] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState("");

  const message = searchParams.get("message");
  const callbackUrl = searchParams.get("callbackUrl") || "/";

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    setError("");

    if (!formData.email || !formData.password) {
      setError("Email and password are required");
      setIsSubmitting(false);
      return;
    }

    try {
      const result = await signIn.email({
        email: formData.email,
        password: formData.password,
        callbackURL: callbackUrl,
      });

      if (result.error) {
        setError(result.error.message || "Login failed. Please check your credentials.");
      } else {
        router.push(callbackUrl);
        router.refresh();
      }
    } catch {
      setError("Login failed. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleGoogleLogin = async () => {
    try {
      await signIn.social({
        provider: "google",
        callbackURL: callbackUrl,
      });
    } catch {
      setError("Google login failed. Please try again.");
    }
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 min-h-screen flex">
        {/* Left side - Branding (hidden on mobile) */}
        <div className="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-amber-500 via-rose-500 to-purple-600 p-12 items-center justify-center relative overflow-hidden">
          {/* Decorative circles */}
          <div className="absolute top-20 left-10 w-32 h-32 bg-card/10 rounded-full blur-xl" />
          <div className="absolute bottom-20 right-10 w-48 h-48 bg-card/10 rounded-full blur-xl" />
          <div className="absolute top-1/2 left-1/3 w-24 h-24 bg-card/10 rounded-full blur-xl" />

          <div className="relative z-10 text-center text-white">
            <h1 className="text-5xl font-bold mb-4">{siteConfig.name}</h1>
            <p className="text-xl text-white/90 mb-8 max-w-md">
              Welcome back! Sign in to access your account, track orders, and enjoy exclusive offers.
            </p>
            <div className="flex flex-wrap gap-3 justify-center">
              <span className="bg-card/20 px-4 py-2 rounded-full text-sm">⚡ Fast Checkout</span>
              <span className="bg-card/20 px-4 py-2 rounded-full text-sm">📦 Track Orders</span>
              <span className="bg-card/20 px-4 py-2 rounded-full text-sm">❤️ Wishlist</span>
            </div>
          </div>
        </div>

        {/* Right side - Login Form */}
        <div className="w-full lg:w-1/2 flex items-center justify-center p-6 sm:p-12">
          <div className="max-w-md w-full space-y-6">
            {/* Mobile logo */}
            <div className="lg:hidden text-center mb-8">
              <Link href="/" className="inline-block">
                <h1 className="text-3xl font-bold brand-text">{siteConfig.name}</h1>
              </Link>
            </div>

            <div className="text-center space-y-1">
              <h2 className="text-2xl font-bold text-foreground">Sign in to your account</h2>
              <p className="text-sm text-muted-foreground">
                Don&apos;t have an account?{" "}
                <Link href="/register" className="font-medium text-primary hover:text-primary">
                  Sign up
                </Link>
              </p>
            </div>

            <Card className="border-0 shadow-xl bg-card/80 backdrop-blur">
              <CardHeader>
                <CardTitle>Welcome back</CardTitle>
                <CardDescription>Enter your email and password to sign in</CardDescription>
              </CardHeader>
              <CardContent>
                <form onSubmit={handleSubmit} className="space-y-4">
                  {message && (
                    <Alert className="bg-green-50 border-green-200">
                      <AlertDescription className="text-green-700">{message}</AlertDescription>
                    </Alert>
                  )}

                  {error && (
                    <Alert variant="destructive">
                      <AlertDescription>{error}</AlertDescription>
                    </Alert>
                  )}

                  <div className="space-y-2">
                    <label htmlFor="email" className="text-sm font-medium text-foreground">
                      Email address
                    </label>
                    <div className="relative">
                      <Mail className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                      <Input
                        id="email"
                        name="email"
                        type="email"
                        required
                        value={formData.email}
                        onChange={handleInputChange}
                        placeholder="john@example.com"
                        className="pl-10"
                      />
                    </div>
                  </div>

                  <div className="space-y-2">
                    <div className="flex items-center justify-between">
                      <label htmlFor="password" className="text-sm font-medium text-foreground">
                        Password
                      </label>
                      <Link
                        href="/forgot-password"
                        className="text-sm font-medium text-primary hover:text-primary"
                      >
                        Forgot password?
                      </Link>
                    </div>
                    <div className="relative">
                      <Lock className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                      <Input
                        id="password"
                        name="password"
                        type="password"
                        required
                        value={formData.password}
                        onChange={handleInputChange}
                        placeholder="••••••••"
                        className="pl-10"
                      />
                    </div>
                  </div>

                  <div className="flex items-center gap-2">
                    <Checkbox
                      id="remember-me"
                      checked={rememberMe}
                      onCheckedChange={(checked) => setRememberMe(checked === true)}
                    />
                    <label htmlFor="remember-me" className="text-sm text-muted-foreground select-none cursor-pointer">
                      Keep me logged in
                    </label>
                  </div>

                  <Button
                    type="submit"
                    className="w-full bg-primary hover:from-amber-600 hover:to-rose-600 text-white"
                    disabled={isSubmitting}
                  >
                    {isSubmitting ? (
                      <>
                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                        Signing in...
                      </>
                    ) : (
                      "Sign in"
                    )}
                  </Button>

                  {/* Divider */}
                  <div className="relative my-4">
                    <div className="absolute inset-0 flex items-center">
                      <span className="w-full border-t" />
                    </div>
                    <div className="relative flex justify-center text-xs uppercase">
                      <span className="bg-card px-2 text-muted-foreground">Or continue with</span>
                    </div>
                  </div>

                  {/* Google OAuth Button */}
                  <Button
                    type="button"
                    variant="outline"
                    className="w-full"
                    onClick={handleGoogleLogin}
                  >
                    <svg className="h-5 w-5 mr-2" viewBox="0 0 24 24">
                      <path
                        d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"
                        fill="#4285F4"
                      />
                      <path
                        d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"
                        fill="#34A853"
                      />
                      <path
                        d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"
                        fill="#FBBC05"
                      />
                      <path
                        d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"
                        fill="#EA4335"
                      />
                    </svg>
                    Continue with Google
                  </Button>
                </form>
              </CardContent>
            </Card>

            {/* Back to Home */}
            <div className="text-center">
              <Link href="/" className="text-sm text-muted-foreground hover:text-foreground inline-flex items-center gap-1">
                <ArrowLeft className="h-4 w-4" />
                Back to home
              </Link>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

// Loading skeleton
function LoginSkeleton() {
  return (
    <div className="min-h-screen bg-background flex items-center justify-center">
      <div className="max-w-md w-full p-6 space-y-6">
        <div className="text-center space-y-2">
          <div className="h-8 w-64 bg-muted rounded-lg mx-auto animate-pulse" />
          <div className="h-4 w-48 bg-muted rounded-lg mx-auto animate-pulse" />
        </div>
        <div className="bg-card rounded-lg border p-6 space-y-4">
          <div className="h-6 w-32 bg-muted rounded animate-pulse" />
          <div className="h-10 w-full bg-muted rounded-md animate-pulse" />
          <div className="h-10 w-full bg-muted rounded-md animate-pulse" />
          <div className="h-10 w-full bg-muted rounded-md animate-pulse" />
        </div>
      </div>
    </div>
  );
}

export default function LoginPage() {
  return (
    <Suspense fallback={<LoginSkeleton />}>
      <LoginForm />
    </Suspense>
  );
}
