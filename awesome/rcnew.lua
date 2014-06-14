-- Awesome stdlib
local gears = require("gears")
local awful = require("awful")
local rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

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
editor = terminal .. "-e " .. os.getenv("editor") .. " "
browser = os.getenv("BROWSER")
modkey = "Mod4"

os.setlocale("en_US.UTF-8")

-- Notification preferences
naughty.config.defaults.position = "top_left"
naughty.config.defaults.screen = 1

-- Theme
beatiful.init(config .. "theme/solarized.lua")
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beatiful.wallpaper, s, true)
    end
end

layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair
}

tags = {}
tags[1] = awful.tag({ "1:FX", "2", "3", "4", "5", "6", "7", "8", "9" }, 1, layouts[1])
tags[2] = awful.tag({ "1:IRC", "2:Skype", "3", "4", "5", "6", "7", "8", "9" }, 2, layouts[1])

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
    { "Shutdown", "systemctl poweroff" },
    { "Reboot", "systemctl reboot" }
}

