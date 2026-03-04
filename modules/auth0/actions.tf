# Action to force users to authenticate with passkeys
resource "auth0_action" "passwordless" {
  code    = file("${path.module}/passwordless.js")
  deploy  = true
  name    = "Passwordless"
  runtime = "node22"
  supported_triggers {
    id      = "post-login"
    version = "v3"
  }

  secrets {
    # ID of the form to enforce passkey authentication after the grace period.
    name  = "ENFORCE_FORM_ID"
    value = auth0_form.must_login_with_passkeys.id
  }
  secrets {
    # ID of the form to notify users about the passkey policy during the grace period.
    name  = "NOTIFY_FORM_ID"
    value = auth0_form.notify_about_passkey_policy.id
  }
  secrets {
    # Maximum number of logins allowed without a passkey (min: "1").
    name  = "MAX_LOGINS_WITHOUT_PASSKEY"
    value = var.MAX_LOGINS_WITHOUT_PASSKEY
  }
}

# Post-Login Action Triggers
resource "auth0_trigger_actions" "login_flow" {
  trigger = "post-login"

  actions {
    id           = auth0_action.passwordless.id
    display_name = auth0_action.passwordless.name
  }
}
