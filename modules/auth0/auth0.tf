# Required Providers
terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1"
    }
  }
}

# Auth0 OIDC Client for Cloudflare Access OIDC Provider
resource "auth0_client" "cloudflare_access" {
  allowed_clients                                      = []
  allowed_logout_urls                                  = []
  allowed_origins                                      = []
  app_type                                             = "regular_web"
  callbacks                                            = ["https://epicpatka.cloudflareaccess.com/cdn-cgi/access/callback"]
  client_aliases                                       = []
  client_metadata                                      = {}
  cross_origin_auth                                    = false
  grant_types                                          = ["authorization_code", "refresh_token"]
  is_first_party                                       = true
  is_token_endpoint_ip_header_trusted                  = false
  name                                                 = "Cloudflare Access"
  oidc_conformant                                      = true
  organization_usage                                   = "deny"
  require_proof_of_possession                          = false
  require_pushed_authorization_requests                = false
  skip_non_verifiable_callback_uri_confirmation_prompt = false
  sso                                                  = true
  sso_disabled                                         = false
  web_origins                                          = []
  default_organization {
    disable = true
    flows   = []
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
    expiration_type              = "expiring"
    idle_token_lifetime          = 2592000
    infinite_idle_token_lifetime = false
    infinite_token_lifetime      = false
    leeway                       = 0
    rotation_type                = "rotating"
    token_lifetime               = 31557600
  }
}


# Identifier-First
resource "auth0_prompt" "prompts" {
  identifier_first               = true
  universal_login_experience     = "new"
  webauthn_platform_first_factor = false
}

# Form to enforce passkey login policy
resource "auth0_form" "must_login_with_passkeys" {
  name = "Must Login with passkeys"
  start = jsonencode({
    coordinates = {
      x = 0
      y = 0
    }
    next_node = "step_3q2e"
  })
  nodes = jsonencode(
    [
      {
        "alias" : "New step",
        "config" : {
          "components" : [
            {
              "category" : "BLOCK",
              "config" : {
                "content" : "<h2 style=\"text-align:center;\"><strong>{{ t('must_use_passkeys') }}</strong></h2>"
              },
              "id" : "rich_text_lGGp",
              "type" : "RICH_TEXT"
            },
            {
              "category" : "BLOCK",
              "config" : {
                "text" : "Continue"
              },
              "id" : "next_button_EeLt",
              "type" : "NEXT_BUTTON"
            },
            {
              "category" : "BLOCK",
              "id" : "divider_xFa3",
              "type" : "DIVIDER"
            }
          ],
          "next_node" : "$ending"
        },
        "coordinates" : {
          "x" : 500,
          "y" : 0
        },
        "id" : "step_3q2e",
        "type" : "STEP"
      }
    ]
  )
  ending = jsonencode({
    coordinates = {
      x = 1250
      y = 0
    }
    resume_flow = true
  })
  languages {
    default = "en"
    primary = "en"
  }
  messages {
    custom = jsonencode({
      must_use_passkeys = "Please login with a passkey"
    })
  }
}

# Form to notify about passkey login policy
resource "auth0_form" "notify_about_passkey_policy" {
  name = "Notify about passkey Policy"
  nodes = jsonencode([
    {
      "alias" : "New step",
      "config" : {
        "components" : [
          {
            "category" : "BLOCK",
            "config" : {
              "content" : "\u003ch2 style=\"text-align:center;\"\u003e\u003cstrong\u003e{{ t('must_use_passkeys') }}\u003c/strong\u003e\u003c/h2\u003e\u003ch2 style=\"text-align:center;\"\u003e\u003cstrong\u003e{{ t('logins_left1') }} {{vars.logins_left}}  {{ t('logins_left2')}}\u003c/strong\u003e\u003c/h2\u003e"
            },
            "id" : "rich_text_lGGp",
            "type" : "RICH_TEXT"
          },
          {
            "category" : "BLOCK",
            "config" : {
              "text" : "Continue"
            },
            "id" : "next_button_EeLt",
            "type" : "NEXT_BUTTON"
          },
          {
            "category" : "BLOCK",
            "id" : "divider_xFa3",
            "type" : "DIVIDER"
          }
        ],
        "next_node" : "$ending"
      },
      "coordinates" : {
        "x" : 500,
        "y" : 0
      },
      "id" : "step_3q2e",
      "type" : "STEP"
    }
  ])
  start = jsonencode({
    coordinates = {
      x = 0
      y = 0
    }
    next_node = "step_3q2e"
  })
  ending = jsonencode({
    coordinates = {
      x = 1250
      y = 0
    }
    resume_flow = true
  })
  languages {
    default = "en"
    primary = "en"
  }
  messages {
    custom = jsonencode({
      "logins_left1" : "You have ",
      "logins_left2" : " logins left without passkeys",
      "must_use_passkeys" : "Please enroll a passkey"
    })
  }
}

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
