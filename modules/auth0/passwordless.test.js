import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";

import { onExecutePostLogin, onContinuePostLogin } from "./passwordless.js";

describe("Passwordless", () => {
  let event, api;

  beforeEach(() => {
    // Mock Auth0 Event and API objects
    event = {
      authentication: {
        methods: [
          {
            name: "passkey",
          },
        ],
      },
      stats: {
        logins_count: 1,
      },
      secrets: {
        MAX_LOGINS_WITHOUT_PASSKEY: "3",
        NOTIFY_FORM_ID: "notify-form-id",
        ENFORCE_FORM_ID: "enforce-form-id",
      },
    };

    api = {
      prompt: {
        render: vi.fn(),
      },
      session: {
        revoke: vi.fn(),
      },
    };
  });

  afterEach(() => {
    vi.restoreAllMocks();
  });

  it("Should continue login if a PassKey was used", async () => {
    // Prepare
    event.stats.logins_count = 1;

    // Act
    await onExecutePostLogin(event, api);
    await onContinuePostLogin(event, api);

    // Assert
    // Did not notify the user.
    expect(api.prompt.render).not.toHaveBeenCalled();
    // Allowed the current transaction.
    expect(api.session.revoke).not.toHaveBeenCalled();
  });

  it("Should notify user about PassKey policy, but allow login without a PassKey during grace period", async () => {
    // Prepare
    event.stats.logins_count = 1;
    // No PassKey used
    event.authentication.methods = [];

    // Act
    await onExecutePostLogin(event, api);
    await onContinuePostLogin(event, api);

    // MAX_LOGINS_WITHOUT_PASSKEY is 3, logins_count is 1, so 2 logins left
    const logins_left = Math.max(
      1,
      parseInt(event.secrets.MAX_LOGINS_WITHOUT_PASSKEY, 10) -
        event.stats.logins_count,
    );

    // Assert
    // Notified user that they have 2 logins left without a passkey.
    expect(api.prompt.render).toHaveBeenCalledTimes(1);
    expect(api.prompt.render).toHaveBeenCalledWith(
      event.secrets.NOTIFY_FORM_ID,
      {
        vars: {
          logins_left: logins_left,
        },
      },
    );
    // Allowed the current transaction.
    expect(api.session.revoke).not.toHaveBeenCalled();
  });

  it("Should deny login without a PassKey after grace period", async () => {
    // Prepare
    event.stats.logins_count =
      parseInt(event.secrets.MAX_LOGINS_WITHOUT_PASSKEY, 10) + 1;
    // No PassKey used
    event.authentication.methods = [];

    // Act
    await onExecutePostLogin(event, api);
    await onContinuePostLogin(event, api);

    // Assert
    // Notified user that they are blocked from logging in without a passkey.
    expect(api.prompt.render).toHaveBeenCalledTimes(1);
    expect(api.prompt.render).toHaveBeenCalledWith(
      event.secrets.ENFORCE_FORM_ID,
    );
    // Rejected the current transaction, revoked the session, and deleted associated refresh tokens.
    expect(api.session.revoke).toHaveBeenCalledWith("Must login with PassKey", {
      preserveRefreshTokens: false,
    });
  });

  it("Should not deny login after grace period if a PassKey was used", async () => {
    // Prepare
    event.stats.logins_count =
      parseInt(event.secrets.MAX_LOGINS_WITHOUT_PASSKEY, 10) + 1;

    // Act
    await onExecutePostLogin(event, api);
    await onContinuePostLogin(event, api);

    // Assert
    // Did not notify the user.
    expect(api.prompt.render).not.toHaveBeenCalled();
    // Allowed the current transaction.
    expect(api.session.revoke).not.toHaveBeenCalled();
  });

  it("Should set minimum to 1 logins without passkey", async () => {
    // Prepare
    event.stats.logins_count = 1;
    event.secrets.MAX_LOGINS_WITHOUT_PASSKEY = "0";
    // No PassKey used
    event.authentication.methods = [];

    // Act
    await onExecutePostLogin(event, api);
    await onContinuePostLogin(event, api);

    // Assert
    // Notified user that they have 0 logins left without a passkey.
    expect(api.prompt.render).toHaveBeenCalledTimes(1);
    expect(api.prompt.render).toHaveBeenCalledWith(
      event.secrets.NOTIFY_FORM_ID,
      {
        vars: {
          logins_left: 0,
        },
      },
    );
    // Allowed the current transaction.
    expect(api.session.revoke).not.toHaveBeenCalled();
  });
});
