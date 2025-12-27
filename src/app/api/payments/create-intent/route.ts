import { NextResponse } from "next/server";
import Stripe from "stripe";
import { getAuth } from "@/lib/cloudflare";
import { headers } from "next/headers";

export const dynamic = "force-dynamic";

// Lazy Stripe initialization with fetch for Cloudflare Workers compatibility
function getStripe() {
  if (!process.env.STRIPE_SECRET_KEY) {
    throw new Error("STRIPE_SECRET_KEY is not configured");
  }
  return new Stripe(process.env.STRIPE_SECRET_KEY, {
    httpClient: Stripe.createFetchHttpClient(),
  });
}

export async function POST(request: Request) {
  try {
    const stripe = getStripe();
    
    const auth = await getAuth();
    const headersList = await headers();
    const session = await auth.api.getSession({ headers: headersList });

    const body = await request.json() as {
      amount: number;
      currency?: string;
      customerId?: string;
      metadata?: Record<string, string>;
    };

    const { amount, currency = "bdt", customerId, metadata } = body;

    if (!amount || amount < 100) {
      return NextResponse.json(
        { error: "Amount must be at least 100 (smallest currency unit)" },
        { status: 400 }
      );
    }

    // Create or retrieve Stripe customer
    let stripeCustomerId = customerId;
    let ephemeralKey: string | undefined;

    if (session?.user?.email && !customerId) {
      const customers = await stripe.customers.list({
        email: session.user.email,
        limit: 1,
      });

      if (customers.data.length > 0) {
        stripeCustomerId = customers.data[0].id;
      } else {
        const customer = await stripe.customers.create({
          email: session.user.email,
          name: session.user.name || undefined,
        });
        stripeCustomerId = customer.id;
      }

      const key = await stripe.ephemeralKeys.create(
        { customer: stripeCustomerId },
        { apiVersion: "2024-12-18.acacia" }
      );
      ephemeralKey = key.secret;
    }

    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
      customer: stripeCustomerId || undefined,
      metadata: {
        ...metadata,
        userId: session?.user?.id || "guest",
      },
      automatic_payment_methods: {
        enabled: true,
      },
    });

    return NextResponse.json({
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
      customerId: stripeCustomerId,
      ephemeralKey,
    });
  } catch (error: unknown) {
    console.error("Error creating payment intent:", error);
    if (error instanceof Stripe.errors.StripeError) {
      return NextResponse.json(
        { error: error.message },
        { status: error.statusCode || 500 }
      );
    }
    return NextResponse.json(
      { error: "Failed to create payment intent" },
      { status: 500 }
    );
  }
}
