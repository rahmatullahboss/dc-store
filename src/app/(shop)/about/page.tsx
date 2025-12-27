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
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10">
        {/* Hero Section */}
        <section className="container mx-auto px-4 py-16">
          <div className="text-center max-w-3xl mx-auto mb-16">
            <h1 className="text-4xl sm:text-5xl font-bold text-foreground mb-6">
              Welcome to <span className="brand-text">{siteConfig.name}</span>
            </h1>
            <p className="text-lg text-muted-foreground leading-relaxed">
              We&apos;re on a mission to make online shopping easy, affordable, and delightful for everyone in Bangladesh. 
              From electronics to fashion, we bring you quality products at the best prices.
            </p>
          </div>

          {/* Stats */}
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4 max-w-4xl mx-auto">
            {stats.map((stat) => (
              <Card key={stat.label} className="bg-card/80 backdrop-blur text-center">
                <CardContent className="pt-6">
                  <p className="text-3xl sm:text-4xl font-bold brand-text mb-1">{stat.number}</p>
                  <p className="text-sm text-muted-foreground">{stat.label}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </section>

        {/* Our Story */}
        <section className="bg-card/50 py-16">
          <div className="container mx-auto px-4">
            <div className="grid lg:grid-cols-2 gap-12 items-center max-w-6xl mx-auto">
              <div>
                <h2 className="text-3xl font-bold text-foreground mb-6">Our Story</h2>
                <div className="space-y-4 text-muted-foreground">
                  <p>
                    {siteConfig.name} is a trusted online shopping platform in Bangladesh where you can find 
                    quality products at affordable prices. We believe online shopping should be easy, safe, and enjoyable.
                  </p>
                  <p>
                    Our goal is to bring you the best products, offer competitive prices, 
                    and provide exceptional customer service. Every product is carefully selected to ensure you get the best experience.
                  </p>
                  <p>
                    This store is developed by{" "}
                    <a 
                      href="https://digitalcare.site" 
                      target="_blank" 
                      rel="noopener noreferrer" 
                      className="font-semibold text-primary hover:text-amber-700 underline decoration-amber-400 underline-offset-2 transition-colors"
                    >
                      DigitalCare Team
                    </a>
                    {" "}— we build modern business solutions using the latest technology.
                  </p>
                </div>
                <div className="mt-6">
                  <Link href="/products">
                    <Button className="bg-primary text-white gap-2">
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
            <h2 className="text-3xl font-bold text-foreground mb-4">What We Stand For</h2>
            <p className="text-muted-foreground max-w-2xl mx-auto">
              Our core values guide everything we do, from product selection to customer service.
            </p>
          </div>

          <div className="grid sm:grid-cols-2 lg:grid-cols-4 gap-6 max-w-5xl mx-auto">
            {values.map((value) => (
              <Card key={value.title} className="bg-card/80 backdrop-blur text-center hover:shadow-lg transition-shadow">
                <CardContent className="pt-6">
                  <div className="w-12 h-12 mx-auto bg-gradient-to-r from-amber-100 to-rose-100 rounded-xl flex items-center justify-center mb-4">
                    <value.icon className="w-6 h-6 text-primary" />
                  </div>
                  <h3 className="font-bold text-foreground mb-2">{value.title}</h3>
                  <p className="text-sm text-muted-foreground">{value.description}</p>
                </CardContent>
              </Card>
            ))}
          </div>
        </section>

        {/* Developed By Section */}
        <section className="bg-card/50 py-16">
          <div className="container mx-auto px-4">
            <div className="text-center max-w-2xl mx-auto">
              <h2 className="text-3xl font-bold text-foreground mb-4">Developed By</h2>
              <p className="text-muted-foreground mb-6">
                This e-commerce platform is designed and developed by DigitalCare Team.
              </p>
              <a 
                href="https://digitalcare.site" 
                target="_blank" 
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 px-6 py-3 bg-primary text-white font-semibold rounded-xl hover:from-amber-600 hover:to-rose-600 transition-all shadow-lg hover:shadow-xl"
              >
                Visit DigitalCare
                <ArrowRight className="w-4 h-4" />
              </a>
            </div>
          </div>
        </section>

        {/* Why Choose Us */}
        <section className="container mx-auto px-4 py-16">
          <div className="bg-primary rounded-3xl p-8 md:p-12 text-white text-center">
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
              <Button size="lg" className="bg-card text-primary hover:bg-muted">
                Start Shopping
              </Button>
            </Link>
          </div>
        </section>
      </div>
    </div>
  );
}
