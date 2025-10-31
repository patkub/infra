import { describe, it, expect, beforeEach, afterEach, vi } from "vitest";

import { onExecutePostLogin, onContinuePostLogin } from "../passwordless.js";

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
			access: {
				deny: vi.fn(),
			},
			prompt: {
				render: vi.fn(),
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
		expect(api.prompt.render).not.toHaveBeenCalled();
		expect(api.access.deny).not.toHaveBeenCalled();
	});

	it("Should notify user about PassKey policy, but allow login without PassKey during grace period", async () => {
		// Prepare
		event.stats.logins_count = 1;
		// No PassKey used
		event.authentication.methods = [];

		// Act
		await onExecutePostLogin(event, api);
		await onContinuePostLogin(event, api);

		// MAX_LOGINS_WITHOUT_PASSKEY is 3, logins_count is 1, so 2 logins left
		const logins_left = Math.max(
			-1,
			parseInt(event.secrets.MAX_LOGINS_WITHOUT_PASSKEY, 10) -
				event.stats.logins_count,
		);

		// Assert
		expect(api.prompt.render).toHaveBeenCalledWith(
			event.secrets.NOTIFY_FORM_ID,
			{
				vars: {
					logins_left: logins_left,
				},
			},
		);
		expect(api.access.deny).not.toHaveBeenCalled();
	});

	it("Should deny login without PassKey after grace period", async () => {
		// Prepare
		event.stats.logins_count =
			parseInt(event.secrets.MAX_LOGINS_WITHOUT_PASSKEY, 10) + 1;
		// No PassKey used
		event.authentication.methods = [];

		// Act
		await onExecutePostLogin(event, api);
		await onContinuePostLogin(event, api);

		// MAX_LOGINS_WITHOUT_PASSKEY is 3, logins_count is 4, so 0 logins left
		const logins_left = Math.max(
			-1,
			parseInt(event.secrets.MAX_LOGINS_WITHOUT_PASSKEY, 10) -
				event.stats.logins_count,
		);

		// Assert
		expect(api.prompt.render).not.toHaveBeenCalledWith(
			event.secrets.NOTIFY_FORM_ID,
			{
				vars: {
					logins_left: logins_left,
				},
			},
		);
		expect(api.prompt.render).toHaveBeenCalledWith(
			event.secrets.ENFORCE_FORM_ID,
		);
		expect(api.access.deny).toHaveBeenCalled();
	});

	it("Should not deny login after grace period if a PassKey was used", async () => {
		// Prepare
		event.stats.logins_count =
			parseInt(event.secrets.MAX_LOGINS_WITHOUT_PASSKEY, 10) + 1;

		// Act
		await onExecutePostLogin(event, api);
		await onContinuePostLogin(event, api);

		// Assert
		expect(api.prompt.render).not.toHaveBeenCalledWith(
			event.secrets.NOTIFY_FORM_ID,
			{
				vars: {
					logins_left: 0,
				},
			},
		);
		expect(api.prompt.render).not.toHaveBeenCalledWith(
			event.secrets.ENFORCE_FORM_ID,
		);
		expect(api.access.deny).not.toHaveBeenCalled();
	});
});
