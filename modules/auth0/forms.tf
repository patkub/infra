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
  start = jsonencode({
    coordinates = {
      x = 0
      y = 0
    }
    next_node = "step_3q2e"
  })
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
