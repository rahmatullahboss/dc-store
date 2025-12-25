import { revalidatePath } from "next/cache";
import { NextResponse } from "next/server";
import { headers } from "next/headers";

// Internal revalidation endpoint - called by admin API routes
export async function POST(request: Request) {
  try {
    // Get the secret from headers to verify internal call
    const headersList = await headers();
    const internalSecret = headersList.get("x-revalidate-secret");
    
    // Simple check - only allow internal calls (from same origin)
    // In production, you might want a more robust secret
    if (!internalSecret || internalSecret !== process.env.REVALIDATE_SECRET) {
      // Allow if no secret is set (for initial setup)
      if (process.env.REVALIDATE_SECRET) {
        return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
      }
    }

    const body = await request.json() as { paths?: string[] };
    const paths = body.paths || [];

    // Revalidate each path
    for (const path of paths) {
      revalidatePath(path);
    }

    return NextResponse.json({ 
      revalidated: true, 
      paths,
      timestamp: Date.now() 
    });
  } catch (error) {
    console.error("Revalidation error:", error);
    return NextResponse.json({ error: "Revalidation failed" }, { status: 500 });
  }
}
