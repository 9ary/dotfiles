-- Awesome stdlib
gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
vicious = require("vicious")
wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")

-- Error handler, because who doesn't have one ?
-- Note : handles only runtime errors
-- Startup errors are handled by the default rc.lua
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then
            return
        end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical, title = "Error", text = err })
        in_error = false
    end)
end

-- Constants
home = os.getenv("HOME") .. "/"
conf = home .. ".config/awesome/"
terminal = os.getenv("TERMINAL") .. " "
file_manager = terminal .. "-e ranger"
editor = terminal .. "-e " .. os.getenv("EDITOR") .. " "
browser = os.getenv("BROWSER")
modkey = "Mod4"

os.setlocale("en_US.UTF-8")

-- Notification preferences
naughty.config.defaults.position = "bottom_right"
naughty.config.defaults.screen = 1

-- Theme
beautiful.init(conf .. "theme/solarized.lua")
for s = 1, screen.count() do
    gears.wallpaper.maximized(conf .. "theme/wallpaper" .. s .. ".png", s, true)
end

layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair
}

tags = {}
tags[1] = awful.tag({ "1:FX", "2", "3", "4", "5", "6", "7", "8", "9" }, 1, layouts[1])
tags[2] = awful.tag({ "1:IRC", "2:Skype", "3:Torrent", "4", "5", "6", "7", "8", "9" }, 2, layouts[1])
awful.tag.setmwfact(0.2, tags[2][2])

menu_awesome =
{
    { "Manual", terminal .. "-e man awesome" },
    { "Configuration", terminal .. "--chdir " .. conf },
    { "Restart", awesome.restart }
}

menu_main = awful.menu({ items =
{
    { "Awesome", menu_awesome, beautiful.icon_awesome },
    { "Logout", awesome.quit },
    { "Suspend", "systemctl suspend" },
    { "Hibernate", "systemctl hibernate" },
    { "Hybrid sleep", "systemctl hybrid-sleep" },
    { "Shutdown", "systemctl poweroff" },
    { "Reboot", "systemctl reboot" }
}})

-- Make a taskbar wibox
taskbar = {}
taskbar_layout_icon = {}
taskbar_list_tags = {}
taskbar_list_windows = {}
taskbar_systray = wibox.widget.systray()
taskbar_clock = awful.widget.textclock(" %a %d %b %H:%M ", 10)

for s = 1, screen.count() do
    taskbar_layout_icon[s] = awful.widget.layoutbox(s)
    taskbar_list_tags[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all)
    taskbar_list_windows[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags)

    local widgets_left = wibox.layout.fixed.horizontal()
        widgets_left:add(taskbar_layout_icon[s])
        widgets_left:add(taskbar_list_tags[s])

    local widgets_right = wibox.layout.fixed.horizontal()
        if s == 1 then
            widgets_right:add(taskbar_systray)
        end
        widgets_right:add(taskbar_clock)

    local widgets_all = wibox.layout.align.horizontal()
        widgets_all:set_left(widgets_left)
        widgets_all:set_middle(taskbar_list_windows[s])
        widgets_all:set_right(widgets_right)

    taskbar[s] = awful.wibox({ position = "bottom", screen = s })
    taskbar[s]:set_widget(widgets_all)
end

-- Statusbar
statusbar = awful.wibox({ position = "top", screen = 1})

statusbar_mpd = wibox.widget.textbox()
vicious.register(statusbar_mpd, vicious.widgets.mpd,
    function (widget, args)
        if args["{state}"] == "Stop" then
            return " ⬛ "
        else
            local icon
            if args["{state}"] == "Play" then
                icon = " ▶ "
            else
                icon = " ❙❙ "
            end
            return icon .. args["{Artist}"] .. " - " .. args["{Title}"] .. " (" .. args["{Album}"] .. ")"
        end
    end, 5)

statusbar_cpu = wibox.widget.textbox()
vicious.register(statusbar_cpu, vicious.widgets.cpu, "CPU:$1% - ")

statusbar_mem = wibox.widget.textbox()
vicious.register(statusbar_mem, vicious.widgets.mem, "MEM:$1% ($2MB/$3MB) ")

statusbar_widgets_left = wibox.layout.fixed.horizontal()
    statusbar_widgets_left:add(statusbar_mpd)

statusbar_widgets_right = wibox.layout.fixed.horizontal()
    statusbar_widgets_right:add(statusbar_cpu)
    statusbar_widgets_right:add(statusbar_mem)

statusbar_all = wibox.layout.align.horizontal()
    statusbar_all:set_left(statusbar_widgets_left)
    statusbar_all:set_right(statusbar_widgets_right)

