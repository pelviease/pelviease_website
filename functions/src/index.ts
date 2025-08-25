import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import axios, {isAxiosError} from "axios";
import {v4 as uuidv4} from "uuid";
import {Timestamp} from "firebase-admin/firestore";

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

const functionConfig = functions.config();

// const APP_CONFIG = functionConfig.app || {};
// const PHONEPE_CONFIG = functionConfig.phonepe || {};
// const PHONEPE_HOST_URL = "https://api-preprod.phonepe.com/apis/pg-sandbox";
// const MERCHANT_ID = PHONEPE_CONFIG.merchant_id;
// const CLIENT_ID = PHONEPE_CONFIG.merchant_id;
// const CLIENT_SECRET = PHONEPE_CONFIG.salt_key;


// --- Phone Production Configuration ---
const PHONEPE_CONFIG_PROD = functionConfig.phonepe_prod || {};
const APP_CONFIG_PROD = functionConfig.app_prod || {};
const APP_PROD_REDIRECT_URL = APP_CONFIG_PROD.redirect_url || "https://pelviease.com/#/paymentStatus";
const PHONEPE_PROD_HOST_URL = "https://api.phonepe.com/apis/pg/";
const PHONEPE_PROD_AUTH_URL = "https://api.phonepe.com/apis/identity-manager/";

const MERCHANT_ID_PROD = PHONEPE_CONFIG_PROD.merchant_id;
const CLIENT_ID_PROD = PHONEPE_CONFIG_PROD.merchant_id;
const CLIENT_SECRET_PROD = PHONEPE_CONFIG_PROD.salt_key;
const SALT_INDEX_PROD = PHONEPE_CONFIG_PROD.salt_index || 1;
console.log("PhonePe - MERCHANT_ID_PROD:", MERCHANT_ID_PROD);
console.log("PhonePe - CLIENT_ID_PROD:", CLIENT_ID_PROD);
console.log("PhonePe - CLIENT_SECRET_PROD:", CLIENT_SECRET_PROD);
console.log("PhonePe - SALT_INDEX_PROD:", SALT_INDEX_PROD);

