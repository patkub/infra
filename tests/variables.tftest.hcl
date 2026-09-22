# Unit test input variables

mock_provider "auth0" {}
mock_provider "cloudflare" {}

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
