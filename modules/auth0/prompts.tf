# Identifier-First
resource "auth0_prompt" "prompts" {
  identifier_first               = true
  universal_login_experience     = "new"
  webauthn_platform_first_factor = false
}
