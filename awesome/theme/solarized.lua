theme = {}

theme.path = os.getenv("HOME") .. "/.config/awesome/theme/"

theme.font          = "DejaVu Sans Mono 9"

theme.bg_normal     = "#002B36"
theme.bg_focus      = "#93A1A1"
theme.bg_urgent     = "#B58900"
theme.bg_minimize   = "#586E75"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#93A1A1"
theme.fg_focus      = "#002B36"
theme.fg_urgent     = "#93A1A1"
theme.fg_minimize   = "#93A1A1"

theme.border_width  = 1
theme.border_normal = "#586E75"
theme.border_focus  = "#93A1A1"
theme.border_marked = "#B58900"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[normal|focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme.path .. "submenu.png"
theme.menu_height = 20
theme.menu_width  = 150

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = theme.path .. "titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme.path .. "titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme.path .. "titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme.path .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.path .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme.path .. "titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme.path .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme.path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme.path .. "titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme.path .. "titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme.path .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.path .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme.path .. "titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.path .. "titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme.path .. "titlebar/maximized_focus_active.png"

theme.taglist_squares_sel   = theme.path .. "tagsquare_sel.png"
theme.taglist_squares_unsel = theme.path .. "tagsquare_unsel.png"

-- You can use your own layout icons like this:
theme.layout_fairh = theme.path .. "layouts/fairh.png"
theme.layout_fairv = theme.path .. "layouts/fairv.png"
theme.layout_floating  = theme.path .. "layouts/floating.png"
theme.layout_magnifier = theme.path .. "layouts/magnifier.png"
theme.layout_max = theme.path .. "layouts/max.png"
theme.layout_fullscreen = theme.path .. "layouts/fullscreen.png"
theme.layout_tilebottom = theme.path .. "layouts/tilebottom.png"
theme.layout_tileleft   = theme.path .. "layouts/tileleft.png"
theme.layout_tile = theme.path .. "layouts/tile.png"
theme.layout_tiletop = theme.path .. "layouts/tiletop.png"
theme.layout_spiral  = theme.path .. "layouts/spiral.png"
theme.layout_dwindle = theme.path .. "layouts/dwindle.png"

theme.icon_awesome = theme.path .. "awesome.png"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

