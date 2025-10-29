// Check if a passkey was used to authenticate.
function loginUsedPasskey(event) {
  return event.authentication?.methods.some(
    (method) => method.name === "passkey"
  );
}

/**
 * Force users to authenticate with PassKeys only
 * 
 * Handler that will be called during the execution of a PostLogin flow.
 *
 * @param {Event} event - Details about the user and the context in which they are logging in.
 * @param {PostLoginAPI} api - Interface whose methods can be used to change the behavior of the login.
 */
exports.onExecutePostLogin = async (event, api) => {
  // Check if a passkey was used to authenticate.
  const usedPassKey = loginUsedPasskey(event);

  // Continue login if a passkey was used.
  if (usedPassKey) {
    return;
  }

  // Number of logins left before enforcing passkey policy.
  // event.stats.logins_count starts at 1 for the first login
  const logins_left = Math.max(-1, (parseInt(event.secrets.MAX_LOGINS_WITHOUT_PASSKEY) - event.stats.logins_count));

  // Notify user about passkey policy, but allow login during grace period.
  if (logins_left >= 0) {
    api.prompt.render(event.secrets.NOTIFY_FORM_ID, {
      vars: {
        logins_left: logins_left,
      }
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
  // Skip passkey policy during grace period.
  if (event.stats.logins_count <= parseInt(event.secrets.MAX_LOGINS_WITHOUT_PASSKEY)) {
    return;
  }

  // Check if a passkey was used to authenticate.
  const usedPassKey = loginUsedPasskey(event);

  // Deny login if a passkey was not used.
  if (!usedPassKey) {
    api.access.deny('Must login with PassKey');
    return;
  }
};