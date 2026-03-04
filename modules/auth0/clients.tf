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
