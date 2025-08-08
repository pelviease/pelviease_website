import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios, {isAxiosError} from "axios";
import {v4 as uuidv4} from "uuid";

// Interface for PhonePe order status response
interface PhonePeOrderStatusResponse {
  orderId?: string;
  state?: string;
  amount?: number;
  [key: string]: unknown;
}

// Initialize Firebase Admin SDK
admin.initializeApp();

// --- PhonePe UAT (Test) Configuration ---
const PHONEPE_HOST_URL = "https://api-preprod.phonepe.com/apis/pg-sandbox";
const MERCHANT_ID = process.env.PHONEPE_MERCHANT_ID;
const CLIENT_ID = process.env.PHONEPE_CLIENT_ID;
const CLIENT_SECRET = process.env.PHONEPE_CLIENT_SECRET;

// The URL where the user is redirected after payment is complete
const APP_REDIRECT_URL = "https://pelviease.com/#/orders";

// =============================================================================
// HELPER FUNCTIONS
// =============================================================================

/**
 * Gets an OAuth access token from the PhonePe API.
 * API Endpoint: POST /v1/oauth/token
 * @return {Promise<string>} The access token.
 */
async function getPhonePeAccessToken(): Promise<string> {
  try {
    if (!CLIENT_ID || !CLIENT_SECRET) {
      throw new Error("CLIENT_ID and CLIENT_SECRET are required.");
    }

    const requestHeaders = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    const requestBody = new URLSearchParams({
      "client_id": CLIENT_ID,
      "client_secret": CLIENT_SECRET,
      "client_version": "1",
      "grant_type": "client_credentials",
    }).toString();

    const options = {
      method: "POST",
      url: `${PHONEPE_HOST_URL}/v1/oauth/token`,
      headers: requestHeaders,
      data: requestBody,
    };

    const response = await axios.request(options);

    if (!response.data?.access_token) {
      throw new Error("No access token received from PhonePe");
    }

    return response.data.access_token;
  } catch (error) {
    console.error("Error getting PhonePe access token:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to authenticate with PhonePe."
    );
  }
}

/**
 * Checks the status of an order with the PhonePe API.
 * API Endpoint: GET /checkout/v2/order/{merchantOrderId}/status
 * @param {string} merchantOrderId - The unique ID for the order in your system.
 * @param {string} accessToken - The PhonePe access token.
 * @return {Promise<PhonePeOrderStatusResponse>} The order status response.
 */
async function checkPhonePeOrderStatus(
  merchantOrderId: string,
  accessToken: string
): Promise<PhonePeOrderStatusResponse> {
  try {
    const requestHeaders = {
      "Content-Type": "application/json",
      "Authorization": `O-Bearer ${accessToken}`,
    };

    const options = {
      method: "GET",
      url: `${PHONEPE_HOST_URL}/checkout/v2/order/${merchantOrderId}/status`,
      headers: requestHeaders,
    };

    const response = await axios.request(options);
    return response.data;
  } catch (error) {
    console.error(`Error checking status for ${merchantOrderId}:`, error);
    // Don't throw HttpsError here, let the caller handle it
    throw error;
  }
}


// =============================================================================
// CALLABLE CLOUD FUNCTIONS
// =============================================================================

/**
 * Initiates a payment with PhonePe.
 * Called by the client app to get a redirect URL for payment.
 * API Endpoint: POST /checkout/v2/pay
 */
