import { NextRequest, NextResponse } from "next/server";
import { getDatabase } from "@/lib/cloudflare";
import { chatConversations, chatMessages } from "@/db/schema";
import { eq, asc } from "drizzle-orm";

export const dynamic = "force-dynamic";

export async function GET(req: NextRequest) {
  try {
    const sessionId = req.nextUrl.searchParams.get("sessionId");

    if (!sessionId) {
      return NextResponse.json(
        { error: "Missing sessionId" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    // Find the conversation by sessionId
    const conversation = await db.query.chatConversations.findFirst({
      where: eq(chatConversations.sessionId, sessionId),
    });

    if (!conversation) {
      return NextResponse.json({ messages: [], guestInfo: null });
    }

    // Fetch all messages for this conversation
    const messages = await db
      .select({
        id: chatMessages.id,
        role: chatMessages.role,
        content: chatMessages.content,
        createdAt: chatMessages.createdAt,
      })
      .from(chatMessages)
      .where(eq(chatMessages.conversationId, conversation.id))
      .orderBy(asc(chatMessages.createdAt));

    return NextResponse.json({
      messages,
      guestInfo: conversation.guestName || conversation.guestPhone
        ? {
            name: conversation.guestName || "Guest",
            phone: conversation.guestPhone || "",
          }
        : null,
    });
  } catch (error) {
    console.error("Error loading chat history:", error);
    return NextResponse.json(
      { error: "Failed to load chat history" },
      { status: 500 }
    );
  }
}
