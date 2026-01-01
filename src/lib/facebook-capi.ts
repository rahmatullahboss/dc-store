// Facebook Conversions API Server-Side Tracking
// This sends events directly to Facebook's servers, bypassing ad blockers

interface ConversionEventData {
  eventName: string;
  eventTime?: number;
  eventId?: string;
  userData?: {
    email?: string;
    phone?: string;
    firstName?: string;
    lastName?: string;
    city?: string;
    state?: string;
    country?: string;
    externalId?: string;
    clientIpAddress?: string;
    clientUserAgent?: string;
    fbc?: string; // Facebook click ID from cookie
    fbp?: string; // Facebook browser ID from cookie
  };
  customData?: {
    currency?: string;
    value?: number;
    contentIds?: string[];
    contentName?: string;
    contentType?: string;
    numItems?: number;
    orderId?: string;
    searchString?: string;
  };
  eventSourceUrl?: string;
  actionSource?: "website" | "app" | "email" | "phone_call" | "chat" | "other";
}

interface FacebookApiResponse {
  events_received?: number;
  messages?: string[];
  fbtrace_id?: string;
  error?: {
    message: string;
    type: string;
    code: number;
  };
}

// Hash function for PII data (Facebook requires SHA256 hashing)
async function hashData(data: string): Promise<string> {
  const encoder = new TextEncoder();
  const dataBuffer = encoder.encode(data.toLowerCase().trim());
  const hashBuffer = await crypto.subtle.digest("SHA-256", dataBuffer);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map((b) => b.toString(16).padStart(2, "0")).join("");
}

// Prepare user data with proper hashing
async function prepareUserData(
  userData: ConversionEventData["userData"]
): Promise<Record<string, string>> {
  if (!userData) return {};

  const prepared: Record<string, string> = {};

  if (userData.email) {
    prepared.em = await hashData(userData.email);
  }
  if (userData.phone) {
    // Remove all non-numeric characters
    const cleanPhone = userData.phone.replace(/\D/g, "");
    prepared.ph = await hashData(cleanPhone);
  }
  if (userData.firstName) {
    prepared.fn = await hashData(userData.firstName);
  }
  if (userData.lastName) {
    prepared.ln = await hashData(userData.lastName);
  }
  if (userData.city) {
    prepared.ct = await hashData(userData.city);
  }
  if (userData.state) {
    prepared.st = await hashData(userData.state);
  }
  if (userData.country) {
    prepared.country = await hashData(userData.country);
  }
  if (userData.externalId) {
    prepared.external_id = await hashData(userData.externalId);
  }

  // These don't need hashing
  if (userData.clientIpAddress) {
    prepared.client_ip_address = userData.clientIpAddress;
  }
  if (userData.clientUserAgent) {
    prepared.client_user_agent = userData.clientUserAgent;
  }
  if (userData.fbc) {
    prepared.fbc = userData.fbc;
  }
  if (userData.fbp) {
    prepared.fbp = userData.fbp;
  }

  return prepared;
}

// Generate a unique event ID for deduplication
export function generateEventId(): string {
  return `${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
}

// Send event to Facebook Conversions API
export async function sendConversionEvent(
  eventData: ConversionEventData
): Promise<{ success: boolean; eventId: string; error?: string }> {
  const pixelId = process.env.NEXT_PUBLIC_FACEBOOK_PIXEL_ID;
  const accessToken = process.env.FACEBOOK_CONVERSIONS_API_TOKEN;

  // Generate event ID for deduplication with client-side pixel
  const eventId = eventData.eventId || generateEventId();

  // If no access token, skip server-side tracking (client-side still works)
  if (!accessToken || !pixelId) {
    console.log("Facebook CAPI: Missing credentials, skipping server-side event");
    return { success: false, eventId, error: "Missing CAPI credentials" };
  }

  try {
    const userData = await prepareUserData(eventData.userData);

    const payload = {
      data: [
        {
          event_name: eventData.eventName,
          event_time: eventData.eventTime || Math.floor(Date.now() / 1000),
          event_id: eventId,
          event_source_url: eventData.eventSourceUrl,
          action_source: eventData.actionSource || "website",
          user_data: userData,
          custom_data: eventData.customData
            ? {
                currency: eventData.customData.currency || "BDT",
                value: eventData.customData.value,
                content_ids: eventData.customData.contentIds,
                content_name: eventData.customData.contentName,
                content_type: eventData.customData.contentType,
                num_items: eventData.customData.numItems,
                order_id: eventData.customData.orderId,
                search_string: eventData.customData.searchString,
              }
            : undefined,
        },
      ],
    };

    const response = await fetch(
      `https://graph.facebook.com/v18.0/${pixelId}/events?access_token=${accessToken}`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      }
    );

    const result = (await response.json()) as FacebookApiResponse;

    if (result.error) {
      console.error("Facebook CAPI Error:", result.error);
      return { success: false, eventId, error: result.error.message };
    }

    console.log(`Facebook CAPI: ${eventData.eventName} event sent successfully`);
    return { success: true, eventId };
  } catch (error) {
    console.error("Facebook CAPI Error:", error);
    return {
      success: false,
      eventId,
      error: error instanceof Error ? error.message : "Unknown error",
    };
  }
}

