# DC Store - AI Agent Guidelines

> এই ফাইলটি AI agents-এর জন্য তৈরি করা হয়েছে যারা এই প্রজেক্টে কাজ করবে।
> Always follow these guidelines to build a cutting-edge, super-fast, best-in-class e-commerce site.

## 🚨 Critical Rules

### 1. ALWAYS Use Context7 for Documentation

```
❌ WRONG: Rely on training data (may be outdated)
✅ RIGHT: Always use Context7 MCP tools to fetch latest docs
```

**Before using any library:**

1. Call `mcp_context7_resolve-library-id` to find the library
2. Call `mcp_context7_get-library-docs` with relevant topic
3. Use the latest patterns and APIs from the docs

**Key libraries to always check:**

- Next.js: `/vercel/next.js`
- Drizzle ORM: `/llmstxt/orm_drizzle_team_llms_txt`
- Better Auth: `/www.better-auth.com/llmstxt`
- Cloudflare Workers: `/websites/developers_cloudflare_workers`
- Tailwind CSS: `/tailwindlabs/tailwindcss`
- shadcn/ui: Check their website for components

### 2. Search Web for Latest Best Practices

```
✅ Always search web for:
- "Next.js 15 Cloudflare best practices 2024"
- "Drizzle ORM D1 performance optimization"
- "React 19 Server Components patterns"
- "[technology] latest version compatibility"
```

### 3. Version Compatibility Check

⚠️ **IMPORTANT**: Before using any framework version, VERIFY Cloudflare compatibility!

| Framework   | Supported Versions | Notes                            |
| ----------- | ------------------ | -------------------------------- |
| Next.js     | **15.x** (stable)  | v16 NOT officially supported yet |
| React       | 18.x, 19.x         | Works with Next.js 15            |
| Drizzle ORM | Latest             | Full D1 support                  |
| Better Auth | Latest             | Has Drizzle adapter              |

---

## 🏗️ Architecture Guidelines

### Tech Stack (Do Not Change Without Research)

```yaml
Frontend:
  - Next.js 15 (App Router)
  - React 19
  - TypeScript (strict mode)
  - Tailwind CSS 4

Backend:
  - Cloudflare Workers
  - Cloudflare D1 (SQLite)
  - Cloudflare R2 (images)
  - Drizzle ORM

Auth:
  - Better Auth (NOT NextAuth - incompatible with Workers)

UI:
  - shadcn/ui components
  - Radix UI primitives
  - Lucide React icons
```

### Why Better Auth over NextAuth?

| Feature               | Better Auth       | NextAuth           |
| --------------------- | ----------------- | ------------------ |
| Cloudflare D1         | ✅ Native adapter | ❌ Limited         |
| Edge Runtime          | ✅ Full support   | ⚠️ Partial         |
| Bundle Size           | 🟢 ~7kb           | 🟡 Heavier         |
| Workers Compatibility | ✅ Built for edge | ❌ Node.js-centric |

---

## ⚡ Performance Best Practices

### 1. Server Components First

```tsx
// ✅ Default: Server Component
export default async function ProductPage() {
  const products = await db.query.products.findMany();
  return <ProductGrid products={products} />;
}

// ❌ Avoid: Client Component unless needed
"use client"
export default function ProductPage() { ... }
```

### 2. Optimize Images

```tsx
import Image from "next/image";

// ✅ Always use Next/Image with proper sizing
<Image
  src={product.image}
  alt={product.name}
  width={400}
  height={400}
  sizes="(max-width: 768px) 100vw, 25vw"
  loading="lazy" // or "eager" for above-fold
/>;
```

### 3. Database Queries

```typescript
// ✅ Use Drizzle's select for specific columns
const products = await db
  .select({
    id: products.id,
    name: products.name,
    price: products.price,
  })
  .from(products)
  .limit(20);

// ❌ Avoid: Selecting all columns when not needed
const products = await db.query.products.findMany();
```

### 4. Caching Strategies

```typescript
// ✅ Use Next.js caching
import { unstable_cache } from "next/cache";

const getCachedProducts = unstable_cache(
  async () => db.query.products.findMany(),
  ["products"],
  { revalidate: 60 } // 1 minute
);
```

---

## 🎨 UI/UX Guidelines

### 1. Modern Design Principles

- ✅ Use gradients and glassmorphism
- ✅ Add micro-animations and hover effects
- ✅ Dark mode support
- ✅ Mobile-first responsive design
- ❌ NO plain/basic colors
- ❌ NO generic Bootstrap-like designs

### 2. Component Structure

