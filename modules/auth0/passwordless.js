/**
 * Force users to authenticate with PassKeys only.
 *
 * This action allows users to log in without a passkey for a limited number of times.
 * After exceeding this limit, users must authenticate using a passkey.
 */

/**
 * Check if a passkey was used to authenticate.
 *
 * @param {Event} event - Details about the user and the context in which they are logging in.
 * @returns {Boolean} True if a passkey was used, false otherwise.
 */
function loginUsedPasskey(event) {
  return (
    event.authentication?.methods.some((method) => method.name === "passkey") ||
    false
  );
}

/**
 * Get the maximum number of allowed logins without a passkey, ensuring at least 1.
 *
 * @param {Event} event - Details about the user and the context in which they are logging in.
 * @returns {Number} Maximum number of allowed logins without a passkey (min: 1).
 */
function getMaxLoginsWithoutPasskey(event) {
  return Math.max(1, parseInt(event.secrets.MAX_LOGINS_WITHOUT_PASSKEY, 10));
}

/**
 * Get the number of logins left before enforcing passkey policy.
 *
 * @param {Event} event - Details about the user and the context in which they are logging in.
 * @returns {Number} Number of logins left.
 */
function getLoginsLeft(event) {
  const maxLoginsWithoutPasskey = getMaxLoginsWithoutPasskey(event);
  return maxLoginsWithoutPasskey - event.stats.logins_count;
}

/**
 * Force users to authenticate with PassKeys only.
 *
 * Handler that will be called during the execution of a PostLogin flow.
 *
 * @param {Event} event - Details about the user and the context in which they are logging in.
 * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
 */
exports.onExecutePostLogin = async (event, api) => {
  // Continue login if a passkey was used to authenticate.
  const usedPassKey = loginUsedPasskey(event);
  if (usedPassKey) {
    return;
  }

  // Number of logins left before enforcing passkey policy.
  const logins_left = getLoginsLeft(event);

  if (logins_left >= 0) {
    // Still within grace period. Notify user about passkey policy.
    api.prompt.render(event.secrets.NOTIFY_FORM_ID, {
      vars: {
        logins_left: logins_left,
      },
    });
    return;
  }

  // Exceeded login grace period. Notify user that they must use a passkey.
  api.prompt.render(event.secrets.ENFORCE_FORM_ID);
};

/**
 * Deny login after notificaiton form if user didn't authenticate with a passkey
 *
 * Handler that will be invoked when this action is resuming after an external redirect. If your
 * onExecutePostLogin function does not perform a redirect, this function can be safely ignored.
 *
 * @param {Event} event - Details about the user and the context in which they are logging in.
 * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
 */
exports.onContinuePostLogin = async (event, api) => {
  // Continue login if a passkey was used to authenticate.
  const usedPassKey = loginUsedPasskey(event);
  if (usedPassKey) {
    return;
  }

  // Number of logins left before enforcing passkey policy.
  const logins_left = getLoginsLeft(event);

  // Skip passkey policy during grace period.
  if (logins_left >= 0) {
    return;
  }

  // Exceeded login grace period.
  // Reject the current transaction, revoke the session, and delete associated refresh tokens.
  api.session.revoke("Must login with PassKey", {
    preserveRefreshTokens: false,
  });
};