// Predefined server-side events
export const serverEvents = {
  // Purchase event - most important for ROAS tracking
  purchase: async (params: {
    orderId: string;
    value: number;
    contentIds: string[];
    numItems: number;
    currency?: string;
    userData?: ConversionEventData["userData"];
    eventSourceUrl?: string;
  }) => {
    return sendConversionEvent({
      eventName: "Purchase",
      customData: {
        orderId: params.orderId,
        value: params.value,
        contentIds: params.contentIds,
        numItems: params.numItems,
        currency: params.currency || "BDT",
        contentType: "product",
      },
      userData: params.userData,
      eventSourceUrl: params.eventSourceUrl,
    });
  },

  // InitiateCheckout
  initiateCheckout: async (params: {
    value: number;
    contentIds: string[];
    numItems: number;
    currency?: string;
    userData?: ConversionEventData["userData"];
    eventSourceUrl?: string;
  }) => {
    return sendConversionEvent({
      eventName: "InitiateCheckout",
      customData: {
        value: params.value,
        contentIds: params.contentIds,
        numItems: params.numItems,
        currency: params.currency || "BDT",
        contentType: "product",
      },
      userData: params.userData,
      eventSourceUrl: params.eventSourceUrl,
    });
  },

  // AddToCart
  addToCart: async (params: {
    contentId: string;
    contentName: string;
    value: number;
    currency?: string;
    userData?: ConversionEventData["userData"];
    eventSourceUrl?: string;
  }) => {
    return sendConversionEvent({
      eventName: "AddToCart",
      customData: {
        contentIds: [params.contentId],
        contentName: params.contentName,
        value: params.value,
        currency: params.currency || "BDT",
        contentType: "product",
      },
      userData: params.userData,
      eventSourceUrl: params.eventSourceUrl,
    });
  },

  // ViewContent
  viewContent: async (params: {
    contentId: string;
    contentName: string;
    value: number;
    currency?: string;
    userData?: ConversionEventData["userData"];
    eventSourceUrl?: string;
  }) => {
    return sendConversionEvent({
      eventName: "ViewContent",
      customData: {
        contentIds: [params.contentId],
        contentName: params.contentName,
        value: params.value,
        currency: params.currency || "BDT",
        contentType: "product",
      },
      userData: params.userData,
      eventSourceUrl: params.eventSourceUrl,
    });
  },

  // CompleteRegistration
  completeRegistration: async (params: {
    userData?: ConversionEventData["userData"];
    eventSourceUrl?: string;
  }) => {
    return sendConversionEvent({
      eventName: "CompleteRegistration",
      userData: params.userData,
      eventSourceUrl: params.eventSourceUrl,
    });
  },

  // Lead (Contact form submission)
  lead: async (params: {
    userData?: ConversionEventData["userData"];
    eventSourceUrl?: string;
  }) => {
    return sendConversionEvent({
      eventName: "Lead",
      userData: params.userData,
      eventSourceUrl: params.eventSourceUrl,
    });
  },

  // Search
  search: async (params: {
    searchString: string;
    userData?: ConversionEventData["userData"];
    eventSourceUrl?: string;
  }) => {
    return sendConversionEvent({
      eventName: "Search",
      customData: {
        searchString: params.searchString,
      },
      userData: params.userData,
      eventSourceUrl: params.eventSourceUrl,
    });
  },
};
