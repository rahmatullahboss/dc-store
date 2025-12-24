"use client";

import { useEffect, useState } from "react";
import { MessageSquare, User } from "lucide-react";
import { cn } from "@/lib/utils";

interface Conversation {
  id: string;
  sessionId: string;
  userId: string | null;
  userName: string | null;
  guestName: string | null;
  guestPhone: string | null;
  messageCount: number;
  lastMessageAt: string | null;
  createdAt: string;
}

export default function AdminChatPage() {
  const [conversations, setConversations] = useState<Conversation[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [messages, setMessages] = useState<{ role: string; content: string; createdAt: string }[]>([]);

  const fetchConversations = async () => {
    try {
      const res = await fetch("/api/admin/chat");
      if (res.ok) {
        const data = await res.json() as { conversations: Conversation[] };
        setConversations(data.conversations || []);
      }
    } catch (error) {
      console.error("Failed to fetch conversations:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const fetchMessages = async (id: string) => {
    try {
      const res = await fetch(`/api/admin/chat/${id}`);
      if (res.ok) {
        const data = await res.json() as { messages: { role: string; content: string; createdAt: string }[] };
        setMessages(data.messages || []);
      }
    } catch (error) {
      console.error("Failed to fetch messages:", error);
    }
  };

  useEffect(() => {
    fetchConversations();
  }, []);

  useEffect(() => {
    if (selectedId) {
      fetchMessages(selectedId);
    }
  }, [selectedId]);

  return (
    <div className="space-y-6">
      <h1 className="text-2xl font-bold text-white">Chat Conversations</h1>

      <div className="grid gap-6 lg:grid-cols-3">
        {/* Conversations List */}
        <div className="lg:col-span-1 bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden max-h-[600px] overflow-y-auto">
          {isLoading ? (
            <div className="p-8 text-center text-slate-400">Loading...</div>
          ) : conversations.length === 0 ? (
            <div className="p-8 text-center">
              <MessageSquare className="h-12 w-12 mx-auto text-slate-600 mb-3" />
              <p className="text-slate-400">No conversations yet</p>
            </div>
          ) : (
            <div className="divide-y divide-slate-700/50">
              {conversations.map((conv) => (
                <button
                  key={conv.id}
                  onClick={() => setSelectedId(conv.id)}
                  className={cn(
                    "w-full p-4 text-left hover:bg-slate-800/50 transition-colors",
                    selectedId === conv.id && "bg-amber-500/10 border-l-2 border-amber-500"
                  )}
                >
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-full bg-slate-700 flex items-center justify-center">
                      <User className="h-5 w-5 text-slate-400" />
                    </div>
                    <div className="flex-1 min-w-0">
                      <p className="font-medium text-white truncate">
                        {conv.userName || conv.guestName || "Guest"}
                      </p>
                      <p className="text-xs text-slate-400">
                        {conv.messageCount} messages
                      </p>
                    </div>
                  </div>
                </button>
              ))}
            </div>
          )}
        </div>

        {/* Messages */}
        <div className="lg:col-span-2 bg-slate-800/50 border border-slate-700 rounded-xl overflow-hidden">
          {selectedId ? (
            <div className="h-[600px] flex flex-col">
              <div className="p-4 border-b border-slate-700">
                <h2 className="font-semibold text-white">Conversation</h2>
              </div>
              <div className="flex-1 overflow-y-auto p-4 space-y-4">
                {messages.map((msg, i) => (
                  <div
                    key={i}
                    className={cn(
                      "max-w-[80%] rounded-lg p-3",
                      msg.role === "user"
                        ? "ml-auto bg-amber-500/20 text-amber-100"
                        : "bg-slate-700 text-slate-200"
                    )}
                  >
                    <p className="text-sm whitespace-pre-wrap">{msg.content}</p>
                    <p className="text-xs text-slate-400 mt-1">
                      {new Date(msg.createdAt).toLocaleString()}
                    </p>
                  </div>
                ))}
              </div>
            </div>
          ) : (
            <div className="h-[600px] flex items-center justify-center">
              <p className="text-slate-400">Select a conversation to view</p>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
