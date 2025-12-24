"use client";

import { useEffect, useState } from "react";
import { MessageSquare, User, Phone, Bot, Search } from "lucide-react";
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

interface Message {
  role: string;
  content: string;
  createdAt: string;
}

// Helper to format relative time
function formatRelativeTime(dateStr: string | null): string {
  if (!dateStr) return "";
  const date = new Date(dateStr);
  const now = new Date();
  const diffMs = now.getTime() - date.getTime();
  const diffMins = Math.floor(diffMs / 60000);
  const diffHours = Math.floor(diffMs / 3600000);
  const diffDays = Math.floor(diffMs / 86400000);

  if (diffMins < 1) return "এখনই";
  if (diffMins < 60) return `${diffMins} মিনিট আগে`;
  if (diffHours < 24) return `${diffHours} ঘন্টা আগে`;
  if (diffDays < 7) return `${diffDays} দিন আগে`;
  return date.toLocaleDateString("bn-BD");
}

// Helper to clean message content (remove product tags)
function cleanMessageContent(content: string): string {
  return content
    .replace(/\[PRODUCT:[^\]]+\]/g, "")
    .replace(/\n{3,}/g, "\n\n")
    .trim();
}

export default function AdminChatPage() {
  const [conversations, setConversations] = useState<Conversation[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [selectedId, setSelectedId] = useState<string | null>(null);
  const [messages, setMessages] = useState<Message[]>([]);
  const [messagesLoading, setMessagesLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState("");

  const selectedConversation = conversations.find((c) => c.id === selectedId);

  const filteredConversations = conversations.filter((conv) => {
    const name = conv.userName || conv.guestName || "";
    const phone = conv.guestPhone || "";
    const query = searchQuery.toLowerCase();
    return name.toLowerCase().includes(query) || phone.includes(query);
  });

  const fetchConversations = async () => {
    try {
      const res = await fetch("/api/admin/chat");
      if (res.ok) {
        const data = (await res.json()) as { conversations: Conversation[] };
        setConversations(data.conversations || []);
      }
    } catch (error) {
      console.error("Failed to fetch conversations:", error);
    } finally {
      setIsLoading(false);
    }
  };

  const fetchMessages = async (id: string) => {
    setMessagesLoading(true);
    try {
      const res = await fetch(`/api/admin/chat/${id}`);
      if (res.ok) {
        const data = (await res.json()) as { messages: Message[] };
        setMessages(data.messages || []);
      }
    } catch (error) {
      console.error("Failed to fetch messages:", error);
    } finally {
      setMessagesLoading(false);
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
    <div className="h-[calc(100vh-140px)] flex flex-col">
      {/* Header */}
      <div className="mb-4 flex items-center justify-between">
        <h1 className="text-2xl font-bold text-white flex items-center gap-2">
          <MessageSquare className="h-6 w-6 text-amber-500" />
          Customer Chats
        </h1>
        <span className="text-sm text-slate-400">
          {conversations.length} conversations
        </span>
      </div>

      {/* Main Chat Container */}
      <div className="flex-1 flex gap-0 bg-slate-900 rounded-2xl overflow-hidden border border-slate-700/50 shadow-2xl">
        {/* Left Sidebar - Conversations List */}
        <div className="w-80 border-r border-slate-700/50 flex flex-col bg-slate-800/30">
          {/* Search */}
          <div className="p-3 border-b border-slate-700/50">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-slate-400" />
              <input
                type="text"
                placeholder="Search conversations..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full pl-10 pr-4 py-2 bg-slate-800 border border-slate-600 rounded-full text-sm text-white placeholder:text-slate-500 focus:outline-none focus:border-amber-500/50 focus:ring-1 focus:ring-amber-500/20"
              />
            </div>
          </div>

          {/* Conversations List */}
          <div className="flex-1 overflow-y-auto">
            {isLoading ? (
              <div className="p-8 text-center">
                <div className="w-8 h-8 border-2 border-amber-500 border-t-transparent rounded-full animate-spin mx-auto mb-3" />
                <p className="text-slate-400 text-sm">Loading chats...</p>
              </div>
            ) : filteredConversations.length === 0 ? (
              <div className="p-8 text-center">
                <MessageSquare className="h-12 w-12 mx-auto text-slate-600 mb-3" />
                <p className="text-slate-400">
                  {searchQuery ? "No matching conversations" : "No conversations yet"}
                </p>
              </div>
            ) : (
              <div className="divide-y divide-slate-700/30">
                {filteredConversations.map((conv) => (
                  <button
                    key={conv.id}
                    onClick={() => setSelectedId(conv.id)}
                    className={cn(
                      "w-full p-3 text-left transition-all duration-200",
                      selectedId === conv.id
                        ? "bg-gradient-to-r from-amber-500/20 to-amber-500/10 border-l-3 border-amber-500"
                        : "hover:bg-slate-700/30"
                    )}
                  >
                    <div className="flex items-center gap-3">
                      {/* Avatar */}
                      <div
                        className={cn(
                          "w-12 h-12 rounded-full flex items-center justify-center flex-shrink-0",
                          conv.userId
                            ? "bg-gradient-to-br from-amber-500 to-orange-600"
                            : "bg-gradient-to-br from-slate-600 to-slate-700"
                        )}
                      >
                        <User className="h-5 w-5 text-white" />
                      </div>

                      {/* Info */}
                      <div className="flex-1 min-w-0">
                        <div className="flex items-center justify-between gap-2">
                          <p className="font-semibold text-white truncate">
                            {conv.userName || conv.guestName || "Guest"}
                          </p>
                          <span className="text-[10px] text-slate-500 flex-shrink-0">
                            {formatRelativeTime(conv.lastMessageAt)}
                          </span>
                        </div>
                        <div className="flex items-center gap-1 mt-0.5">
                          <Phone className="h-3 w-3 text-slate-500" />
                          <p className="text-xs text-slate-400 truncate">
                            {conv.guestPhone || "No phone"}
                          </p>
                        </div>
                        <p className="text-xs text-slate-500 mt-1">
                          {conv.messageCount} messages
                        </p>
                      </div>
                    </div>
                  </button>
                ))}
              </div>
            )}
          </div>
        </div>

        {/* Right Panel - Messages */}
        <div className="flex-1 flex flex-col bg-slate-800/20">
          {selectedId && selectedConversation ? (
            <>
              {/* Chat Header */}
              <div className="p-4 border-b border-slate-700/50 bg-slate-800/50">
                <div className="flex items-center gap-3">
                  <div
                    className={cn(
                      "w-10 h-10 rounded-full flex items-center justify-center",
                      selectedConversation.userId
                        ? "bg-gradient-to-br from-amber-500 to-orange-600"
                        : "bg-gradient-to-br from-slate-600 to-slate-700"
                    )}
                  >
                    <User className="h-5 w-5 text-white" />
                  </div>
                  <div>
                    <h2 className="font-semibold text-white">
                      {selectedConversation.userName ||
                        selectedConversation.guestName ||
                        "Guest"}
                    </h2>
                    <div className="flex items-center gap-2 text-xs text-slate-400">
                      {selectedConversation.guestPhone && (
                        <span className="flex items-center gap-1">
                          <Phone className="h-3 w-3" />
                          {selectedConversation.guestPhone}
                        </span>
                      )}
                      {selectedConversation.userId && (
                        <span className="px-1.5 py-0.5 bg-amber-500/20 text-amber-400 rounded text-[10px]">
                          Registered
                        </span>
                      )}
                    </div>
                  </div>
                </div>
              </div>

              {/* Messages */}
              <div className="flex-1 overflow-y-auto p-4 space-y-3">
                {messagesLoading ? (
                  <div className="flex items-center justify-center h-full">
                    <div className="w-6 h-6 border-2 border-amber-500 border-t-transparent rounded-full animate-spin" />
                  </div>
                ) : messages.length === 0 ? (
                  <div className="flex items-center justify-center h-full text-slate-400">
                    No messages in this conversation
                  </div>
                ) : (
                  messages.map((msg, i) => {
                    const cleanContent = cleanMessageContent(msg.content);
                    if (!cleanContent) return null;

                    return (
                      <div
                        key={i}
                        className={cn(
                          "flex gap-2",
                          msg.role === "user" ? "justify-end" : "justify-start"
                        )}
                      >
                        {msg.role === "assistant" && (
                          <div className="w-8 h-8 rounded-full bg-gradient-to-br from-amber-500 to-rose-500 flex items-center justify-center flex-shrink-0">
                            <Bot className="h-4 w-4 text-white" />
                          </div>
                        )}
                        <div
                          className={cn(
                            "max-w-[70%] rounded-2xl px-4 py-2.5 shadow-lg",
                            msg.role === "user"
                              ? "bg-gradient-to-br from-amber-500 to-amber-600 text-white rounded-tr-md"
                              : "bg-slate-700 text-slate-100 rounded-tl-md"
                          )}
                        >
                          <p className="text-sm whitespace-pre-wrap leading-relaxed">
                            {cleanContent}
                          </p>
                          <p
                            className={cn(
                              "text-[10px] mt-1.5",
                              msg.role === "user"
                                ? "text-amber-200/70"
                                : "text-slate-400"
                            )}
                          >
                            {new Date(msg.createdAt).toLocaleTimeString("bn-BD", {
                              hour: "2-digit",
                              minute: "2-digit",
                            })}
                          </p>
                        </div>
                        {msg.role === "user" && (
                          <div className="w-8 h-8 rounded-full bg-slate-600 flex items-center justify-center flex-shrink-0">
                            <User className="h-4 w-4 text-slate-300" />
                          </div>
                        )}
                      </div>
                    );
                  })
                )}
              </div>
            </>
          ) : (
            <div className="flex-1 flex items-center justify-center">
              <div className="text-center">
                <div className="w-20 h-20 mx-auto mb-4 rounded-full bg-gradient-to-br from-slate-700 to-slate-800 flex items-center justify-center">
                  <MessageSquare className="h-10 w-10 text-slate-500" />
                </div>
                <h3 className="text-lg font-medium text-slate-300 mb-1">
                  Select a conversation
                </h3>
                <p className="text-sm text-slate-500">
                  Choose a chat from the list to view messages
                </p>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
