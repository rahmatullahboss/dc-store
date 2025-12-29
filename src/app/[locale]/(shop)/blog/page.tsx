import { Link } from "@/i18n/routing";
import Image from "next/image";
import { Calendar, Clock, User, ArrowRight, BookOpen } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { siteConfig } from "@/lib/config";

import { useTranslations } from "next-intl";
import { getTranslations } from "next-intl/server";

// Make this page fully static - no ISR, no KV writes
export const dynamic = "force-static";

export async function generateMetadata({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params;
  const t = await getTranslations({ locale, namespace: "Blog" });
  
  return {
    title: `${t("title")} | ${siteConfig.name}`,
    description: t("subtitle"),
  };
}

// Demo blog posts
const blogPosts = [
  {
    id: "1",
    slug: "top-10-gadgets-2024",
    title: "Top 10 Must-Have Gadgets for 2024",
    excerpt: "Discover the cutting-edge technology that's shaping our world. From smart home devices to wearables, these are the gadgets you need.",
    category: "Technology",
    author: "Rahmat Ullah",
    date: new Date("2024-12-20"),
    readTime: "5 min read",
    image: "https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=800&h=400&fit=crop",
    featured: true,
  },
  {
    id: "2",
    slug: "how-to-choose-perfect-headphones",
    title: "How to Choose the Perfect Headphones for Your Lifestyle",
    excerpt: "Wireless, wired, over-ear, or in-ear? This guide helps you find the ideal headphones based on your needs and budget.",
    category: "Buying Guide",
    author: "Tasnim Khan",
    date: new Date("2024-12-18"),
    readTime: "7 min read",
    image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800&h=400&fit=crop",
    featured: false,
  },
  {
    id: "3",
    slug: "smart-home-beginners-guide",
    title: "Smart Home 101: A Beginner's Guide",
    excerpt: "Transform your living space into a connected haven. Learn the basics of smart home technology and where to start.",
    category: "Guides",
    author: "Sakib Hasan",
    date: new Date("2024-12-15"),
    readTime: "10 min read",
    image: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800&h=400&fit=crop",
    featured: false,
  },
  {
    id: "4",
    slug: "winter-fashion-trends",
    title: "Winter Fashion Trends That Are Dominating 2024",
    excerpt: "Stay stylish and warm this winter with these trending fashion pieces. From cozy sweaters to statement boots.",
    category: "Fashion",
    author: "Fatima Rahman",
    date: new Date("2024-12-12"),
    readTime: "4 min read",
    image: "https://images.unsplash.com/photo-1483985988355-763728e1935b?w=800&h=400&fit=crop",
    featured: false,
  },
  {
    id: "5",
    slug: "fitness-gear-essentials",
    title: "Essential Fitness Gear for Your Home Gym",
    excerpt: "Build the perfect home workout space with these must-have fitness accessories and equipment.",
    category: "Fitness",
    author: "Rahmat Ullah",
    date: new Date("2024-12-10"),
    readTime: "6 min read",
    image: "https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=800&h=400&fit=crop",
    featured: false,
  },
];

const categories = ["All", "Technology", "Buying Guide", "Guides", "Fashion", "Fitness"];

export default function BlogPage() {
  const t = useTranslations("Blog");
  const featuredPost = blogPosts.find((post) => post.featured);
  const regularPosts = blogPosts.filter((post) => !post.featured);
  
  const getCategoryLabel = (cat: string) => {
    switch(cat) {
      case "All": return t("categories.all");
      case "Technology": return t("categories.tech");
      case "Buying Guide": return t("categories.guide");
      case "Guides": return t("categories.guides");
      case "Fashion": return t("categories.fashion");
      case "Fitness": return t("categories.fitness");
      default: return cat;
    }
  };

  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Header */}
        <div className="text-center mb-12">
          <div className="w-16 h-16 mx-auto bg-primary rounded-full flex items-center justify-center mb-4">
            <BookOpen className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-3xl sm:text-4xl font-bold text-foreground mb-3">{t("title")}</h1>
          <p className="text-muted-foreground max-w-lg mx-auto">
            {t("subtitle")}
          </p>
        </div>

        {/* Categories */}
        <div className="flex flex-wrap justify-center gap-2 mb-10">
          {categories.map((category) => (
            <Button
              key={category}
              variant={category === "All" ? "default" : "outline"}
              size="sm"
              className={category === "All" ? "bg-primary text-white" : ""}
            >
              {getCategoryLabel(category)}
            </Button>
          ))}
        </div>

        {/* Featured Post */}
        {featuredPost && (
          <Card className="mb-12 overflow-hidden bg-card/80 backdrop-blur hover:shadow-xl transition-shadow">
            <div className="grid md:grid-cols-2 gap-0">
              <div className="relative h-64 md:h-auto">
                <Image
                  src={featuredPost.image}
                  alt={featuredPost.title}
                  fill
                  className="object-cover"
                />
                <Badge className="absolute top-4 left-4 bg-primary text-white border-0">
                  {t("featured")}
                </Badge>
              </div>
              <CardContent className="p-6 md:p-8 flex flex-col justify-center">
                <Badge variant="outline" className="w-fit mb-3">{featuredPost.category}</Badge>
                <h2 className="text-2xl md:text-3xl font-bold text-foreground mb-3 hover:text-primary transition-colors">
                  <Link href={`/blog/${featuredPost.slug}`}>{featuredPost.title}</Link>
                </h2>
                <p className="text-muted-foreground mb-4 line-clamp-3">{featuredPost.excerpt}</p>
                <div className="flex items-center gap-4 text-sm text-muted-foreground mb-4">
                  <span className="flex items-center gap-1">
                    <User className="w-4 h-4" /> {featuredPost.author}
                  </span>
                  <span className="flex items-center gap-1">
                    <Calendar className="w-4 h-4" /> {featuredPost.date.toLocaleDateString()}
                  </span>
                  <span className="flex items-center gap-1">
                    <Clock className="w-4 h-4" /> {featuredPost.readTime}
                  </span>
                </div>
                <Link href={`/blog/${featuredPost.slug}`}>
                  <Button className="gap-2 bg-primary text-white w-fit">
                    {t("readMore")} <ArrowRight className="w-4 h-4" />
                  </Button>
                </Link>
              </CardContent>
            </div>
          </Card>
        )}

        {/* Blog Grid */}
        <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {regularPosts.map((post) => (
            <Card key={post.id} className="overflow-hidden bg-card/80 backdrop-blur hover:shadow-xl transition-all group">
              <div className="relative h-48 overflow-hidden">
                <Image
                  src={post.image}
                  alt={post.title}
                  fill
                  className="object-cover transition-transform duration-500 group-hover:scale-105"
                />
                <Badge className="absolute top-3 left-3 bg-card/90 text-foreground">
                  {post.category}
                </Badge>
              </div>
              <CardContent className="p-5">
                <h3 className="font-bold text-foreground mb-2 line-clamp-2 group-hover:text-primary transition-colors">
                  <Link href={`/blog/${post.slug}`}>{post.title}</Link>
                </h3>
                <p className="text-sm text-muted-foreground mb-4 line-clamp-2">{post.excerpt}</p>
                <div className="flex items-center justify-between text-xs text-muted-foreground">
                  <span className="flex items-center gap-1">
                    <Calendar className="w-3 h-3" /> {post.date.toLocaleDateString()}
                  </span>
                  <span className="flex items-center gap-1">
                    <Clock className="w-3 h-3" /> {post.readTime}
                  </span>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Newsletter CTA */}
        <Card className="mt-12 bg-primary text-white border-0">
          <CardContent className="p-8 text-center">
            <h3 className="text-2xl font-bold mb-2">{t("newsletter.title")}</h3>
            <p className="text-white/80 mb-6 max-w-md mx-auto">
              {t("newsletter.desc")}
            </p>
            <div className="flex max-w-md mx-auto gap-3">
              <input
                type="email"
                placeholder={t("newsletter.placeholder")}
                className="flex-1 px-4 py-2 rounded-lg text-foreground focus:outline-none focus:ring-2 focus:ring-white/50"
              />
              <Button className="bg-card text-primary hover:bg-muted">
                {t("newsletter.subscribe")}
              </Button>
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
