import { NextRequest, NextResponse } from "next/server";
import { getDatabase } from "@/lib/cloudflare";
import { chatConversations, chatMessages } from "@/db/schema";
import { eq, sql } from "drizzle-orm";

export const dynamic = "force-dynamic";

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
    const { sessionId, userId, guestInfo, message } = body;

    if (!sessionId || !message) {
      return NextResponse.json(
        { error: "Missing required fields" },
        { status: 400 }
      );
    }

    const db = await getDatabase();

    // Check if conversation exists
    const existingConversation = await db.query.chatConversations.findFirst({
      where: eq(chatConversations.sessionId, sessionId),
    });

    let conversationId: string;
    let existingGuestName: string | null = null;
    let existingGuestPhone: string | null = null;

    if (!existingConversation) {
      // Create new conversation
      conversationId = `conv_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`;
      await db.insert(chatConversations).values({
        id: conversationId,
        sessionId,
        userId: userId || null,
        guestName: guestInfo?.name || null,
        guestPhone: guestInfo?.phone || null,
        messageCount: 0,
        lastMessageAt: new Date(),
        createdAt: new Date(),
        updatedAt: new Date(),
      });
    } else {
      conversationId = existingConversation.id;
      existingGuestName = existingConversation.guestName;
      existingGuestPhone = existingConversation.guestPhone;
    }

    // Save the message
    const messageId = `msg_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`;
    await db.insert(chatMessages).values({
      id: messageId,
      conversationId,
      role: message.role,
      content: message.content,
      createdAt: new Date(),
    });

    // Update conversation stats
    await db
      .update(chatConversations)
      .set({
        messageCount: sql`${chatConversations.messageCount} + 1`,
        lastMessageAt: new Date(),
        updatedAt: new Date(),
        // Update guest info if provided and not already set
        ...(guestInfo && !existingGuestName ? { guestName: guestInfo.name } : {}),
        ...(guestInfo && !existingGuestPhone ? { guestPhone: guestInfo.phone } : {}),
      })
      .where(eq(chatConversations.id, conversationId));

    return NextResponse.json({ success: true });
  } catch (error) {
    console.error("Error saving chat:", error);
    return NextResponse.json({ error: "Failed to save chat" }, { status: 500 });
  }
}
