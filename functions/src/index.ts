import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";
import axios from "axios";
import {Timestamp} from "firebase-admin/firestore";
import {defineSecret} from "firebase-functions/params";
import {CallableRequest} from "firebase-functions/v2/https";

// Initialize Firebase Admin SDK
admin.initializeApp();

// --- Define Razorpay secrets ---
const razorpayKeyId = defineSecret("RAZORPAY_KEY_ID");
const razorpayKeySecret = defineSecret("RAZORPAY_KEY_SECRET");

// Interface for Razorpay order creation request
interface RazorpayOrderRequest {
  amount: number; // Amount in paise
  currency?: string;
  receipt?: string;
  notes?: {[key: string]: string};
}

// Interface for Razorpay order response
interface RazorpayOrderResponse {
  id: string;
  entity: string;
  amount: number;
  amount_paid: number;
  amount_due: number;
  currency: string;
  receipt: string;
  status: string;
  attempts: number;
  notes: {[key: string]: string};
  created_at: number;
}

// =============================================================================
// RAZORPAY CLOUD FUNCTIONS
// =============================================================================

/**
 * Creates a Razorpay Order on the backend.
 * This order ID is then used in the frontend checkout.
 * API Endpoint: POST https://api.razorpay.com/v1/orders
 */
export const createRazorpayOrder = functions.https.onCall({
  secrets: [razorpayKeyId, razorpayKeySecret],
}, async (request: CallableRequest<RazorpayOrderRequest>) => {
  console.log("=== createRazorpayOrder function called ===");
  console.log("Request data:", JSON.stringify(request.data, null, 2));
  console.log(
    "Request auth:",
    request.auth ? {uid: request.auth.uid} : "No auth"
  );

  // Get secret values
  const KEY_ID = razorpayKeyId.value();
  const KEY_SECRET = razorpayKeySecret.value();

  console.log("Razorpay Configuration:");
  console.log("KEY_ID:", KEY_ID ? "***SET***" : "undefined");
  console.log("KEY_SECRET:", KEY_SECRET ? "***SET***" : "undefined");

  // 1. Validate input and user authentication
  if (!KEY_ID || !KEY_SECRET) {
    console.error("Razorpay credentials not configured");
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Server is not configured for Razorpay payments."
    );
  }

  if (!request.auth) {
    console.error("No authentication provided");
    throw new functions.https.HttpsError(
      "unauthenticated",
      "You must be logged in to create an order."
    );
  }

  if (
    !request.data ||
    typeof request.data.amount !== "number" ||
    request.data.amount <= 0
  ) {
    console.error("Invalid amount:", request.data?.amount);
    throw new functions.https.HttpsError(
      "invalid-argument",
      "A valid amount in paise is required."
    );
  }

  const userId = request.auth.uid;
  const amount = Math.round(request.data.amount); // Amount in paise
  const currency = request.data.currency || "INR";
  const receipt =
    request.data.receipt || `receipt_${Date.now()}`;
  const notes = request.data.notes || {};

  console.log(
    `Creating Razorpay order for userId: ${userId}, ` +
    `amount: ${amount} paise`
  );

  try {
    // 2. Create order with Razorpay API
    const razorpayAuth = Buffer
      .from(`${KEY_ID}:${KEY_SECRET}`)
      .toString("base64");

    const orderData = {
      amount: amount,
      currency: currency,
      receipt: receipt,
      notes: {
        ...notes,
        userId: userId,
      },
    };

    console.log(
      "Sending request to Razorpay:",
      JSON.stringify(orderData, null, 2)
    );

    const response = await axios.post<RazorpayOrderResponse>(
      "https://api.razorpay.com/v1/orders",
      orderData,
      {
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Basic ${razorpayAuth}`,
        },
      }
    );

    console.log(
      "Razorpay response:",
      JSON.stringify(response.data, null, 2)
    );

    const razorpayOrder = response.data;

    // 3. Validate Razorpay response
    if (!razorpayOrder.id) {
      console.error("No order ID in Razorpay response:", razorpayOrder);
      throw new Error("Razorpay did not return an order ID");
    }

    // 4. Save the transaction to Firestore with the Razorpay order ID
    const orderId = razorpayOrder.id;

    await admin
      .firestore()
      .collection("transactions")
      .doc(orderId)
      .set({
        orderId: orderId,
        userId: userId,
        amount: razorpayOrder.amount,
        currency: razorpayOrder.currency,
        receipt: razorpayOrder.receipt,
        status: "PENDING",
        razorpayOrderId: razorpayOrder.id,
        razorpayStatus: razorpayOrder.status,
        notes: razorpayOrder.notes,
        createdAt: Timestamp.now(),
        razorpayCreatedAt:
          Timestamp.fromMillis(razorpayOrder.created_at * 1000),
      });

    console.log(`Transaction created in Firestore with orderId: ${orderId}`);

    // 5. Return the Razorpay order details to the client
    return {
      orderId: razorpayOrder.id,
      amount: razorpayOrder.amount,
      currency: razorpayOrder.currency,
      receipt: razorpayOrder.receipt,
      status: razorpayOrder.status,
    };
  } catch (error: unknown) {
    console.error("Error creating Razorpay order:", error);

    // Handle Axios-specific errors
    if (axios.isAxiosError(error) && error.response) {
      console.error("Razorpay API Error:", {
        status: error.response.status,
        statusText: error.response.statusText,
        data: error.response.data,
      });

      throw new functions.https.HttpsError(
        "internal",
        `Razorpay API error: ${JSON.stringify(error.response.data)}`
      );
    }

    // Re-throw known errors or create a generic one
    throw error instanceof functions.https.HttpsError ?
      error :
      new functions.https.HttpsError(
        "internal",
        "Failed to create Razorpay order."
      );
  }
});
