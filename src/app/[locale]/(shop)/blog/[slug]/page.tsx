import Link from "next/link";
import Image from "next/image";
import { ArrowLeft, Calendar, Clock, Tag, Share2, Facebook, Twitter } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { siteConfig } from "@/lib/config";
import type { Metadata } from "next";
import { notFound } from "next/navigation";

// Demo blog posts data
const blogPosts: Record<string, {
  id: string;
  slug: string;
  title: string;
  excerpt: string;
  content: string;
  category: string;
  author: string;
  authorImage: string;
  date: Date;
  readTime: string;
  image: string;
  tags: string[];
}> = {
  "top-10-gadgets-2024": {
    id: "1",
    slug: "top-10-gadgets-2024",
    title: "Top 10 Must-Have Gadgets for 2024",
    excerpt: "Discover the cutting-edge technology that's shaping our world.",
    content: `
## Introduction

Technology continues to evolve at a rapid pace, and 2024 is no exception. From smart home devices to wearable tech, there are countless gadgets that can make your life easier, more productive, and more enjoyable.

## 1. Smart Wireless Earbuds

The latest generation of wireless earbuds offers incredible sound quality, active noise cancellation, and seamless connectivity. Whether you're commuting, working out, or just relaxing, these earbuds deliver an immersive audio experience.

## 2. Smartwatch with Health Monitoring

Modern smartwatches go far beyond telling time. They can track your heart rate, blood oxygen levels, sleep patterns, and even detect irregular heart rhythms. Some models can even take ECG readings.

## 3. Portable Power Station

With our increasing reliance on electronic devices, a portable power station is essential. These compact units can charge multiple devices simultaneously and are perfect for camping, emergencies, or working remotely.

## 4. Robot Vacuum with Mapping

Say goodbye to manual vacuuming. Today's robot vacuums use AI-powered mapping to navigate your home efficiently, avoiding obstacles and ensuring thorough cleaning.

## 5. Foldable Smartphones

Foldable phones have finally matured, offering the convenience of a compact device that unfolds into a tablet-sized screen. Perfect for multitasking and media consumption.

## Conclusion

These gadgets represent the best of what technology has to offer in 2024. Whether you're looking to upgrade your tech or give a thoughtful gift, any of these items would be an excellent choice.
    `,
    category: "Technology",
    author: "Rahmat Ullah",
    authorImage: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=100&h=100&fit=crop",
    date: new Date("2024-12-20"),
    readTime: "5 min read",
    image: "https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=1200&h=600&fit=crop",
    tags: ["Technology", "Gadgets", "2024", "Electronics"],
  },
  "how-to-choose-perfect-headphones": {
    id: "2",
    slug: "how-to-choose-perfect-headphones",
    title: "How to Choose the Perfect Headphones for Your Lifestyle",
    excerpt: "A comprehensive guide to finding your ideal headphones.",
    content: `
## Understanding Your Needs

Before diving into specifications and features, it's important to understand how you'll primarily use your headphones. This will help narrow down your options significantly.

## Over-Ear vs In-Ear vs On-Ear

**Over-Ear Headphones**: Best for home use, studio work, and immersive listening. They provide excellent sound quality and noise isolation but are bulkier.

**In-Ear Headphones (Earbuds)**: Perfect for portability, workouts, and commuting. Modern true wireless earbuds offer impressive sound in a tiny package.

**On-Ear Headphones**: A middle ground between the two, offering good sound quality with more portability than over-ear models.

## Key Features to Consider

1. **Sound Quality**: Look for balanced frequency response and clear audio reproduction.
2. **Noise Cancellation**: Essential for noisy environments.
3. **Battery Life**: For wireless models, aim for at least 20 hours.
4. **Comfort**: Important for extended listening sessions.
5. **Durability**: Consider build quality and warranty.

## Budget Recommendations

- **Under ৳3,000**: Basic wireless earbuds with decent sound.
- **৳3,000 - ৳8,000**: Good quality with ANC features.
- **Above ৳8,000**: Premium sound and premium features.

## Conclusion

The perfect headphones are the ones that fit your lifestyle, budget, and preferences. Don't just follow trends—choose what works best for you.
    `,
    category: "Buying Guide",
    author: "Tasnim Khan",
    authorImage: "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop",
    date: new Date("2024-12-18"),
    readTime: "7 min read",
    image: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=1200&h=600&fit=crop",
    tags: ["Buying Guide", "Headphones", "Audio", "Tips"],
  },
};

// Related posts for sidebar
const relatedPosts = [
  { slug: "smart-home-beginners-guide", title: "Smart Home 101: A Beginner's Guide", image: "https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=200&h=150&fit=crop" },
  { slug: "winter-fashion-trends", title: "Winter Fashion Trends 2024", image: "https://images.unsplash.com/photo-1483985988355-763728e1935b?w=200&h=150&fit=crop" },
  { slug: "fitness-gear-essentials", title: "Essential Fitness Gear", image: "https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=200&h=150&fit=crop" },
];

interface PageProps {
  params: Promise<{ slug: string }>;
}

export async function generateMetadata({ params }: PageProps): Promise<Metadata> {
  const { slug } = await params;
  const post = blogPosts[slug];
  
  if (!post) {
    return {
      title: `Blog Post Not Found | ${siteConfig.name}`,
    };
  }

  return {
    title: `${post.title} | ${siteConfig.name}`,
    description: post.excerpt,
  };
}

