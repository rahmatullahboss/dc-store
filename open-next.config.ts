// open-next.config.ts - Cloudflare Workers configuration with ISR caching
import { defineCloudflareConfig } from "@opennextjs/cloudflare/config";
import kvIncrementalCache from "@opennextjs/cloudflare/overrides/incremental-cache/kv-incremental-cache";
import d1NextTagCache from "@opennextjs/cloudflare/overrides/tag-cache/d1-next-tag-cache";

// ISR Configuration:
// - KV Cache: Stores cached pages (fast key-value storage with built-in edge caching)
// - D1 Tag Cache: Enables on-demand revalidation via revalidatePath/revalidateTag
export default defineCloudflareConfig({
  incrementalCache: kvIncrementalCache,
  tagCache: d1NextTagCache,
});



