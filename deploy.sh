#!/bin/bash

# DC Store - Manual Deploy Script
# Usage: ./deploy.sh

echo "🚀 DC Store - Manual Deploy"
echo "============================"

# Build with OpenNext
echo "📦 Building with OpenNext..."
npx opennextjs-cloudflare build

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"

# Deploy to Cloudflare
echo "☁️  Deploying to Cloudflare Workers..."
npx wrangler deploy

if [ $? -ne 0 ]; then
    echo "❌ Deploy failed!"
    exit 1
fi

echo ""
echo "✅ Deploy successful!"
echo "🌐 Live at: https://store.digitalcare.site"
echo ""
echo "ISR caching is now active with KV cache (1 hour)!"
