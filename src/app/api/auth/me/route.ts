import { NextResponse } from "next/server";

export const runtime = "edge";

export async function GET() {
  // TODO: Implement actual auth check with Better Auth
  // For now, return null user (guest mode)
  return NextResponse.json({ user: null });
}
