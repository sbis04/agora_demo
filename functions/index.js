const functions = require("firebase-functions");
const dotenv = require("dotenv");
const {
  RtcTokenBuilder,
  RtcRole,
} = require("agora-token");

dotenv.config();

exports.generateToken = functions.https.onCall(async (data, context) => {
  // Rtc Examples
  const appId = process.env.APP_ID;
  const appCertificate = process.env.APP_CERTIFICATE;
  const channelName = data.channelName;
  const uid = 0;
  const role = RtcRole.PUBLISHER;

  const expirationTimeInSeconds = 3600; // 1 hour

  const currentTimestamp = Math.floor(Date.now() / 1000);

  const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

  // Build token with uid
  try {
    const token = RtcTokenBuilder.buildTokenWithUid(
        appId,
        appCertificate,
        channelName,
        uid,
        role,
        privilegeExpiredTs,
    );
    return token;
  } catch (err) {
    console.error(
        `Unable to generate token ${context.auth.uid}. 
        Error ${err}`,
    );
    throw new functions.https.HttpsError(
        "aborted",
        "Could not generate token",
    );
  }
});
