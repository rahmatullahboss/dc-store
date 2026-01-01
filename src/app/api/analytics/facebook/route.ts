import { NextResponse } from "next/server";
import { serverEvents } from "@/lib/facebook-capi";
import { headers } from "next/headers";

// API endpoint for client-side to trigger server-side Facebook CAPI events
// This allows tracking events that happen on the client but need server-side reliability

interface EventRequest {
  eventName: string;
  eventId?: string; // For deduplication with client-side pixel
  userData?: {
    email?: string;
    phone?: string;
    firstName?: string;
    lastName?: string;
    externalId?: string;
  };
  customData?: {
    contentId?: string;
    contentIds?: string[];
    contentName?: string;
    value?: number;
    currency?: string;
    numItems?: number;
    searchString?: string;
  };
}

export async function POST(request: Request) {
  try {
    const body: EventRequest = await request.json();
    const headersList = await headers();

    if (!body.eventName) {
      return NextResponse.json(
        { error: "Event name is required" },
        { status: 400 }
      );
    }

    // Get client info from headers
    const clientIp =
      headersList.get("x-forwarded-for")?.split(",")[0] ||
      headersList.get("x-real-ip") ||
      undefined;
    const userAgent = headersList.get("user-agent") || undefined;
    const referer = headersList.get("referer") || undefined;

    // Get Facebook cookies if available
    const cookies = headersList.get("cookie") || "";
    const fbcMatch = cookies.match(/_fbc=([^;]+)/);
    const fbpMatch = cookies.match(/_fbp=([^;]+)/);
    const fbc = fbcMatch ? fbcMatch[1] : undefined;
    const fbp = fbpMatch ? fbpMatch[1] : undefined;

    const userData = {
      ...body.userData,
      clientIpAddress: clientIp,
      clientUserAgent: userAgent,
      fbc,
      fbp,
    };

    let result;

    switch (body.eventName) {
      case "ViewContent":
        result = await serverEvents.viewContent({
          contentId: body.customData?.contentId || "",
          contentName: body.customData?.contentName || "",
          value: body.customData?.value || 0,
          currency: body.customData?.currency,
          userData,
          eventSourceUrl: referer,
        });
        break;

      case "AddToCart":
        result = await serverEvents.addToCart({
          contentId: body.customData?.contentId || "",
          contentName: body.customData?.contentName || "",
          value: body.customData?.value || 0,
          currency: body.customData?.currency,
          userData,
          eventSourceUrl: referer,
        });
        break;

      case "InitiateCheckout":
        result = await serverEvents.initiateCheckout({
          value: body.customData?.value || 0,
          contentIds: body.customData?.contentIds || [],
          numItems: body.customData?.numItems || 0,
          currency: body.customData?.currency,
          userData,
          eventSourceUrl: referer,
        });
        break;

      case "Search":
        result = await serverEvents.search({
          searchString: body.customData?.searchString || "",
          userData,
          eventSourceUrl: referer,
        });
        break;

      case "CompleteRegistration":
        result = await serverEvents.completeRegistration({
          userData,
          eventSourceUrl: referer,
        });
        break;

      case "Lead":
        result = await serverEvents.lead({
          userData,
          eventSourceUrl: referer,
        });
        break;

      default:
        return NextResponse.json(
          { error: `Unknown event: ${body.eventName}` },
          { status: 400 }
        );
    }

    return NextResponse.json({
      success: result.success,
      eventId: result.eventId,
      error: result.error,
    });
  } catch (error) {
    console.error("Facebook CAPI endpoint error:", error);
    return NextResponse.json(
      { error: "Failed to send event" },
      { status: 500 }
    );
  }
}