export default async function BlogPostPage({ params }: PageProps) {
  const { slug } = await params;
  const post = blogPosts[slug];

  if (!post) {
    notFound();
  }

  return (
    <div className="min-h-screen bg-background">
      {/* Background decorations */}
      <div className="pointer-events-none fixed inset-0 overflow-hidden z-0 dark:hidden">
        <div className="absolute -top-32 -right-20 h-72 w-72 rounded-full bg-amber-200/60 blur-3xl" />
        <div className="absolute -bottom-32 -left-10 h-72 w-72 rounded-full bg-rose-200/60 blur-3xl" />
      </div>

      <div className="relative z-10 container mx-auto px-4 py-8">
        {/* Back Button */}
        <Link
          href="/blog"
          className="inline-flex items-center gap-1 text-sm text-muted-foreground hover:text-primary mb-6"
        >
          <ArrowLeft className="h-4 w-4" /> Back to Blog
        </Link>

        <div className="grid lg:grid-cols-3 gap-8">
          {/* Main Content */}
          <article className="lg:col-span-2">
            {/* Hero Image */}
            <div className="relative h-64 sm:h-96 rounded-2xl overflow-hidden mb-8">
              <Image
                src={post.image}
                alt={post.title}
                fill
                className="object-cover"
                priority
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent" />
              <Badge className="absolute top-4 left-4 bg-card/90 text-foreground">
                {post.category}
              </Badge>
            </div>

            {/* Article Header */}
            <header className="mb-8">
              <h1 className="text-3xl sm:text-4xl font-bold text-foreground mb-4">
                {post.title}
              </h1>
              
              <div className="flex flex-wrap items-center gap-4 text-sm text-muted-foreground mb-4">
                <div className="flex items-center gap-2">
                  <Image
                    src={post.authorImage}
                    alt={post.author}
                    width={32}
                    height={32}
                    className="rounded-full"
                  />
                  <span>{post.author}</span>
                </div>
                <span className="flex items-center gap-1">
                  <Calendar className="w-4 h-4" /> {post.date.toLocaleDateString()}
                </span>
                <span className="flex items-center gap-1">
                  <Clock className="w-4 h-4" /> {post.readTime}
                </span>
              </div>

              {/* Tags */}
              <div className="flex flex-wrap gap-2">
                {post.tags.map((tag) => (
                  <Badge key={tag} variant="outline" className="text-xs">
                    <Tag className="w-3 h-3 mr-1" /> {tag}
                  </Badge>
                ))}
              </div>
            </header>

            {/* Article Content */}
            <Card className="bg-card/80 backdrop-blur mb-8">
              <CardContent className="p-6 sm:p-10 prose prose-gray max-w-none">
                <div dangerouslySetInnerHTML={{ __html: post.content.replace(/\n## /g, '<h2>').replace(/\n\n/g, '</p><p>').replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>') }} />
              </CardContent>
            </Card>

            {/* Share Buttons */}
            <div className="flex items-center gap-4 p-6 bg-card/80 backdrop-blur rounded-xl">
              <span className="text-sm font-medium text-muted-foreground flex items-center gap-2">
                <Share2 className="w-4 h-4" /> Share this article:
              </span>
              <Button variant="outline" size="sm" className="gap-2">
                <Facebook className="w-4 h-4" /> Facebook
              </Button>
              <Button variant="outline" size="sm" className="gap-2">
                <Twitter className="w-4 h-4" /> Twitter
              </Button>
            </div>
          </article>

          {/* Sidebar */}
          <aside className="space-y-6">
            {/* Author Card */}
            <Card className="bg-card/80 backdrop-blur">
              <CardContent className="p-6 text-center">
                <Image
                  src={post.authorImage}
                  alt={post.author}
                  width={80}
                  height={80}
                  className="rounded-full mx-auto mb-4"
                />
                <h3 className="font-bold text-foreground">{post.author}</h3>
                <p className="text-sm text-muted-foreground mb-4">Content Writer</p>
                <Button variant="outline" size="sm" className="w-full">
                  View All Posts
                </Button>
              </CardContent>
            </Card>

            {/* Related Posts */}
            <Card className="bg-card/80 backdrop-blur">
              <CardContent className="p-6">
                <h3 className="font-bold text-foreground mb-4">Related Posts</h3>
                <div className="space-y-4">
                  {relatedPosts.map((relatedPost) => (
                    <Link
                      key={relatedPost.slug}
                      href={`/blog/${relatedPost.slug}`}
                      className="flex gap-3 group"
                    >
                      <div className="relative w-20 h-14 rounded-lg overflow-hidden flex-shrink-0">
                        <Image
                          src={relatedPost.image}
                          alt={relatedPost.title}
                          fill
                          className="object-cover"
                        />
                      </div>
                      <h4 className="text-sm font-medium text-foreground group-hover:text-primary transition-colors line-clamp-2">
                        {relatedPost.title}
                      </h4>
                    </Link>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Newsletter */}
            <Card className="bg-gradient-to-br from-amber-500 to-rose-500 text-white border-0">
              <CardContent className="p-6 text-center">
                <h3 className="font-bold mb-2">Subscribe to Newsletter</h3>
                <p className="text-sm text-white/80 mb-4">Get the latest posts in your inbox</p>
                <input
                  type="email"
                  placeholder="Your email"
                  className="w-full px-4 py-2 rounded-lg text-foreground text-sm mb-3"
                />
                <Button className="w-full bg-card text-primary hover:bg-muted">
                  Subscribe
                </Button>
              </CardContent>
            </Card>
          </aside>
        </div>
      </div>
    </div>
  );
}
