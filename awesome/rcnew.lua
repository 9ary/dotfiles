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
}})

-- Make a taskbar wibox
taskbar = {}
taskbar_layout_icon = {}
taskbar_list_tags = {}
taskbar_list_windows = {}
taskbar_systray = wibox.widget.systray()
taskbar_clock = awful.widget.textclock("%a %d %b %H:%M", 10)

for s = 1, screen.count() do
    taskbar_layout_icon[s] = awful.widget.layoutbox(s)
    taskbar_list_tags[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all)
    taskbar_list_windows[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags)

    local widgets_left = wibox.layout.fixed.horizontal()
        widgets_left:add(taskbar_layout_icon[s])
        widgets_left:add(taskbar_list_tags[s])

    local widgets_right = wibox.layout.fixed.horizontal()
        widgets_right:add(taskbar_systray)
        widgets_right:add(taskbar_clock)

    local widgets_all = wibox.layout.align.horizontal()
        widgets_all:set_left(widgets_left)
        widgets_all:set_middle(taskbar_list_windows[s])
        widgets_all:set_right(widgets_right)

    taskbar[s] = awful.wibox({ position = "bottom", screen = s })
    taskbar[s]:set_widget(widgets_all)
end

