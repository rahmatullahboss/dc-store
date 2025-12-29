"use client";

import { Phone, MessageCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { siteConfig } from "@/lib/config";

export function FloatingContactButtons() {
  const handleOpenChat = () => {
    // Dispatch custom event to open chatbot
    window.dispatchEvent(new CustomEvent("open-chatbot"));
  };

  return (
    <div className="fixed bottom-20 md:bottom-6 right-4 z-40 flex flex-col items-end gap-3">
      {/* Call Button */}
      <Button
        asChild
        size="sm"
        className="bg-emerald-500 text-white shadow-lg shadow-emerald-500/30 hover:scale-105 hover:bg-emerald-600 transition-all duration-200"
      >
        <a href={`tel:${siteConfig.phone}`} aria-label="Call us">
          <Phone className="h-4 w-4 mr-2" />
          Call Now
        </a>
      </Button>

      {/* Chat Button */}
      <Button
        size="sm"
        onClick={handleOpenChat}
        className="brand-gradient brand-gradient-shadow text-white hover:scale-105 transition-all duration-200"
      >
        <MessageCircle className="h-4 w-4 mr-2" />
        Chat
      </Button>
    </div>
  );
}
