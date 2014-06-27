globalkeys = awful.util.table.join(

    awful.key({ modkey,           }, "p",      awful.tag.viewprev       ),
    awful.key({ modkey,           }, "n",      awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
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
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1) end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1) end),
    awful.key({ modkey, "Shift"   }, "n", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Shift"   }, "p", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "l", function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey,           }, "h", function () awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Shortcuts
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(file_manager_open .. "/home/danelkouby") end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({                   }, "Print",  function () awful.util.spawn("scrot") end),
    awful.key({ modkey, "Shift"   }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "w", function () menu_main:show() end),

    -- dmenu
    awful.key({ modkey,           }, "r", function () awful.util.spawn("dmenu_run -fn 'dejavu sans mono book-10' -nb '#002B36' -nf '#93A1A1' -sb '#93A1A1' -sf '#002B36'") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "q", function (c) c:kill() end),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle),
    awful.key({ modkey,           }, "o", awful.client.movetoscreen)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
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

