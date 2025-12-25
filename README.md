# DC Store - Cloudflare-Ready E-commerce Template

A modern, high-performance e-commerce template built for Cloudflare Workers & D1. Perfect for white-labeling and selling to clients.

## 🚀 Tech Stack

| Technology         | Purpose                          |
| ------------------ | -------------------------------- |
| **Next.js 16**     | React framework with App Router  |
| **React 19**       | UI library with latest features  |
| **TypeScript**     | Type-safe development            |
| **Tailwind CSS 4** | Utility-first styling            |
| **shadcn/ui**      | Beautiful, accessible components |
| **Drizzle ORM**    | Type-safe database ORM           |
| **Cloudflare D1**  | SQLite at the edge               |
| **Cloudflare R2**  | Object storage for images        |
| **Better Auth**    | Modern authentication            |
| **OpenNext**       | Deploy Next.js to Cloudflare     |

## ✨ Features

- ✅ **Modern UI** - Beautiful, responsive design with animations
- ✅ **Shopping Cart** - Persistent cart with localStorage
- ✅ **Product Catalog** - Categories, variants, images
- ✅ **Authentication** - Email/password + Google OAuth
- ✅ **Order Management** - Complete order flow
- ✅ **Admin Dashboard** - Manage products, orders, customers
- ✅ **White-label Ready** - Easy brand customization
- ✅ **SEO Optimized** - Meta tags, Open Graph, structured data
- ✅ **Mobile First** - Responsive on all devices
- ✅ **Edge Performance** - Runs on Cloudflare's global network

## 📦 Getting Started

### Prerequisites

- Node.js 20+
- npm
- Cloudflare account (free tier works)
- Wrangler CLI

### Installation

1. **Clone and install dependencies:**

   ```bash
   cd dc-store
   npm install
   ```

2. **Setup environment variables:**

   ```bash
   cp .env.example .env
   # Edit .env with your values
   ```

3. **Login to Cloudflare:**

   ```bash
   npm run cf:login
   ```

4. **Create D1 database:**

   ```bash
   npm run cf:d1:create
   # Copy the database_id to wrangler.toml
   ```

5. **Generate and run migrations:**

   ```bash
   npm run db:generate
   npm run db:migrate:local  # For local development
   ```

6. **Start development server:**
   ```bash
   npm run dev
   ```

## 🛠️ Development Commands

| Command                     | Description                             |
| --------------------------- | --------------------------------------- |
| `npm run dev`               | Start development server with Turbopack |
| `npm run build`             | Build for production                    |
| `npm run build:cf`          | Build for Cloudflare Workers            |
| `npm run preview`           | Preview Cloudflare build locally        |
| `npm run deploy`            | Deploy to Cloudflare Workers            |
| `npm run db:generate`       | Generate database migrations            |
| `npm run db:migrate:local`  | Apply migrations locally                |
| `npm run db:migrate:remote` | Apply migrations to production          |
| `npm run db:studio:local`   | Open Drizzle Studio                     |

## 🎨 White-Labeling

Edit `src/lib/config.ts` to customize:

```typescript
export const siteConfig = {
  name: "Your Store Name",
  description: "Your store description",
  logo: "/your-logo.svg",
  theme: {
    primaryColor: "#0F172A",
    accentColor: "#3B82F6",
  },
  currency: {
    code: "BDT",
    symbol: "৳",
  },
  // ... more options
};
```

Or use environment variables:

```env
NEXT_PUBLIC_BRAND_NAME="Your Store"
NEXT_PUBLIC_BRAND_LOGO="/logo.svg"
NEXT_PUBLIC_PRIMARY_COLOR="#your-color"
```

## 📁 Project Structure

```
dc-store/
├── src/
│   ├── app/                 # Next.js app router
│   │   ├── (shop)/          # Customer-facing pages
│   │   ├── (auth)/          # Auth pages
│   │   ├── admin/           # Admin dashboard
│   │   └── api/             # API routes
│   ├── components/          # React components
│   │   ├── ui/              # shadcn/ui components
│   │   ├── layout/          # Header, Footer
│   │   ├── product/         # Product components
│   │   ├── cart/            # Cart components
│   │   └── auth/            # Auth components
│   ├── db/                  # Database
│   │   ├── schema.ts        # Drizzle schema
│   │   └── index.ts         # DB client
│   ├── lib/                 # Utilities
│   │   ├── auth.ts          # Better Auth config
│   │   ├── config.ts        # Site config
│   │   ├── cart-context.tsx # Cart state
│   │   └── cloudflare.ts    # CF helpers
│   └── types/               # TypeScript types
├── drizzle/                 # Migrations
├── public/                  # Static assets
├── wrangler.toml            # Cloudflare config
└── drizzle.config.ts        # Drizzle config
```

## 🌐 Deployment

### Deploy to Cloudflare Workers

1. **Configure `wrangler.toml`:**

   - Set your D1 database ID
   - Configure R2 bucket (optional)

2. **Set secrets:**

   ```bash
   wrangler secret put BETTER_AUTH_SECRET
   wrangler secret put GOOGLE_CLIENT_SECRET  # if using Google OAuth
   ```

3. **Deploy:**
   ```bash
   npm run deploy
   ```

### Custom Domain

Configure in Cloudflare Dashboard → Workers & Pages → Your Worker → Custom Domains

## 💰 Pricing

This template runs on Cloudflare's free tier:

- **D1**: 5 million rows read/day
- **Workers**: 100,000 requests/day
- **R2**: 10 GB storage, 10 million reads/month

Perfect for small to medium e-commerce stores!

## 📄 License

MIT License - Free to use for personal and commercial projects.

## 🤝 Support

For questions or support, please open an issue.

---

Built with ❤️ for the Cloudflare ecosystem