```
src/components/
├── ui/           # shadcn/ui components (DO NOT MODIFY)
├── layout/       # Header, Footer, Sidebar
├── product/      # ProductCard, ProductGrid, ProductDetail
├── cart/         # CartSheet, CartItem, CartSummary
├── auth/         # LoginForm, RegisterForm
└── common/       # Reusable components
```

### 3. Styling Rules

```tsx
// ✅ Use Tailwind utilities
<button className="bg-primary text-white px-4 py-2 rounded-lg hover:bg-primary/90 transition-colors">

// ✅ Use CVA for variants
import { cva } from "class-variance-authority";

const buttonVariants = cva("rounded-lg transition-colors", {
  variants: {
    variant: {
      primary: "bg-primary text-white hover:bg-primary/90",
      secondary: "bg-secondary text-secondary-foreground",
    },
  },
});
```

---

## 📁 File Structure

```
dc-store/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── (shop)/             # Customer pages (grouped)
│   │   ├── (auth)/             # Auth pages
│   │   ├── admin/              # Admin dashboard
│   │   └── api/                # API routes
│   ├── components/             # React components
│   ├── db/
│   │   ├── schema.ts           # Drizzle schema (source of truth)
│   │   └── index.ts            # DB client
│   ├── lib/
│   │   ├── auth.ts             # Better Auth server config
│   │   ├── auth-client.ts      # Better Auth client
│   │   ├── config.ts           # Site config (white-label)
│   │   ├── cart-context.tsx    # Cart state
│   │   └── cloudflare.ts       # CF environment helpers
│   └── types/                  # TypeScript types
├── drizzle/                    # Migrations (auto-generated)
├── wrangler.toml               # Cloudflare config
└── drizzle.config.ts           # Drizzle Kit config
```

---

## 🔧 Common Tasks

### Adding a New Page

1. Create in appropriate route group: `src/app/(shop)/[page]/page.tsx`
2. Use Server Components by default
3. Add metadata for SEO:

```tsx
export const metadata = {
  title: "Page Title",
  description: "Page description",
};
```

### Adding a Database Table

1. Add schema in `src/db/schema.ts`
2. Run `npm run db:generate`
3. Run `npm run db:migrate:local` (dev) or `db:migrate:remote` (prod)

### Adding a New Component

1. Check if shadcn/ui has it: `npx shadcn@latest add [component]`
2. If not, create in appropriate folder under `src/components/`
3. Make it reusable and type-safe

### Deploying

> [!IMPORTANT] > **Git push does NOT auto-deploy!** You must manually deploy after pushing changes.

```bash
# 1. Test locally
npm run build
npm run preview

# 2. Deploy to Cloudflare (REQUIRED after git push)
npm run deploy

# 3. If database schema changed, run migrations
npm run db:migrate:remote
```

---

## 🚫 Things to Avoid

1. **DON'T use training data** - Always fetch latest docs via Context7
2. **DON'T use Next.js 16** - Not yet supported by OpenNext/Cloudflare
3. **DON'T use NextAuth** - Use Better Auth for Cloudflare compatibility
4. **DON'T use Prisma** - Use Drizzle ORM (better D1 support)
5. **DON'T add unnecessary dependencies** - Keep bundle small
6. **DON'T use CSS-in-JS** - Use Tailwind CSS
7. **DON'T skip type checking** - TypeScript strict mode is enabled
8. **DON'T commit .env files** - Use .env.example as template

---

## 📚 Resources

### Documentation (Always Check Latest via Context7)

- [Next.js Docs](https://nextjs.org/docs)
- [Cloudflare Workers Docs](https://developers.cloudflare.com/workers)
- [Drizzle ORM Docs](https://orm.drizzle.team/docs)
- [Better Auth Docs](https://www.better-auth.com/docs)
- [shadcn/ui Docs](https://ui.shadcn.com)

### Useful Commands

```bash
# Context7 Library IDs
/vercel/next.js                        # Next.js
/llmstxt/orm_drizzle_team_llms_txt     # Drizzle ORM
/www.better-auth.com/llmstxt           # Better Auth
/websites/developers_cloudflare_workers # Cloudflare Workers
```

---

## ✅ Pre-Commit Checklist

- [ ] `npm run build` passes without errors
- [ ] TypeScript types are correct
- [ ] Components are responsive
- [ ] SEO metadata is added
- [ ] Accessibility is considered
- [ ] Performance is optimized (no unnecessary re-renders)

---

**Remember**: This is a production e-commerce template. Always prioritize:

1. **Performance** - Edge deployment, optimized queries, lazy loading
2. **Security** - Input validation, auth checks, HTTPS
3. **User Experience** - Fast, beautiful, responsive
4. **Maintainability** - Clean code, proper types, documentation
