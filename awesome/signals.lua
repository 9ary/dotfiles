client.connect_signal("manage", function (c, startup)
    if not startup then
        -- Set the windows at the slave, unless specified otherwise
        if not(c.class == "Pluma" or c.class == "Gvim") then
            awful.client.setslave(c)
        end

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end

        -- Center some windows
        if c.class == "mupen64plus" then
            awful.placement.centered(c, c.transient_for)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

