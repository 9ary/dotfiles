awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },

    { rule = { instance = "plugin-container" },
      properties = { floating = true } },

    { rule = { class = "mupen64plus" },
      properties = { floating = true,
                     border_width = 0 } },

    { rule = { class = "Gcr-prompter" },
      properties = { floating = true,
                     border_width = 0 } },

    { rule = { class = "Wine" },
      properties = { floating = true } },

    { rule = { class = "mpv" },
      properties = { floating = true,
                     tag = tags[1][1] } },

    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1] } },

    { rule = { name = "WeeChat" },
      properties = { tag = tags[2][1] } },

    { rule = { class = "Skype" },
      properties = { tag = tags[2][2] } },

    { rule = { class = "Mumble" },
      properties = { tag = tags[2][3] } },
}

