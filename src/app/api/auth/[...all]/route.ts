import { getAuth } from "@/lib/cloudflare";
import { toNextJsHandler } from "better-auth/next-js";

export const { GET, POST } = toNextJsHandler(async (req) => {
  const auth = await getAuth();
  return auth.handler(req);
});
