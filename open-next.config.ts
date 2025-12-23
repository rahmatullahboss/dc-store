// open-next.config.ts - Cloudflare Workers configuration
import { defineCloudflareConfig } from "@opennextjs/cloudflare/config";

// Using default incremental cache (no R2) since R2 bucket isn't enabled
// To enable R2 caching, enable R2 in Cloudflare dashboard and add:
// import r2IncrementalCache from "@opennextjs/cloudflare/overrides/incremental-cache/r2-incremental-cache";
// export default defineCloudflareConfig({ incrementalCache: r2IncrementalCache });

export default defineCloudflareConfig({});
