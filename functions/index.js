const functions = require("firebase-functions");
const dotenv = require("dotenv");
const {
  RtcTokenBuilder,
  RtcRole,
} = require("agora-token");

dotenv.config();

exports.generateToken = functions.https.onCall(async (data, context) => {
  const appId = process.env.APP_ID;
  const appCertificate = process.env.APP_CERTIFICATE;
  const channelName = data.channelName;
  const uid = data.uid || 0;
  const role = RtcRole.PUBLISHER;

  const expirationTimeInSeconds = data.expiryTime;
  const currentTimestamp = Math.floor(Date.now() / 1000);
  const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

  if (channelName === undefined || channelName === null) {
    throw new functions.https.HttpsError(
        "aborted",
        "Channel name is required",
    );
  }

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
    throw new functions.https.HttpsError(
        "aborted",
        "Could not generate token",
    );
  }
});
