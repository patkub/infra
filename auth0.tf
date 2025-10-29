
# Auth0 OIDC Client for Cloudflare Access Integration
resource "auth0_client" "cloudflare_access" {
  allowed_clients                                      = []
  allowed_logout_urls                                  = []
  allowed_origins                                      = []
  app_type                                             = "regular_web"
  callbacks                                            = ["https://epicpatka.cloudflareaccess.com/cdn-cgi/access/callback"]
  client_aliases                                       = []
  client_metadata                                      = {}
  compliance_level                                     = null
  cross_origin_auth                                    = false
  cross_origin_loc                                     = null
  custom_login_page                                    = null
  custom_login_page_on                                 = true
  description                                          = null
  encryption_key                                       = null
  form_template                                        = null
  grant_types                                          = ["authorization_code", "implicit", "refresh_token", "client_credentials"]
  initiate_login_uri                                   = null
  is_first_party                                       = true
  is_token_endpoint_ip_header_trusted                  = false
  logo_uri                                             = null
  name                                                 = "Cloudflare Access"
  oidc_conformant                                      = true
  organization_require_behavior                        = null
  organization_usage                                   = null
  require_proof_of_possession                          = false
  require_pushed_authorization_requests                = false
  resource_server_identifier                           = null
  skip_non_verifiable_callback_uri_confirmation_prompt = false
  sso                                                  = false
  sso_disabled                                         = false
  web_origins                                          = []
  default_organization {
    disable         = true
    flows           = []
    organization_id = null
  }
  jwt_configuration {
    alg                 = "RS256"
    lifetime_in_seconds = 36000
    scopes              = {}
    secret_encoded      = false
  }
  native_social_login {
    apple {
      enabled = false
    }
    facebook {
      enabled = false
    }
    google {
      enabled = false
    }
  }
  refresh_token {
    expiration_type              = "non-expiring"
    idle_token_lifetime          = 2592000
    infinite_idle_token_lifetime = true
    infinite_token_lifetime      = true
    leeway                       = 0
    rotation_type                = "non-rotating"
    token_lifetime               = 31557600
  }
}


# Identifier-First
resource "auth0_prompt" "prompts" {
  identifier_first               = true
  universal_login_experience     = "new"
  webauthn_platform_first_factor = false
}

# Form to enforce PassKey login policy
resource "auth0_form" "must_login_with_passkeys" {
  ending       = "{\"coordinates\":{\"x\":1250,\"y\":0},\"resume_flow\":true}"
  name         = "Must Login with PassKeys"
  nodes        = "[{\"alias\":\"New step\",\"config\":{\"components\":[{\"category\":\"BLOCK\",\"config\":{\"content\":\"\\u003ch2 style=\\\"text-align:center;\\\"\\u003e\\u003cstrong\\u003e{{ t('must_use_passkeys') }}\\u003c/strong\\u003e\\u003c/h2\\u003e\"},\"id\":\"rich_text_lGGp\",\"type\":\"RICH_TEXT\"},{\"category\":\"BLOCK\",\"config\":{\"text\":\"Continue\"},\"id\":\"next_button_EeLt\",\"type\":\"NEXT_BUTTON\"},{\"category\":\"BLOCK\",\"id\":\"divider_xFa3\",\"type\":\"DIVIDER\"}],\"next_node\":\"$ending\"},\"coordinates\":{\"x\":500,\"y\":0},\"id\":\"step_3q2e\",\"type\":\"STEP\"}]"
  start        = "{\"coordinates\":{\"x\":0,\"y\":0},\"next_node\":\"step_3q2e\"}"
  style        = null
  translations = null
  languages {
    default = null
    primary = "en"
  }
  messages {
    custom = "{\"must_use_passkeys\":\"Please login with PassKeys\"}"
    errors = null
  }
}

# Form to notify about PassKey login policy
resource "auth0_form" "notify_about_passkey_policy" {
  ending       = "{\"coordinates\":{\"x\":1250,\"y\":0},\"resume_flow\":true}"
  name         = "Notify about PassKey Policy"
  nodes        = "[{\"alias\":\"New step\",\"config\":{\"components\":[{\"category\":\"BLOCK\",\"config\":{\"content\":\"\\u003ch2 style=\\\"text-align:center;\\\"\\u003e\\u003cstrong\\u003e{{ t('must_use_passkeys') }}\\u003c/strong\\u003e\\u003c/h2\\u003e\\u003ch2 style=\\\"text-align:center;\\\"\\u003e\\u003cstrong\\u003e{{ t('logins_left1') }} {{vars.logins_left}}  {{ t('logins_left2')}}\\u003c/strong\\u003e\\u003c/h2\\u003e\"},\"id\":\"rich_text_lGGp\",\"type\":\"RICH_TEXT\"},{\"category\":\"BLOCK\",\"config\":{\"text\":\"Continue\"},\"id\":\"next_button_EeLt\",\"type\":\"NEXT_BUTTON\"},{\"category\":\"BLOCK\",\"id\":\"divider_xFa3\",\"type\":\"DIVIDER\"}],\"next_node\":\"$ending\"},\"coordinates\":{\"x\":500,\"y\":0},\"id\":\"step_3q2e\",\"type\":\"STEP\"}]"
  start        = "{\"coordinates\":{\"x\":0,\"y\":0},\"next_node\":\"step_3q2e\"}"
  style        = null
  translations = null
  languages {
    default = null
    primary = "en"
  }
  messages {
    custom = "{\"logins_left1\":\"You have \",\"logins_left2\":\" logins left without PassKeys\",\"must_use_passkeys\":\"Please enroll a PassKey\"}"
    errors = null
  }
}

# Action to force users to authenticate with PassKeys "0c6cc5ae-5fcb-4f26-9a24-c78cbb71bcb8"
resource "auth0_action" "passwordless" {
  code    = file("${path.module}/passwordless.js")
  deploy  = true
  name    = "Passwordless"
  runtime = "node22"
  supported_triggers {
    id      = "post-login"
    version = "v3"
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