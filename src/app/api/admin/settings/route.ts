import { NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { siteSettings, SettingsData } from "@/db/schema";
import { eq } from "drizzle-orm";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

const defaultSettings: SettingsData = {
  storeName: "DC Store",
  storeEmail: "contact@dcstore.com",
  storePhone: "+880123456789",
  storeAddress: "Dhaka, Bangladesh",
  deliveryInsideDhaka: 60,
  deliveryOutsideDhaka: 120,
  freeDeliveryThreshold: 1500,
  enableFreeDelivery: true,
  enableCOD: true,
  enableStripe: true,
  enableBkash: false,
  notifyNewOrder: true,
  notifyLowStock: true,
  lowStockThreshold: 5,
};

// GET - Fetch admin settings
export async function GET() {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const db = await getDatabase();
    
    // Try to get settings from database
    const result = await db
      .select()
      .from(siteSettings)
      .where(eq(siteSettings.id, "default"))
      .limit(1);

    const savedSettings = result[0]?.settings || {};
    
    // Merge with defaults
    const settings = { ...defaultSettings, ...savedSettings };

    return NextResponse.json({ settings });
  } catch (error) {
    console.error("Error fetching settings:", error);
    // Return defaults on error
    return NextResponse.json({ settings: defaultSettings });
  }
}

// POST - Save admin settings
export async function POST(request: Request) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user || (session.user as { role?: string }).role !== "admin") {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await request.json() as SettingsData;
    const db = await getDatabase();

    // Upsert settings
    await db
      .insert(siteSettings)
      .values({
        id: "default",
        settings: body,
        updatedAt: new Date(),
        updatedBy: session.user.id,
      })
      .onConflictDoUpdate({
        target: siteSettings.id,
        set: {
          settings: body,
          updatedAt: new Date(),
          updatedBy: session.user.id,
        },
      });

    return NextResponse.json({ 
      success: true,
      message: "Settings saved successfully"
    });
  } catch (error) {
    console.error("Error saving settings:", error);
    return NextResponse.json({ error: "Failed to save settings" }, { status: 500 });
  }
}
