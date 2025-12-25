import Link from "next/link";
import Image from "next/image";
import { ArrowRight, CheckCircle, Award, Target, Heart, Zap } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { siteConfig } from "@/lib/config";
import type { Metadata } from "next";

export const metadata: Metadata = {
  title: `About Us | ${siteConfig.name}`,
  description: `Learn more about ${siteConfig.name} - our story, mission, and the team behind your favorite shopping destination.`,
};

const stats = [
  { number: "10K+", label: "Happy Customers" },
  { number: "500+", label: "Products" },
  { number: "50+", label: "Categories" },
  { number: "99%", label: "Satisfaction" },
];

const values = [
  {
    icon: Heart,
    title: "Customer First",
    description: "Every decision we make starts with our customers in mind.",
  },
  {
    icon: Award,
    title: "Quality Products",
    description: "We partner with trusted brands to bring you the best products.",
  },
  {
    icon: Zap,
    title: "Fast Delivery",
    description: "Quick and reliable delivery to your doorstep, every time.",
  },
  {
    icon: Target,
    title: "Best Prices",
    description: "Competitive pricing and regular deals to save you money.",
  },
];



export default function AboutPage() {
  return (
    <div className="min-h-screen bg-gradient-to-br from-amber-50 via-white to-rose-50">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10">
        {/* Hero Section */}
        <section className="container mx-auto px-4 py-16">
          <div className="text-center max-w-3xl mx-auto mb-16">
            <h1 className="text-4xl sm:text-5xl font-bold text-gray-800 mb-6">
              Welcome to <span className="brand-text">{siteConfig.name}</span>
            </h1>
            <p className="text-lg text-gray-600 leading-relaxed">
              We&apos;re on a mission to make online shopping easy, affordable, and delightful for everyone in Bangladesh. 
              From electronics to fashion, we bring you quality products at the best prices.
            </p>
          </div>

          {/* Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-4xl mx-auto">
            {stats.map((stat) => (
              <Card key={stat.label} className="bg-white/80 backdrop-blur text-center">
                <CardContent className="pt-6">
                  <p className="text-3xl sm:text-4xl font-bold brand-text mb-1">{stat.number}</p>
                  <p className="text-sm text-gray-500">{stat.label}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </section>

        {/* Our Story */}
        <section className="bg-white/50 py-16">
          <div className="container mx-auto px-4">
            <div className="grid lg:grid-cols-2 gap-12 items-center max-w-6xl mx-auto">
              <div>
                <h2 className="text-3xl font-bold text-gray-800 mb-6">Our Story</h2>
                <div className="space-y-4 text-gray-600">
                  <p>
                    {siteConfig.name} হলো বাংলাদেশের একটি বিশ্বস্ত অনলাইন শপিং প্ল্যাটফর্ম যেখানে আপনি পাবেন 
                    সেরা মানের পণ্য সাশ্রয়ী মূল্যে। আমরা বিশ্বাস করি অনলাইন শপিং হওয়া উচিত সহজ, নিরাপদ এবং আনন্দদায়ক।
                  </p>
                  <p>
                    আমাদের লক্ষ্য হলো গ্রাহকদের সেরা পণ্য সংগ্রহ করে দেওয়া, প্রতিযোগিতামূলক মূল্যে অফার করা 
                    এবং অসাধারণ গ্রাহক সেবা প্রদান করা। প্রতিটি পণ্য যত্ন সহকারে নির্বাচন করা হয় যাতে আপনি পান সেরা অভিজ্ঞতা।
                  </p>
                  <p>
                    এই স্টোরটি তৈরি করেছে{" "}
                    <a 
                      href="https://digitalcare.site" 
                      target="_blank" 
                      rel="noopener noreferrer" 
                      className="font-semibold text-amber-600 hover:text-amber-700 underline decoration-amber-400 underline-offset-2 transition-colors"
                    >
                      DigitalCare Team
                    </a>
                    {" "}— আমরা আধুনিক প্রযুক্তি ব্যবহার করে ব্যবসায়িক সমাধান তৈরি করি।
                  </p>
                </div>
                <div className="mt-6">
                  <Link href="/products">
                    <Button className="bg-gradient-to-r from-amber-500 to-rose-500 text-white gap-2">
                      Explore Our Products <ArrowRight className="w-4 h-4" />
                    </Button>
                  </Link>
                </div>
              </div>
              <div className="relative h-80 lg:h-96 rounded-2xl overflow-hidden">
                <Image
                  src="https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800&h=600&fit=crop"
                  alt="Our team"
                  fill
                  className="object-cover"
                />
              </div>
            </div>
          </div>
        </section>

        {/* Our Values */}
        <section className="container mx-auto px-4 py-16">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-800 mb-4">What We Stand For</h2>
            <p className="text-gray-600 max-w-2xl mx-auto">
              Our core values guide everything we do, from product selection to customer service.
            </p>
          </div>

          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6 max-w-5xl mx-auto">
            {values.map((value) => (
              <Card key={value.title} className="bg-white/80 backdrop-blur text-center hover:shadow-lg transition-shadow">
                <CardContent className="pt-6">
                  <div className="w-12 h-12 mx-auto bg-gradient-to-r from-amber-100 to-rose-100 rounded-xl flex items-center justify-center mb-4">
                    <value.icon className="w-6 h-6 text-amber-600" />
                  </div>
                  <h3 className="font-bold text-gray-800 mb-2">{value.title}</h3>
                  <p className="text-sm text-gray-500">{value.description}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </section>

        {/* Developed By Section */}
        <section className="bg-white/50 py-16">
          <div className="container mx-auto px-4">
            <div className="text-center max-w-2xl mx-auto">
              <h2 className="text-3xl font-bold text-gray-800 mb-4">Developed By</h2>
              <p className="text-gray-600 mb-6">
                এই ই-কমার্স প্ল্যাটফর্মটি ডিজাইন এবং ডেভেলপ করেছে DigitalCare Team।
              </p>
              <a 
                href="https://digitalcare.site" 
                target="_blank" 
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-amber-500 to-rose-500 text-white font-semibold rounded-xl hover:from-amber-600 hover:to-rose-600 transition-all shadow-lg hover:shadow-xl"
              >
                Visit DigitalCare
                <ArrowRight className="w-4 h-4" />
              </a>
            </div>
          </div>
        </section>

        {/* Why Choose Us */}
        <section className="container mx-auto px-4 py-16">
          <div className="bg-gradient-to-r from-amber-500 via-rose-500 to-purple-600 rounded-3xl p-8 md:p-12 text-white text-center">
            <h2 className="text-3xl font-bold mb-6">Why Shop With Us?</h2>
            <div className="grid sm:grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto mb-8">
              {[
                "Free Shipping on ৳1000+",
                "7-Day Easy Returns",
                "Secure Payments",
                "24/7 Support",
              ].map((feature) => (
                <div key={feature} className="flex items-center justify-center gap-2">
                  <CheckCircle className="w-5 h-5 text-white/80" />
                  <span>{feature}</span>
                </div>
              ))}
            </div>
            <Link href="/products">
              <Button size="lg" className="bg-white text-amber-600 hover:bg-gray-100">
                Start Shopping
              </Button>
            </Link>
          </div>
        </section>
      </div>
    </div>
  );
}
