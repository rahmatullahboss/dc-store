import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { chatConversations, users } from "@/db/schema";
import { eq, desc } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

export async function GET() {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();

    const conversations = await db
      .select({
        id: chatConversations.id,
        sessionId: chatConversations.sessionId,
        userId: chatConversations.userId,
        userName: users.name,
        guestName: chatConversations.guestName,
        guestPhone: chatConversations.guestPhone,
        messageCount: chatConversations.messageCount,
        lastMessageAt: chatConversations.lastMessageAt,
        createdAt: chatConversations.createdAt,
      })
      .from(chatConversations)
      .leftJoin(users, eq(chatConversations.userId, users.id))
      .orderBy(desc(chatConversations.lastMessageAt));

    return NextResponse.json({ conversations });
  } catch (error) {
    console.error("Chat conversations error:", error);
    return NextResponse.json({ error: "Failed to fetch conversations" }, { status: 500 });
  }
}
