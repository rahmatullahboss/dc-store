import { NextResponse } from "next/server";
import Stripe from "stripe";
import { getAuth } from "@/lib/cloudflare";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

function getStripe() {
  if (!process.env.STRIPE_SECRET_KEY) {
    throw new Error("STRIPE_SECRET_KEY is not configured");
  }
  return new Stripe(process.env.STRIPE_SECRET_KEY);
}

export async function POST(request: Request) {
  try {
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    if (!session?.user) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const body = await request.json() as {
      transactionId: string;
      amount?: number;
      reason?: string;
    };

    const { transactionId, amount, reason } = body;

    if (!transactionId) {
      return NextResponse.json(
        { error: "Transaction ID is required" },
        { status: 400 }
      );
    }

    const stripe = getStripe();

    // Create refund using Context7 pattern
    const refundParams: Stripe.RefundCreateParams = {
      payment_intent: transactionId,
      reason: reason === "duplicate" ? "duplicate" : 
              reason === "fraudulent" ? "fraudulent" : "requested_by_customer",
    };

    if (amount) {
      refundParams.amount = amount;
    }

    const refund = await stripe.refunds.create(refundParams);

    return NextResponse.json({
      success: true,
      refundId: refund.id,
      status: refund.status,
      amount: refund.amount,
    });
  } catch (error: unknown) {
    console.error("Error processing refund:", error);
    if (error instanceof Stripe.errors.StripeError) {
      return NextResponse.json(
        { error: error.message },
        { status: error.statusCode || 500 }
      );
    }
    return NextResponse.json(
      { error: "Failed to process refund" },
      { status: 500 }
    );
  }
}
