import { NextRequest, NextResponse } from "next/server";

// Using default runtime for OpenNext compatibility

interface SaveChatRequest {
  sessionId: string;
  userId?: string;
  guestInfo?: {
    name: string;
    phone: string;
  };
  message: {
    role: "user" | "assistant";
    content: string;
  };
}

export async function POST(req: NextRequest) {
  try {
    const body: SaveChatRequest = await req.json();
    const { sessionId, message } = body;

    if (!sessionId || !message) {
      return NextResponse.json(
        { error: "Missing required fields" },
        { status: 400 }
      );
    }

    // TODO: In production, save to D1 database using Cloudflare context
    // For now, just acknowledge the message
    // This will be implemented when D1 bindings are configured

    console.log("Chat message received:", {
      sessionId,
      role: message.role,
      contentLength: message.content.length,
    });

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Error saving chat:", error);
    return NextResponse.json({ error: "Failed to save chat" }, { status: 500 });
  }
}