statusbar:set_widget(statusbar_all)

-- Keybindings
globalkeys = awful.util.table.join(

    awful.key({ modkey,           }, "p",      awful.tag.viewprev       ),
    awful.key({ modkey,           }, "n",      awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "h",
        function ()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "l",
        function ()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.global_bydirection("down") end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.global_bydirection("up") end),
    awful.key({ modkey, "Shift"   }, "h", function () awful.client.swap.global_bydirection("left") end),
    awful.key({ modkey, "Shift"   }, "l", function () awful.client.swap.global_bydirection("right") end),
    awful.key({ modkey, "Shift"   }, "n", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Shift"   }, "p", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "o", awful.client.movetoscreen),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Shortcuts
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(file_manager) end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({                   }, "Print",  function () awful.util.spawn("scrush") end),
    awful.key({ modkey, "Shift"   }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "w", function () menu_main:show() end),

    -- dmenu
    awful.key({ modkey,           }, "r", function () awful.util.spawn("dmenu_run -fn 'dejavu sans mono -9' -h 22 -p '>' -b -f -i -nb '#002B36' -nf '#93A1A1' -sb '#93A1A1' -sf '#002B36'") end),

    -- mpd
    awful.key({                   }, "XF86AudioPlay", function () awful.util.spawn("mpc toggle") end),
    awful.key({                   }, "XF86AudioStop", function () awful.util.spawn("mpc stop") end),
    awful.key({                   }, "XF86AudioNext", function () awful.util.spawn("mpc next") end),
    awful.key({                   }, "XF86AudioPrev", function () awful.util.spawn("mpc prev") end),
    awful.key({                   }, "XF86AudioRaiseVolume", function () awful.util.spawn("pa-adjust plus") end),
    awful.key({                   }, "XF86AudioLowerVolume", function () awful.util.spawn("pa-adjust minus") end),
    awful.key({                   }, "XF86AudioMute", function () awful.util.spawn("pa-adjust mute") end),
    awful.key({                   }, "XF86Tools", function () awful.util.spawn("urxvt -e pms") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "q", function (c) c:kill() end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle)
)

-- Bind all key numbers to tags (with key codes)
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
            function ()
                local screen = mouse.screen
                local tag = awful.tag.gettags(screen)[i]
                if tag then
                    awful.tag.viewonly(tag)
                end
            end),
       awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = awful.tag.gettags(client.focus.screen)[i]
                        if tag then
                            awful.client.movetotag(tag)
                        end
                   end
            end))
end

-- Mouse for floating windows
clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

-- Rules
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
      properties = { floating = true } },

    { rule = { class = "Wine" },
      properties = { floating = true } },

    { rule = { name = "nspire_emu" },
      properties = { floating = false } },

    { rule = { class = "mpv" },
      properties = { floating = true } },

    { rule = { class = "Firefox" },
      properties = { tag = tags[1][1] } },

    { rule = { name = "WeeChat" },
      properties = { tag = tags[2][1] } },

    { rule = { class = "Skype" },
      properties = { tag = tags[2][2],
                     size_hints_honor = false} },

    { rule = { name = "Transmission" },
      properties = { tag = tags[2][3] } },

    { rule = { class = "URxvt" },
      properties = { size_hints_honor = false } },
}

-- Signals
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
        if c.class == "mupen64plus" or c.class == "Gcr-prompter" or c.class == "mpv" then
            awful.placement.centered(c, c.transient_for)
        end
    end

    -- Titlebars
    local titlebars = true
    if titlebars == true and (c.type == "normal" or c.type == "dialog") then
        local buttons = awful.util.table.join(
            awful.button({ }, 1, function()
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
            end),
            awful.button({ }, 3, function()
                client.focus = c
                c:raise()
                awful.mouse.client.resize(c)
            end)
        )
        local title = awful.titlebar.widget.titlewidget(c)
            title:set_align("center")

        local widgets_left = wibox.layout.fixed.horizontal()
            widgets_left:add(awful.titlebar.widget.iconwidget(c))
            widgets_left:buttons(buttons)

        local widgets_middle = wibox.layout.flex.horizontal()
            widgets_middle:add(title)
            widgets_middle:buttons(buttons)

        local widgets_all = wibox.layout.align.horizontal()
            widgets_all:set_left(widgets_left)
            widgets_all:set_middle(widgets_middle)

        awful.titlebar(c):set_widget(widgets_all)
    end
end)

client.connect_signal("focus", function (c)
    awful.screen.focus(c.screen)
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

