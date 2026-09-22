# Unit test input variables

mock_provider "auth0" {}
mock_provider "cloudflare" {}

# Mock variables
variables {
  # Cloudflare Account Email
  cf_email                            = ""
  # Cloudflare Global API Key ( https://dash.cloudflare.com/profile/api-tokens )
  cf_api_key                          = "0000000000000000000000000000000000000"
  # Cloudflare Domain Overview Account ID
  cf_account_id                       = ""
  # Cloudflare Domain Overview API Zone ID
  cf_zone_id                          = ""
  # Cloudflare Access Team Name
  cf_access_team                      = ""

  # Auth0 M2M Application Details
  AUTH0_DOMAIN                        = "a"
  AUTH0_CLIENT_ID                     = "a"
  AUTH0_CLIENT_SECRET                 = "a"

  # Passkey Policy Settings
  # Number of logins without a passkey (min: "1")
  MAX_LOGINS_WITHOUT_PASSKEY          = "3"
}

# Positive Test: Ensure a valid input passes without errors
run "valid_MAX_LOGINS_WITHOUT_PASSKEY" {
  command = plan

  variables {
    MAX_LOGINS_WITHOUT_PASSKEY = "3"
  }
}

# Negative Test: Ensure zero is rejected
run "reject_0_MAX_LOGINS_WITHOUT_PASSKEY" {
  command = plan

  variables {
    MAX_LOGINS_WITHOUT_PASSKEY = "0"
  }

  # Tell Terraform this run MUST fail specifically because of this variable
  expect_failures = [
    var.MAX_LOGINS_WITHOUT_PASSKEY
  ]
}

# Negative Test: Ensure negative values are rejected
run "reject_negative_MAX_LOGINS_WITHOUT_PASSKEY" {
  command = plan

  variables {
    MAX_LOGINS_WITHOUT_PASSKEY = "-1"
  }

  expect_failures = [
    var.MAX_LOGINS_WITHOUT_PASSKEY
  ]
}
