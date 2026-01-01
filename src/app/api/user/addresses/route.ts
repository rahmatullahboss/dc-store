import { NextRequest, NextResponse } from "next/server";
import { getDatabase, getAuth } from "@/lib/cloudflare";
import { addresses, sessions } from "@/db/schema";
import { headers } from "next/headers";
import { eq, and } from "drizzle-orm";
import { nanoid } from "nanoid";

export const dynamic = "force-dynamic";

// CORS headers for mobile app access
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

const MAX_ADDRESSES = 5;

// Helper to get user ID from Bearer token or session cookie
async function getUserId(request: NextRequest): Promise<string | null> {
  // First try Bearer token (for mobile app)
  const authHeader = request.headers.get("authorization");
  if (authHeader?.startsWith("Bearer ")) {
    const token = authHeader.slice(7);
    const db = await getDatabase();

    const session = await db
      .select()
      .from(sessions)
      .where(eq(sessions.token, token))
      .then((rows) => rows[0]);

    if (session && new Date(session.expiresAt) >= new Date()) {
      return session.userId;
    }
  }

  // Fallback to cookie-based session (for web)
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (session?.user) {
      return session.user.id;
    }
  } catch {
    // Ignore cookie session errors
  }

  return null;
}

export async function OPTIONS() {
  return NextResponse.json({}, { headers: corsHeaders });
}

// GET - Fetch all addresses for the authenticated user
export async function GET(request: NextRequest) {
  try {
    const userId = await getUserId(request);
    console.log("📍 Addresses API: Authenticated userId =", userId);

    if (!userId) {
      console.log("📍 Addresses API: No userId - returning Unauthorized");
      return NextResponse.json(
        { error: "Unauthorized", addresses: [] },
        { status: 401, headers: corsHeaders }
      );
    }

    const db = await getDatabase();
    
    // Debug: Get all addresses to see what exists
    const allAddresses = await db.select().from(addresses);
    console.log("📍 Addresses API: Total addresses in DB =", allAddresses.length);
    console.log("📍 Addresses API: All userIds in DB =", allAddresses.map(a => a.userId));
    
    const userAddresses = await db
      .select()
      .from(addresses)
      .where(eq(addresses.userId, userId))
      .orderBy(addresses.createdAt);

    console.log("📍 Addresses API: Found", userAddresses.length, "addresses for userId:", userId);

    return NextResponse.json(
      { addresses: userAddresses, total: userAddresses.length },
      { headers: corsHeaders }
    );
  } catch (error) {
    console.error("Error fetching addresses:", error);
    return NextResponse.json(
      { error: "Failed to fetch addresses", addresses: [] },
      { status: 500, headers: corsHeaders }
    );
  }
}

