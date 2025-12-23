import { NextResponse } from "next/server";

// Using default runtime for OpenNext compatibility

export async function GET() {
  // TODO: Implement actual auth check with Better Auth
  // For now, return null user (guest mode)
  return NextResponse.json({ user: null });
}
