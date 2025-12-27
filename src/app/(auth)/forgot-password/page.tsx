"use client";

import { useState, Suspense } from "react";
import Link from "next/link";
import { Mail, ArrowLeft, Loader2, CheckCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { siteConfig } from "@/lib/config";

function ForgotPasswordForm() {
  const [email, setEmail] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [isSuccess, setIsSuccess] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    
    if (!email) {
      setError("Please enter your email address");
      return;
    }

    setIsSubmitting(true);

    // Simulate API call
    setTimeout(() => {
      setIsSubmitting(false);
      setIsSuccess(true);
    }, 1500);
  };

  return (
    <div className="min-h-screen bg-background flex items-center justify-center p-4">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 w-full max-w-md">
        {/* Logo */}
        <div className="text-center mb-8">
          <Link href="/" className="inline-block">
            <h1 className="text-3xl font-bold brand-text">{siteConfig.name}</h1>
          </Link>
        </div>

        <Card className="border-0 shadow-xl bg-card/80 backdrop-blur">
          <CardHeader className="text-center">
            <div className="w-16 h-16 mx-auto bg-primary rounded-full flex items-center justify-center mb-4">
              {isSuccess ? (
                <CheckCircle className="w-8 h-8 text-white" />
              ) : (
                <Mail className="w-8 h-8 text-white" />
              )}
            </div>
            <CardTitle>{isSuccess ? "Check Your Email" : "Forgot Password?"}</CardTitle>
            <CardDescription>
              {isSuccess
                ? "We've sent a password reset link to your email"
                : "No worries! Enter your email and we'll send you reset instructions"}
            </CardDescription>
          </CardHeader>
          <CardContent>
            {isSuccess ? (
              <div className="space-y-4">
                <Alert className="bg-green-50 border-green-200">
                  <AlertDescription className="text-green-700">
                    If an account exists for {email}, you will receive a password reset link shortly.
                  </AlertDescription>
                </Alert>
                <p className="text-sm text-muted-foreground text-center">
                  Didn&apos;t receive the email? Check your spam folder or{" "}
                  <button
                    onClick={() => setIsSuccess(false)}
                    className="text-primary hover:underline"
                  >
                    try again
                  </button>
                </p>
                <Link href="/login" className="block">
                  <Button className="w-full bg-primary text-white">
                    Back to Login
                  </Button>
                </Link>
              </div>
            ) : (
              <form onSubmit={handleSubmit} className="space-y-4">
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
                      type="email"
                      required
                      value={email}
                      onChange={(e) => setEmail(e.target.value)}
                      placeholder="john@example.com"
                      className="pl-10"
                    />
                  </div>
                </div>

                <Button
                  type="submit"
                  className="w-full bg-primary hover:from-amber-600 hover:to-rose-600 text-white"
                  disabled={isSubmitting}
                >
                  {isSubmitting ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                      Sending...
                    </>
                  ) : (
                    "Send Reset Link"
                  )}
                </Button>
              </form>
            )}
          </CardContent>
        </Card>

        {/* Back to Login */}
        <div className="text-center mt-6">
          <Link href="/login" className="text-sm text-muted-foreground hover:text-gray-900 inline-flex items-center gap-1">
            <ArrowLeft className="h-4 w-4" />
            Back to login
          </Link>
        </div>
      </div>
    </div>
  );
}

export default function ForgotPasswordPage() {
  return (
    <Suspense fallback={<div className="min-h-screen bg-background" />}>
      <ForgotPasswordForm />
    </Suspense>
  );
}
