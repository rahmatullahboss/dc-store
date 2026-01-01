"use client";

import { useChat } from "@ai-sdk/react";
import { DefaultChatTransport } from "ai";
import { useState, useRef, useEffect, useCallback } from "react";
import { useTranslations, useLocale } from "next-intl";
// ... imports ...
import {
  X,
  Send,
  Bot,
  User,
  Loader2,
  Users,
  Phone,
  ShoppingCart,
  ExternalLink,
} from "lucide-react";
import { FaFacebookMessenger, FaWhatsapp } from "react-icons/fa";
import Image from "next/image";
import { Link } from "@/i18n/routing";
import { cn } from "@/lib/utils";
import { siteConfig, formatPrice } from "@/lib/config";

// Product type parsed from AI response
interface Product {
  slug: string;
  name: string;
  price: number;
  category: string;
  inStock: boolean;
  imageUrl: string | null;
}

interface GuestInfo {
  name: string;
  phone: string;
}

// Generate unique session ID
function generateSessionId() {
  return `chat_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`;
}

// Content segment type for interleaving text and products
type ContentSegment =
  | { type: "text"; content: string }
  | { type: "product"; product: Product };

// Parse products from AI text response - returns segments in order
function parseProductsFromText(text: string): ContentSegment[] {
  const productRegex =
    /\[PRODUCT:([^:]+):([^:]+):৳?(\d+):([^:]+):(true|false):([^\]]*)\]/g;
  const segments: ContentSegment[] = [];
  let lastIndex = 0;
  let match;

  while ((match = productRegex.exec(text)) !== null) {
    // Add text before this product
    const textBefore = text.slice(lastIndex, match.index);
    const cleanedText = textBefore
      .replace(/^\s*\*\s*$/gm, "")
      .replace(/^\s*[-*]\s*$/gm, "")
      .replace(/\*{2,}/g, "")
      .replace(/\n{3,}/g, "\n\n")
      .trim();

    if (cleanedText) {
      segments.push({ type: "text", content: cleanedText });
    }

    // Add the product
    segments.push({
      type: "product",
      product: {
        slug: match[1],
        name: match[2],
        price: parseInt(match[3], 10),
        category: match[4],
        inStock: match[5] === "true",
        imageUrl: match[6] || null,
      },
    });

    lastIndex = match.index + match[0].length;
  }

  // Add any remaining text after the last product
  const remainingText = text.slice(lastIndex);
  const cleanedRemaining = remainingText
    .replace(/\[PRODUCT:[^\]]+\]/g, "")
    .replace(/^\s*\*\s*$/gm, "")
    .replace(/^\s*[-*]\s*$/gm, "")
    .replace(/\*{2,}/g, "")
    .replace(/\n{3,}/g, "\n\n")
    .replace(/^\n+/, "")
    .replace(/\n+$/, "")
    .trim();

  if (cleanedRemaining) {
    segments.push({ type: "text", content: cleanedRemaining });
  }

  return segments;
}

// Product Card Component
function ChatProductCard({ product }: { product: Product }) {
  return (
    <Link
      href={`/products/${product.slug}`}
      className="block bg-card rounded-xl border border-border shadow-sm hover:shadow-md transition-all overflow-hidden group"
    >
      <div className="flex gap-3 p-2">
        <div className="relative w-16 h-16 rounded-lg overflow-hidden bg-muted flex-shrink-0">
          {product.imageUrl ? (
            <Image
              src={product.imageUrl}
              alt={product.name}
              fill
              className="object-cover group-hover:scale-105 transition-transform"
            />
          ) : (
            <div className="w-full h-full flex items-center justify-center text-muted-foreground">
              <ShoppingCart className="w-6 h-6" />
            </div>
          )}
        </div>
        <div className="flex-1 min-w-0">
          <h4 className="font-medium text-foreground text-sm line-clamp-1 group-hover:text-primary transition-colors">
            {product.name}
          </h4>
          <p className="text-xs text-muted-foreground mt-0.5">{product.category}</p>
          <div className="flex items-center justify-between mt-1">
            <span className="font-bold text-primary">
              {formatPrice(product.price)}
            </span>
            <span
              className={cn(
                "text-[10px] px-1.5 py-0.5 rounded-full",
                product.inStock
                  ? "bg-green-100 text-green-700"
                  : "bg-red-100 text-red-700"
              )}
            >
              {product.inStock ? "In Stock" : "Out"}
            </span>
          </div>
        </div>
        <div className="flex items-center">
          <ExternalLink className="w-4 h-4 text-muted-foreground group-hover:text-primary transition-colors" />
        </div>
      </div>
    </Link>
  );
}

