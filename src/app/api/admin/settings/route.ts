import { NextResponse } from "next/server";
import { getAuth } from "@/lib/cloudflare";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

// Settings stored in user preferences for now
// In production, this would be in a dedicated settings table

// GET - Fetch admin settings
export async function GET() {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || session.user.role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    // Return default settings for now
    // In production, fetch from settings table
    const settings = {
      storeName: process.env.NEXT_PUBLIC_BRAND_NAME || "DC Store",
      storeEmail: process.env.NEXT_PUBLIC_CONTACT_EMAIL || "contact@dcstore.com",
      storePhone: process.env.NEXT_PUBLIC_CONTACT_PHONE || "+880123456789",
      storeAddress: process.env.NEXT_PUBLIC_STORE_ADDRESS || "Dhaka, Bangladesh",
      deliveryInsideDhaka: parseInt(process.env.NEXT_PUBLIC_DEFAULT_SHIPPING || "60"),
      deliveryOutsideDhaka: parseInt(process.env.NEXT_PUBLIC_EXPRESS_SHIPPING || "120"),
    };

    return NextResponse.json({ settings });
  } catch (error) {
    console.error("Error fetching settings:", error);
    return NextResponse.json({ error: "Failed to fetch settings" }, { status: 500 });
  }
}

// POST - Save admin settings
export async function POST(request: Request) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || session.user.role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await request.json() as {
      storeName?: string;
      storeEmail?: string;
      storePhone?: string;
      storeAddress?: string;
      deliveryInsideDhaka?: number;
      deliveryOutsideDhaka?: number;
    };

    // In production, save to settings table
    // For now, we acknowledge the save but settings are env-based
    console.log("Settings saved:", body);

    return NextResponse.json({ 
      success: true,
      message: "Settings saved successfully",
      note: "Settings are currently environment-based. Database persistence coming soon."
    });
  } catch (error) {
    console.error("Error saving settings:", error);
    return NextResponse.json({ error: "Failed to save settings" }, { status: 500 });
  }
}