// POST - Add a new address
export async function POST(request: NextRequest) {
  try {
    const userId = await getUserId(request);

    if (!userId) {
      return NextResponse.json(
        { error: "Unauthorized" },
        { status: 401, headers: corsHeaders }
      );
    }

    const body = await request.json() as {
      name?: string;
      phone?: string;
      addressLine1?: string;
      addressLine2?: string;
      city?: string;
      state?: string;
      zipCode?: string;
      country?: string;
      type?: string;
      isDefault?: boolean;
    };
    
    const { name, phone, addressLine1, addressLine2, city, state, zipCode, country, type, isDefault } = body;

    // Validate required fields
    if (!name || !phone || !addressLine1 || !city) {
      return NextResponse.json(
        { error: "Name, phone, address, and city are required" },
        { status: 400, headers: corsHeaders }
      );
    }

    const db = await getDatabase();

    // Check address count limit
    const existingAddresses = await db
      .select()
      .from(addresses)
      .where(eq(addresses.userId, userId));

    if (existingAddresses.length >= MAX_ADDRESSES) {
      return NextResponse.json(
        { error: `Maximum ${MAX_ADDRESSES} addresses allowed` },
        { status: 400, headers: corsHeaders }
      );
    }

    // If this is the first address or isDefault is true, update other addresses
    const shouldBeDefault = isDefault || existingAddresses.length === 0;
    
    if (shouldBeDefault && existingAddresses.length > 0) {
      await db
        .update(addresses)
        .set({ isDefault: false, updatedAt: new Date() })
        .where(eq(addresses.userId, userId));
    }

    const newAddress = {
      id: `addr-${nanoid(10)}`,
      userId,
      name,
      phone,
      addressLine1,
      addressLine2: addressLine2 || null,
      city,
      state: state || null,
      zipCode: zipCode || null,
      country: country || "Bangladesh",
      type: (type || "home") as "home" | "office" | "other",
      isDefault: shouldBeDefault,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    await db.insert(addresses).values(newAddress);

    return NextResponse.json(
      { message: "Address added successfully", address: newAddress },
      { status: 201, headers: corsHeaders }
    );
  } catch (error) {
    console.error("Error adding address:", error);
    return NextResponse.json(
      { error: "Failed to add address" },
      { status: 500, headers: corsHeaders }
    );
  }
}

// PUT - Update an existing address
export async function PUT(request: NextRequest) {
  try {
    const userId = await getUserId(request);

    if (!userId) {
      return NextResponse.json(
        { error: "Unauthorized" },
        { status: 401, headers: corsHeaders }
      );
    }

    const body = await request.json() as {
      id?: string;
      name?: string;
      phone?: string;
      addressLine1?: string;
      addressLine2?: string;
      city?: string;
      state?: string;
      zipCode?: string;
      country?: string;
      type?: string;
      isDefault?: boolean;
    };
    
    const { id, name, phone, addressLine1, addressLine2, city, state, zipCode, country, type, isDefault } = body;

    if (!id) {
      return NextResponse.json(
        { error: "Address ID is required" },
        { status: 400, headers: corsHeaders }
      );
    }

    const db = await getDatabase();

    // Verify address belongs to user
    const existingAddress = await db
      .select()
      .from(addresses)
      .where(and(eq(addresses.id, id), eq(addresses.userId, userId)))
      .limit(1);

    if (existingAddress.length === 0) {
      return NextResponse.json(
        { error: "Address not found" },
        { status: 404, headers: corsHeaders }
      );
    }

    // If setting as default, update other addresses
    if (isDefault) {
      await db
        .update(addresses)
        .set({ isDefault: false, updatedAt: new Date() })
        .where(eq(addresses.userId, userId));
    }

    const updatedAddress = await db
      .update(addresses)
      .set({
        name: name || existingAddress[0].name,
        phone: phone || existingAddress[0].phone,
        addressLine1: addressLine1 || existingAddress[0].addressLine1,
        addressLine2: addressLine2 !== undefined ? addressLine2 : existingAddress[0].addressLine2,
        city: city || existingAddress[0].city,
        state: state !== undefined ? state : existingAddress[0].state,
        zipCode: zipCode !== undefined ? zipCode : existingAddress[0].zipCode,
        country: country || existingAddress[0].country,
        type: type ? (type as "home" | "office" | "other") : existingAddress[0].type,
        isDefault: isDefault !== undefined ? isDefault : existingAddress[0].isDefault,
        updatedAt: new Date(),
      })
      .where(eq(addresses.id, id))
      .returning();

    return NextResponse.json(
      { message: "Address updated successfully", address: updatedAddress[0] },
      { headers: corsHeaders }
    );
  } catch (error) {
    console.error("Error updating address:", error);
    return NextResponse.json(
      { error: "Failed to update address" },
      { status: 500, headers: corsHeaders }
    );
  }
}

// DELETE - Delete an address
export async function DELETE(request: NextRequest) {
  try {
    const userId = await getUserId(request);

    if (!userId) {
      return NextResponse.json(
        { error: "Unauthorized" },
        { status: 401, headers: corsHeaders }
      );
    }

    const { searchParams } = new URL(request.url);
    const id = searchParams.get("id");

    if (!id) {
      return NextResponse.json(
        { error: "Address ID is required" },
        { status: 400, headers: corsHeaders }
      );
    }

    const db = await getDatabase();

    // Verify address belongs to user
    const existingAddress = await db
      .select()
      .from(addresses)
      .where(and(eq(addresses.id, id), eq(addresses.userId, userId)))
      .limit(1);

    if (existingAddress.length === 0) {
      return NextResponse.json(
        { error: "Address not found" },
        { status: 404, headers: corsHeaders }
      );
    }

    const wasDefault = existingAddress[0].isDefault;

    await db.delete(addresses).where(eq(addresses.id, id));

    // If deleted address was default, make the first remaining address default
    if (wasDefault) {
      const remainingAddresses = await db
        .select()
        .from(addresses)
        .where(eq(addresses.userId, userId))
        .limit(1);

      if (remainingAddresses.length > 0) {
        await db
          .update(addresses)
          .set({ isDefault: true, updatedAt: new Date() })
          .where(eq(addresses.id, remainingAddresses[0].id));
      }
    }

    return NextResponse.json(
      { message: "Address deleted successfully" },
      { headers: corsHeaders }
    );
  } catch (error) {
    console.error("Error deleting address:", error);
    return NextResponse.json(
      { error: "Failed to delete address" },
      { status: 500, headers: corsHeaders }
    );
  }
}