export const initiatePhonePePayment = functions.https.onCall(
  {
    secrets: [
      "PHONEPE_MERCHANT_ID",
      "PHONEPE_CLIENT_ID",
      "PHONEPE_CLIENT_SECRET",
    ],
  },
  async (request) => {
    // 1. Validate input and user authentication
    if (!MERCHANT_ID || !CLIENT_ID || !CLIENT_SECRET) {
      throw new functions.https.HttpsError(
        "failed-precondition", "Server is not configured for payments."
      );
    }
    if (!request.data || typeof request.data.amount !== "number" ||
        request.data.amount <= 0) {
      throw new functions.https.HttpsError(
        "invalid-argument", "A valid amount is required."
      );
    }
    if (!request.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "You must be logged in to make a payment."
      );
    }

    const amount = Math.round(request.data.amount); // Amount in paise
    const userId = request.auth.uid;
    const merchantOrderId = `ORDER-${uuidv4()}`;

    try {
      // 2. Get PhonePe Access Token
      const accessToken = await getPhonePeAccessToken();

      // 3. Prepare the payment payload
      const paymentData = {
        merchantOrderId: merchantOrderId,

        amount: amount,
        expireAfter: 1200, // 20 minutes
        metaInfo: {
          udf1: userId,
          udf2: "Pelviease",
        },
        paymentFlow: {
          type: "PG_CHECKOUT",
          message: "Payment for your service or product",
          merchantUrls: {
            redirectUrl: `${APP_REDIRECT_URL}?order_id=${
              merchantOrderId
            }`,
          },
        },
      };

      // 4. Make the request to PhonePe to create the payment
      const options = {
        method: "POST",
        url: `${PHONEPE_HOST_URL}/checkout/v2/pay`,
        headers: {
          "Content-Type": "application/json",
          "Authorization": `O-Bearer ${accessToken}`,
        },
        data: paymentData,
      };

      const response = await axios.request(options);

      // 5. Validate PhonePe's response
      if (!response.data?.orderId || !response.data?.redirectUrl) {
        console.error(
          "PhonePe API returned incomplete response:",
          response.data
        );
        throw new Error("PhonePe did not return complete payment data");
      }

      const {orderId, redirectUrl, state, expireAt} = response.data;
      console.log(
        `Payment initiated successfully: ${orderId}`
      );
      console.log(
        `Redirect URL: ${redirectUrl}`
      );
      // 6. Save the pending transaction to Firestore
      await admin.firestore()
        .collection("transactions")
        .doc(merchantOrderId)
        .set({
          userId: userId,
          amount: Number(amount),
          status: "PENDING",
          merchantOrderId: merchantOrderId,
          phonePeOrderId: orderId,
          state: state,
          expireAt: expireAt,
          createdAt: admin.firestore.Timestamp.now(),
        });

      // 7. Return the redirect URL to the client app
      return {
        redirectUrl: redirectUrl,
        merchantOrderId: merchantOrderId,
      };
    } catch (error: unknown) {
      console.error("Error initiating PhonePe payment:", error);
      // Handle Axios-specific errors for better client feedback
      if (isAxiosError(error) && error.response) {
        console.error("Axios Error Details:", error.response.data);
        throw new functions.https.HttpsError(
          "internal",
          `Payment gateway error: ${JSON.stringify(error.response.data)}`
        );
      }
      // Re-throw errors from helpers or throw a generic one
      throw error instanceof functions.https.HttpsError ?
        error :
        new functions.https.HttpsError(
          "internal",
          "An unexpected error occurred."
        );
    }
  }
);


/**
 * Checks the status of a specific payment transaction.
 * Called by the client app after being redirected back from PhonePe.
 */
export const checkPaymentStatus = functions.https.onCall(
  {
    secrets: [
      "PHONEPE_MERCHANT_ID",
      "PHONEPE_CLIENT_ID",
      "PHONEPE_CLIENT_SECRET",
    ],
  },
  async (request) => {
    // 1. Validate input and user authentication
    if (!request.data?.merchantOrderId) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The 'merchantOrderId' is required."
      );
    }
    if (!request.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "You must be logged in to check a payment."
      );
    }

    const {merchantOrderId} = request.data;
    const userId = request.auth.uid;

    try {
      // 2. Verify that the transaction exists and belongs to the user
      const transactionRef = admin.firestore()
        .collection("transactions")
        .doc(merchantOrderId);
      const transactionDoc = await transactionRef.get();

      if (!transactionDoc.exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "Transaction not found."
        );
      }
      if (transactionDoc.data()?.userId !== userId) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "You are not authorized to view this transaction."
        );
      }

      // 3. Get a new access token and check the status with PhonePe
      const accessToken = await getPhonePeAccessToken();
      const statusResponse = await checkPhonePeOrderStatus(
        merchantOrderId,
        accessToken
      );

      // Keep original status unless changed
      let finalStatus = transactionDoc.data()?.status;

      // 4. Update the transaction status in Firestore if it has changed
      if (statusResponse.state && statusResponse.state !== "PENDING") {
        finalStatus = statusResponse.state === "SUCCESS" ?
          "SUCCESS" :
          "FAILED";
        await transactionRef.update({
          status: finalStatus,
          finalState: statusResponse.state,
          latestStatusCheck: statusResponse,
          lastStatusCheckAt: admin.firestore
            .Timestamp.now(),
        });
      } else {
        // Just log the check without changing the primary status
        await transactionRef.update({
          latestStatusCheck: statusResponse,
          lastStatusCheckAt: admin.firestore
            .Timestamp.now(),
        });
      }

      // 5. Return the latest status to the client
      return {
        merchantOrderId: merchantOrderId,
        status: finalStatus,
        // e.g., "SUCCESS", "FAILED", "PENDING"
        phonePeDetails: statusResponse,
      };
    } catch (error: unknown) {
      console.error("Error checking payment status:", error);
      // Re-throw known errors or create a generic one
      throw error instanceof functions.https.HttpsError ?
        error :
        new functions.https.HttpsError(
          "internal",
          "Failed to check payment status."
        );
    }
  }
);