// Use environment variable for flexibility between dev/prod
const APP_REDIRECT_URL = APP_PROD_REDIRECT_URL;

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
    if (!CLIENT_ID_PROD || !CLIENT_SECRET_PROD) {
      throw new Error("CLIENT_ID and CLIENT_SECRET are required.");
    }

    const requestHeaders = {
      "Content-Type": "application/x-www-form-urlencoded",
    };

    const requestBody = new URLSearchParams({
      "client_id": CLIENT_ID_PROD,
      "client_secret": CLIENT_SECRET_PROD,
      "client_version": "1",
      "grant_type": "client_credentials",
    }).toString();

    const options = {
      method: "POST",
      url: `${PHONEPE_PROD_AUTH_URL}/v1/oauth/token`,
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

    console.log("Checking payment status for:", merchantOrderId);


    const options = {
      method: "GET",
      url: `${PHONEPE_PROD_HOST_URL}/checkout/v2/order/` +
        `${merchantOrderId}/status`,
      headers: requestHeaders,
    };

    console.log("Request options for checking payment status:",
      JSON.stringify(options, null, 2));

    const response = await axios.request(options);

    console.log("Full response from PhonePe:", JSON.stringify({
      status: response.status,
      statusText: response.statusText,
      data: response.data,
    }, null, 2));

    return response.data;
  } catch (error) {
    console.error(`Error checking status for ${merchantOrderId}:`, error);
    if (isAxiosError(error) && error.response) {
      console.error("Axios error response:", JSON.stringify({
        status: error.response.status,
        statusText: error.response.statusText,
        data: error.response.data,
      }, null, 2));
    }

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
  async (request) => {
    // 1. Validate input and user authentication
    if (!MERCHANT_ID_PROD || !CLIENT_ID_PROD || !CLIENT_SECRET_PROD) {
      console.error("Missing PhonePe configuration:", {
        MERCHANT_ID_PROD: !!MERCHANT_ID_PROD,
        CLIENT_ID_PROD: !!CLIENT_ID_PROD,
        CLIENT_SECRET_PROD: !!CLIENT_SECRET_PROD,
      });
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

    const amount = Math.round(request.data.amount);
    const userId = request.auth.uid;
    const merchantOrderId = `ORDER-${uuidv4()}`;

    try {
      // 2. Get PhonePe Access Token
      const accessToken = await getPhonePeAccessToken();

      // 3. Prepare the payment payload
      const paymentData = {
        merchantOrderId: merchantOrderId,

        amount: amount,
        expireAfter: 300, // 5 min
        metaInfo: {
          udf1: userId,
          udf2: "Pelviease",
        },
        paymentFlow: {
          type: "PG_CHECKOUT",
          message: "Payment for your service or product",
          merchantUrls: {
            // Redirect to payment status screen with merchantOrderId
            // Format: https://pelviease.com/#/paymentStatus/{merchantOrderId}
            redirectUrl: `${APP_REDIRECT_URL}/${merchantOrderId}`,
          },
        },
      };

      // 4. Make the request to PhonePe to create the payment
      const options = {
        method: "POST",
        url: `${PHONEPE_PROD_HOST_URL}/checkout/v2/pay`,
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
          createdAt: Timestamp.now(),

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
  async (request) => {
    console.log("=== checkPaymentStatus function called ===");
    console.log("Request data:", JSON.stringify(request.data, null, 2));
    // console.log("Request auth:", request.auth ?
    //   {uid: request.auth.uid} : "No auth");

    // 1. Validate input and user authentication
    if (!request.data?.merchantOrderId) {
      console.error("Missing merchantOrderId in request");
      throw new functions.https.HttpsError(
        "invalid-argument",
        "The 'merchantOrderId' is required."
      );
    }
    if (!request.auth) {
      console.error("No authentication provided");
      throw new functions.https.HttpsError(
        "unauthenticated",
        "You must be logged in to check a payment."
      );
    }

    const {merchantOrderId} = request.data;
    const userId = request.auth.uid;

    console.log(`Processing payment status check for merchantOrderId: ${
      merchantOrderId}, userId: ${userId}`);

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

      console.log("Payment Status Response:",
        JSON.stringify(statusResponse, null, 2));

      // Keep original status unless changed
      let finalStatus = transactionDoc.data()?.status;

      // 4. Update the transaction status in Firestore if it has changed
      // Check for various success states that PhonePe might return
      const successStates = ["SUCCESS", "COMPLETED", "PAID"];
      const failureStates = ["FAILED", "CANCELLED", "EXPIRED", "TIMEOUT"];

      if (statusResponse.state) {
        console.log(`Current state from PhonePe: ${statusResponse.state}`);

        if (successStates.includes(
          statusResponse.state.toUpperCase())) {
          finalStatus = "SUCCESS";
          console.log("Payment marked as SUCCESS");
        } else if (failureStates.includes(
          statusResponse.state.toUpperCase())) {
          finalStatus = "FAILED";
          console.log("Payment marked as FAILED");
        } else if (statusResponse.state.toUpperCase() === "PENDING") {
          finalStatus = "PENDING";
          console.log("Payment still PENDING");
        } else {
          console.log(`Unknown payment state: ${statusResponse.state}`);
        }

        // Update Firestore with the latest status
        await transactionRef.update({
          status: finalStatus,
          finalState: statusResponse.state,
          latestStatusCheck: statusResponse,
          lastStatusCheckAt: admin.firestore.Timestamp.now(),
        });
      } else {
        console.log("No state returned from PhonePe API");
        // Just log the check without changing the primary status
        await transactionRef.update({
          latestStatusCheck: statusResponse,
          lastStatusCheckAt: admin.firestore.Timestamp.now(),
        });
      }

      // 5. Return the latest status to the client
      const result = {
        merchantOrderId: merchantOrderId,
        status: finalStatus,
        // e.g., "SUCCESS", "FAILED", "PENDING"
        phonePeDetails: statusResponse,
      };

      console.log("=== Returning result ===");
      console.log("Result:", JSON.stringify(result, null, 2));

      return result;
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