export function ChatBot() {
  const t = useTranslations("Chatbot");
  const locale = useLocale();
  const [isOpen, setIsOpen] = useState(false);
  const [input, setInput] = useState("");
  const [showHumanOptions, setShowHumanOptions] = useState(false);
  const [guestName, setGuestName] = useState("");
  const [guestPhone, setGuestPhone] = useState("");
  const [userId, setUserId] = useState<string | null>(null);
  const [isCheckingAuth, setIsCheckingAuth] = useState(true);
  const [historyMessages, setHistoryMessages] = useState<
    { id: string; role: "user" | "assistant"; content: string }[]
  >([]);
  const [historyLoaded, setHistoryLoaded] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  // Initialize session ID and guest info lazily to avoid useEffect setState warning
  const [sessionId] = useState(() => {
    if (typeof window === "undefined") return "";
    const storedSession = localStorage.getItem("chat_session_id");
    if (storedSession) return storedSession;
    const newSession = generateSessionId();
    localStorage.setItem("chat_session_id", newSession);
    return newSession;
  });

  const [guestInfo, setGuestInfo] = useState<GuestInfo | null>(() => {
    if (typeof window === "undefined") return null;
    const storedGuestInfo = localStorage.getItem("chat_guest_info");
    if (storedGuestInfo) {
      try {
        return JSON.parse(storedGuestInfo);
      } catch {
        return null;
      }
    }
    return null;
  });

  const { messages, sendMessage, status } = useChat({
    transport: new DefaultChatTransport({
      api: "/api/chat",
      body: { locale },
    }),
  });

  const isLoading = status === "streaming" || status === "submitted";

  // Check if user is logged in and fetch profile data
  useEffect(() => {
    async function fetchUserData() {
      try {
        // First check if user is logged in
        const authRes = await fetch("/api/auth/me");
        const authData = await authRes.json() as { user?: { id: string; name?: string; email?: string } };
        
        if (authData.user) {
          setUserId(authData.user.id);
          
          // Fetch full profile data including phone
          const profileRes = await fetch("/api/user/profile");
          if (profileRes.ok) {
            const profileData = await profileRes.json() as { 
              profile?: { name?: string; phone?: string } 
            };
            if (profileData.profile) {
              setGuestInfo({ 
                name: profileData.profile.name || authData.user.name || "User", 
                phone: profileData.profile.phone || "" 
              });
            } else {
              setGuestInfo({ name: authData.user.name || "User", phone: "" });
            }
          } else {
            setGuestInfo({ name: authData.user.name || "User", phone: "" });
          }
        }
      } catch {
        // Ignore auth errors
      } finally {
        setIsCheckingAuth(false);
      }
    }
    fetchUserData();
  }, []);

  // Listen for custom event to open chatbot
  useEffect(() => {
    const handleOpenChatbot = () => setIsOpen(true);
    window.addEventListener("open-chatbot", handleOpenChatbot);
    return () => window.removeEventListener("open-chatbot", handleOpenChatbot);
  }, []);

  // Load chat history from database
  useEffect(() => {
    async function loadChatHistory() {
      if (!sessionId || historyLoaded) return;
      try {
        const res = await fetch(`/api/chat-history?sessionId=${sessionId}`);
        if (res.ok) {
          const data = await res.json() as {
            messages: { id: string; role: "user" | "assistant"; content: string }[];
            guestInfo: { name: string; phone: string } | null;
          };
          if (data.messages && data.messages.length > 0) {
            setHistoryMessages(data.messages);
          }
          // If we have saved guestInfo from history, use it
          if (data.guestInfo && data.guestInfo.phone) {
            setGuestInfo(data.guestInfo);
            localStorage.setItem("chat_guest_info", JSON.stringify(data.guestInfo));
          }
        }
      } catch {
        // Silently ignore - chat history is optional and may fail in dev mode
      } finally {
        setHistoryLoaded(true);
      }
    }
    loadChatHistory();
  }, [sessionId, historyLoaded]);

  // Auto scroll to bottom when chat opens or messages change
  useEffect(() => {
    if (messagesEndRef.current && isOpen) {
      // Use setTimeout to ensure the DOM has fully rendered
      setTimeout(() => {
        messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
      }, 100);
    }
  }, [messages, showHumanOptions, isOpen, historyMessages, historyLoaded]);

  // Auto-focus input when ready
  useEffect(() => {
    if (status === "ready" && isOpen && guestInfo) {
      inputRef.current?.focus();
    }
  }, [status, isOpen, guestInfo]);

  // Save message to database
  const saveMessage = useCallback(
    async (role: "user" | "assistant", content: string) => {
      if (!sessionId || !content.trim()) return;
      try {
        await fetch("/api/save-chat", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            sessionId,
            userId,
            guestInfo: userId ? undefined : guestInfo,
            message: { role, content },
          }),
        });
      } catch (error) {
        console.error("Failed to save message:", error);
      }
    },
    [sessionId, userId, guestInfo]
  );

  // Track saved messages to avoid duplicates
  const savedMessageIdsRef = useRef<Set<string>>(new Set());
  const prevStatusRef = useRef(status);

  // Save user messages immediately when sent
  useEffect(() => {
    messages.forEach((msg) => {
      if (msg.role === "user" && !savedMessageIdsRef.current.has(msg.id)) {
        const textContent = msg.parts
          .filter(
            (part): part is { type: "text"; text: string } =>
              part.type === "text"
          )
          .map((part) => part.text)
          .join("");
        if (textContent) {
          saveMessage("user", textContent);
          savedMessageIdsRef.current.add(msg.id);
        }
      }
    });
  }, [messages, saveMessage]);

  // Save AI responses when streaming completes
  useEffect(() => {
    if (prevStatusRef.current === "streaming" && status === "ready") {
      const lastMessage = messages[messages.length - 1];
      if (
        lastMessage &&
        lastMessage.role === "assistant" &&
        !savedMessageIdsRef.current.has(lastMessage.id)
      ) {
        const textContent = lastMessage.parts
          .filter(
            (part): part is { type: "text"; text: string } =>
              part.type === "text"
          )
          .map((part) => part.text)
          .join("");
        if (textContent) {
          saveMessage("assistant", textContent);
          savedMessageIdsRef.current.add(lastMessage.id);
        }
      }
    }
    prevStatusRef.current = status;
  }, [status, messages, saveMessage]);

  const handleGuestInfoSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // For logged-in users, only phone is required
    const nameToUse = userId ? (guestInfo?.name || guestName.trim()) : guestName.trim();
    const phoneToUse = guestPhone.trim();
    
    if ((userId || nameToUse) && phoneToUse) {
      const info = { name: nameToUse || "User", phone: phoneToUse };
      setGuestInfo(info);
      localStorage.setItem("chat_guest_info", JSON.stringify(info));
      
      // If user is logged in, save phone to their profile
      if (userId) {
        try {
          await fetch("/api/user/profile", {
            method: "PATCH",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ phone: info.phone }),
          });
        } catch (error) {
          console.error("Failed to save phone to profile:", error);
        }
      }
    }
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (input.trim() && status === "ready") {
      sendMessage({ text: input });
      setInput("");
      setShowHumanOptions(false);
      setTimeout(() => inputRef.current?.focus(), 0);
    }
  };

  // Render message content with product cards inline
  const renderMessageContent = (message: (typeof messages)[0]) => {
    const textContent = message.parts
      .filter(
        (part): part is { type: "text"; text: string } => part.type === "text"
      )
      .map((part) => part.text)
      .join("");

    const segments = parseProductsFromText(textContent);

    return (
      <div className="space-y-2">
        {segments.map((segment, idx) => {
          if (segment.type === "text") {
            return (
              <p key={`text-${idx}`} className="whitespace-pre-wrap">
                {segment.content}
              </p>
            );
          } else {
            return (
              <ChatProductCard
                key={`product-${segment.product.slug}-${idx}`}
                product={segment.product}
              />
            );
          }
        })}
      </div>
    );
  };

  const getWhatsAppLink = () => {
    const message = encodeURIComponent(
      locale === 'bn' ? `হ্যালো, আমি ${siteConfig.name} থেকে সাহায্য চাই।` : `Hello, I need help from ${siteConfig.name}.`
    );
    return `https://wa.me/${siteConfig.whatsapp.replace(
      /[^0-9]/g,
      ""
    )}?text=${message}`;
  };

  const getMessengerLink = () => {
    return `https://m.me/${siteConfig.facebookPageId}`;
  };

  // Show loading while checking auth
  if (isCheckingAuth) return null;

  return (
    <>
      {/* Chat Window - positioned on right side */}
      <div
        className={cn(
          "fixed z-50 transition-all duration-300 ease-out",
          "bottom-36 md:bottom-24 right-4",
          "w-[calc(100vw-2rem)] max-w-sm",
          isOpen
            ? "opacity-100 translate-y-0"
            : "opacity-0 translate-y-4 pointer-events-none"
        )}
      >
        <div className="bg-card rounded-2xl shadow-2xl border border-border overflow-hidden flex flex-col max-h-[70vh]">
          {/* Header */}
          <div className="brand-gradient p-4 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-full bg-card/20 flex items-center justify-center">
                <Bot className="w-5 h-5 text-white" />
              </div>
              <div>
                <h3 className="font-semibold text-white">{t('title')}</h3>
                <p className="text-xs text-white/80">
                  {guestInfo
                    ? t('subtitleUser', { name: guestInfo.name })
                    : t('subtitle')}
                </p>
              </div>
            </div>
            <button
              onClick={() => setIsOpen(false)}
              className="w-8 h-8 rounded-full bg-card/20 hover:bg-card/30 flex items-center justify-center transition-colors"
              aria-label="Close chat"
            >
              <X className="w-4 h-4 text-white" />
            </button>
          </div>

          {/* Guest Info Form (for non-logged in users OR logged in users missing phone) */}
          {(!guestInfo || !guestInfo.phone) && (
            <form
              onSubmit={handleGuestInfoSubmit}
              className="p-4 border-b border-border"
            >
              <p className="text-sm text-muted-foreground mb-3">
                {userId 
                  ? t('guestGreeting')
                  : t('guestGreeting')}
              </p>
              <div className="space-y-2">
                {!userId && (
                  <input
                    type="text"
                    value={guestName}
                    onChange={(e) => setGuestName(e.target.value)}
                    placeholder={t('namePlaceholder')}
                    className="w-full px-3 py-2 rounded-lg border border-border focus:outline-none focus:border-amber-400 text-sm"
                    required
                  />
                )}
                <input
                  type="tel"
                  value={guestPhone}
                  onChange={(e) => setGuestPhone(e.target.value)}
                  placeholder={t('phonePlaceholder')}
                  className="w-full px-3 py-2 rounded-lg border border-border focus:outline-none focus:border-amber-400 text-sm"
                  required
                />
                <button
                  type="submit"
                  className="w-full py-2 brand-gradient text-white rounded-lg font-medium text-sm transition-colors"
                >
                  {t('startButton')}
                </button>
              </div>
            </form>
          )}

          {/* Messages */}
          {guestInfo && guestInfo.phone && (
            <div className="flex-1 overflow-y-auto p-4 space-y-4 min-h-[200px] max-h-[300px]">
              {historyMessages.length === 0 && messages.length === 0 && (
                <div className="text-center py-6">
                  <div className="w-14 h-14 mx-auto mb-3 rounded-full bg-gradient-to-r from-amber-100 to-rose-100 flex items-center justify-center">
                    <Bot className="w-7 h-7 text-primary" />
                  </div>
                  <p className="text-muted-foreground text-sm">
                    {t('greeting')}
                  </p>
                </div>
              )}

              {/* History Messages from Database */}
              {historyMessages.map((msg) => (
                <div
                  key={`history-${msg.id}`}
                  className={cn(
                    "flex gap-2",
                    msg.role === "user" ? "justify-end" : "justify-start"
                  )}
                >
                  {msg.role === "assistant" && (
                    <div className="w-7 h-7 rounded-full bg-gradient-to-r from-amber-400 to-rose-400 flex items-center justify-center flex-shrink-0">
                      <Bot className="w-4 h-4 text-white" />
                    </div>
                  )}
                  <div
                    className={cn(
                      "max-w-[85%] rounded-2xl px-4 py-2 text-sm",
                      msg.role === "user"
                        ? "brand-gradient text-white rounded-br-md"
                        : "bg-muted text-foreground rounded-bl-md"
                    )}
                  >
                    <div className="space-y-2">
                      {parseProductsFromText(msg.content).map((segment, idx) => {
                        if (segment.type === "text") {
                          return (
                            <p key={`text-${idx}`} className="whitespace-pre-wrap">
                              {segment.content}
                            </p>
                          );
                        } else {
                          return (
                            <ChatProductCard
                              key={`product-${segment.product.slug}-${idx}`}
                              product={segment.product}
                            />
                          );
                        }
                      })}
                    </div>
                  </div>
                  {msg.role === "user" && (
                                        <div className="w-7 h-7 rounded-full bg-muted flex items-center justify-center flex-shrink-0">
                      <User className="w-4 h-4 text-muted-foreground" />
                    </div>
                  )}
                </div>
              ))}

              {messages.map((message) => (
                <div
                  key={message.id}
                  className={cn(
                    "flex gap-2",
                    message.role === "user" ? "justify-end" : "justify-start"
                  )}
                >
                  {message.role === "assistant" && (
                    <div className="w-7 h-7 rounded-full bg-gradient-to-r from-amber-400 to-rose-400 flex items-center justify-center flex-shrink-0">
                      <Bot className="w-4 h-4 text-white" />
                    </div>
                  )}
                  <div
                    className={cn(
                      "max-w-[85%] rounded-2xl px-4 py-2 text-sm",
                      message.role === "user"
                        ? "brand-gradient text-white rounded-br-md"
                        : "bg-muted text-foreground rounded-bl-md"
                    )}
                  >
                    {renderMessageContent(message)}
                  </div>
                  {message.role === "user" && (
                                        <div className="w-7 h-7 rounded-full bg-muted flex items-center justify-center flex-shrink-0">
                      <User className="w-4 h-4 text-muted-foreground" />
                    </div>
                  )}
                </div>
              ))}

              {isLoading && (
                <div className="flex gap-2 justify-start">
                  <div className="w-7 h-7 rounded-full bg-gradient-to-r from-amber-400 to-rose-400 flex items-center justify-center flex-shrink-0">
                    <Bot className="w-4 h-4 text-white" />
                  </div>
                  <div className="bg-muted rounded-2xl rounded-bl-md px-4 py-2">
                    <Loader2 className="w-4 h-4 animate-spin text-muted-foreground" />
                  </div>
                </div>
              )}

              {status === "error" && (
                <div className="text-center py-2">
                  <p className="text-red-500 text-xs">
                    কিছু সমস্যা হয়েছে। আবার চেষ্টা করুন।
                  </p>
                </div>
              )}

              {showHumanOptions && (
                <div className="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl p-4 border border-blue-100">
                  <div className="flex items-center gap-2 mb-3">
                    <Users className="w-4 h-4 text-blue-600" />
                    <p className="text-sm font-medium text-blue-800">
                      {t('humanSupportTitle')}
                    </p>
                  </div>
                  <div className="grid grid-cols-1 gap-2">
                    <a
                      href={getMessengerLink()}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center gap-2 bg-[#0084FF] text-white px-4 py-2.5 rounded-lg hover:bg-[#0073E6] transition-colors text-sm font-medium"
                    >
                      <FaFacebookMessenger className="w-4 h-4" />
                      {t('messenger')}
                    </a>
                    <a
                      href={getWhatsAppLink()}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="flex items-center gap-2 bg-[#25D366] text-white px-4 py-2.5 rounded-lg hover:bg-[#1DA851] transition-colors text-sm font-medium"
                    >
                      <FaWhatsapp className="w-4 h-4" />
                      {t('whatsapp')}
                    </a>
                    <a
                      href={`tel:${siteConfig.phone}`}
                      className="flex items-center gap-2 bg-emerald-500 text-white px-4 py-2.5 rounded-lg hover:bg-emerald-600 transition-colors text-sm font-medium"
                    >
                      <Phone className="w-4 h-4" />
                      {t('callUs')}
                    </a>
                  </div>
                </div>
              )}

              <div ref={messagesEndRef} />
            </div>
          )}

          {/* Talk to Human Button */}
          {guestInfo && guestInfo.phone && (
            <div className="px-4 pb-2">
              <button
                onClick={() => setShowHumanOptions(!showHumanOptions)}
                className={cn(
                  "w-full py-2 rounded-lg text-xs font-medium transition-colors flex items-center justify-center gap-2",
                  showHumanOptions
                    ? "bg-muted text-muted-foreground"
                    : "bg-blue-50 text-blue-600 hover:bg-blue-100"
                )}
              >
                <Users className="w-3.5 h-3.5" />
                {showHumanOptions ? t('closeHuman') : t('talkToHuman')}
              </button>
            </div>
          )}

          {/* Input */}
          {guestInfo && guestInfo.phone && (
            <form
              onSubmit={handleSubmit}
              className="p-4 border-t border-border"
            >
              <div className="flex gap-2">
                <input
                  ref={inputRef}
                  type="text"
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  placeholder={t('placeholder')}
                  className="flex-1 px-4 py-2 rounded-full border border-border focus:outline-none focus:border-amber-400 focus:ring-2 focus:ring-amber-100 text-sm"
                  disabled={status !== "ready"}
                />
                <button
                  type="submit"
                  disabled={status !== "ready" || !input.trim()}
                  className={cn(
                    "w-10 h-10 rounded-full flex items-center justify-center transition-all",
                    input.trim() && status === "ready"
                      ? "brand-gradient text-white"
                      : "bg-muted text-muted-foreground"
                  )}
                >
                  <Send className="w-4 h-4" />
                </button>
              </div>
            </form>
          )}
        </div>
      </div>
    </>
  );
}
