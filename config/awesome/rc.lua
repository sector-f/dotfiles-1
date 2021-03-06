-- Standard awesome library
local gears = require("gears")
local timer = gears.timer
local awful = require("awful")
awful.rules = require("awful.rules")
awful.util = require("awful.util")
local util = awful.util
local err
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
require("applicationsmenu")
--
local lain = require("lain")
local round = require("awful.util").round

local vicious = require("vicious")
vicious.helpers = require("vicious.helpers")

local common = require("awful.widget.common")

local volumebar_widget = require("volumebar")

--local treetile = require("treetile")

local dpi -- = require("beautiful").xresources.apply_dpi
pcall(function() dpi = require("beautiful").xresources.apply_dpi end)
if not dpi then
    dpi = function(a) return a end
end

local capi = { screen = screen,
               client = client }

if not awful.util.ensure_pango_color then
    awful.util.ensure_pango_color = function (a) return a end
end

local round = round
if not round then
    local floor = math.floor
    round = function (x)
        return floor(x + 0.5)
    end
end

local gaps = true
local small = false

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
-- beautiful.init("/usr/share/awesome/themes/default/theme.lua")
--
beautiful.init("~/.config/awesome/mytheme/theme.lua")
--beautiful.init("~/.config/awesome/mytheme.light/theme.lua")

--beautiful.init("/usr/share/awesome/themes/arch/theme.lua")

-- beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
-- beautiful.init("/usr/share/awesome/themes/niceandclean/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "i3-sensible-terminal"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod1"

theme.lain_icons          = "/home/jaume/.config/awesome/lain/icons/layout/default/"
theme.beautiful_icons     = "/usr/share/awesome/themes/default/layouts/"
theme.layout_termfair     = theme.lain_icons .. "termfairw.png"
theme.layout_uselessfair  = theme.lain_icons .. "termfairw.png"
theme.layout_cascade      = theme.lain_icons .. "cascadew.png"
theme.layout_cascadetile  = theme.lain_icons .. "cascadetilew.png"
theme.layout_centerwork   = theme.lain_icons .. "centerworkw.png"
theme.layout_uselesspiral = theme.beautiful_icons .. "spiralw.png"
theme.layout_uselesstile  = theme.beautiful_icons .. "tilew.png"

-- Table of layouts to cover with awful.layout.inc, order matters.
--local layouts = {}

layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    lain.layout.termfair,
    awful.layout.suit.spiral,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen,
    --treetile,
}
if gaps then
    --layouts =
    --{
    --    lain.layout.uselesstile,
    --    lain.layout.uselessfair,
    --    lain.layout.termfair,
    --    lain.layout.uselesspiral,
    --    awful.layout.suit.floating,
    --    awful.layout.suit.max.fullscreen,
    --}
    theme.useless_gap = 6
else
    theme.useless_gap = 0
    size_hints_honor = false
end
awful.layout.layouts = layouts

lain.layout.termfair.nmaster = 3
lain.layout.termfair.ncol = 1

-- theme.useless_gap_width = 10
theme.tasklist_disable_icon = true
--local layouts =
--{
--    awful.layout.suit.floating,
--    awful.layout.suit.tile,
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.tile.top,
--    awful.layout.suit.fair,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
--    awful.layout.suit.max,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.magnifier
--}
-- }}}
--

local separator_text = " "
local separator = wibox.widget.textbox()
separator:set_text(separator_text)

-- mpd

local mpd_widget = require("mpd_widget")

--local comp = require("compton_widget")

comp = wibox.widget.imagebox()
--comp.running = false

local comp_running_icon = awful.util.getdir("config") .. "icons/compton_16x16.png"
local comp_not_running_icon = (awful.util.getdir("config") ..
    "icons/compton_grayscale_16x16.png")

comp.update = function(self, f)
    --self.running = io.popen("pgrep compton"):read() ~= nil
    awful.spawn.easy_async("pgrep compton", function(o, e, r, c) self.running = c == 0 end)
    comp:set_image(comp.running and comp_running_icon or comp_not_running_icon)
    --comp:set_text(comp.running and " C- " or " C+ ")
    if f ~= nil then
        f(self.running)
    end
end

comp.toggle = function(self)
    comp:update(function(running)
        if running then
            awful.spawn("killall compton", false)
        else
            awful.spawn("compton --config /home/jaume/.config/compton", false)
        end
        self:update()
    end)
end

comp:update()

comp:buttons(awful.util.table.join(
    awful.button({ }, 1, function () comp:toggle() end)
))

-- TODO just dump vicious
function battery_formatter(widget, data)
    --local map = {}
    --map["↯"] =
    --map["+"] = awful.util.getdir("config") .. "icons/connected.png"
    local s2 = nil
    s = awful.util.getdir("config") .. "icons/bat_full.png"
    if data[1] ~= "↯" then
        if data[2] < 80 then
            s = awful.util.getdir("config") .. "icons/bat_low.png"
        end
        if data[2] < 25 then
            s = awful.util.getdir("config") .. "icons/bat_empty.png"
        end
    end
    if data[1] == "+" then
        widget:set_image2(awful.util.getdir("config") .. "icons/connected.png")
    else
        widget:set_image2("")
    end
    if s then
        widget:set_image(s)
    end
    local text = string.format(" %d%%", data[2])
    widget:set_text(text)
    return text
    --return vicious.helpers.format("$2%", data)
end

local batterywidget = nil
local hostname = io.popen("uname -n"):read()
--local batterywidget = wibox.widget.textbox()
function make_battery_widget()
    local l = wibox.layout.fixed.horizontal()
    local lm = wibox.container.margin(l, dpi(4), dpi(4))
    local b_icon = wibox.widget.imagebox()
    local b_icon2 = wibox.widget.imagebox()
    local b_text = wibox.widget.textbox()
    l:add(b_icon)
    l:add(b_text)
    lm.set_image = function(self, source)
    --    b_icon:set_image(source)
    end
    lm.set_image2 = function(self, source)
    --    b_icon2:set_image(source)
    end
    lm.set_text = function(self, source)
        b_text:set_text(source)
    end
    return lm
end

if hostname == "evangelion" then
    batterywidget = make_battery_widget()
	vicious.register(batterywidget, vicious.widgets.bat, battery_formatter, 5, "BAT1")
	--vicious.register(batterywidget, vicious.widgets.bat, " $1 $2% ", 5, "BAT1")
end

-- {{{ Wallpaper
--if beautiful.wallpaper then
--    for s = 1, screen.count() do
--        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
--    end
--end
-- }}}

local padding = 0

function set_paddings()
    awful.screen.connect_for_each_screen(function(s)
        s.padding = {top = padding, bottom = padding, left = padding, right = padding}
    end)
    --for s = 1, screen.count() do
    --    awful.screen.padding(screen[s],
    --    {top = padding, bottom = padding, left = padding, right = padding})
    --end
end

set_paddings()

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

-- mymainmenu = awful.menu({ items = { { "awesome", applicationsmenu.applicationsmenu(), beautiful.awesome_icon },
mymainmenu = awful.menu({ items = {
    { "awesome", myawesomemenu },
    { "applications",  applicationsmenu.applicationsmenu() },
    { "open terminal", terminal }
} })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Î
-- {{{ Wibox
-- Create a textclock widget
mytextclock = wibox.widget.textclock(
    " <span color='"..util.ensure_pango_color(theme.clock_color)..
    "'><span font_desc='"..theme.icon_font..
    "'>Õ</span> %a %d-%m %H:%M</span> ")
smalltextclock = wibox.widget.textclock(
    " <span color='"..util.ensure_pango_color(theme.clock_color)..
    "'><span font_desc='"..theme.icon_font..
    "'>Õ</span>%H:%M</span>")

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                         if c == client.focus then
                             c.minimized = true
                         else
                             -- Without this, the following
                             -- :isvisible() makes no sense
                             c.minimized = false
                             if not c:isvisible() then
                                 awful.tag.viewonly(c:tags()[1])
                             end
                             -- This will also un-minimize
                             -- the client, if needed
                             client.focus = c
                             c:raise()
                         end
                     end),
                     awful.button({ }, 3, function ()
                         if instance then
                             instance:hide()
                             instance = nil
                         else
                             instance = awful.menu.clients({ width=250 })
                         end
                     end),
                     awful.button({ }, 4, function ()
                         awful.client.focus.byidx(1)
                         if client.focus then client.focus:raise() end
                     end),
                     awful.button({ }, 5, function ()
                         awful.client.focus.byidx(-1)
                         if client.focus then client.focus:raise() end
                     end))

function my_list_update_(w, buttons, label, data, objects)
    -- update the widgets, creating them if needed
    w:reset()
    for i, o in ipairs(objects) do
        local ib, tb, bgb, tbm, ibm, l
        ib = wibox.widget.imagebox()
        tb = wibox.widget.textbox()
        bgb = wibox.container.background()
        --tbm = wibox.container.margin(tb, dpi(4), dpi(4))
        --ibm = wibox.container.margin(ib, dpi(4))
        --l = wibox.layout.fixed.horizontal()
        local text, bg, bg_image, icon = label(o)
        if not pcall(tb.set_markup, tb, text) then
            tb:set_markup("<i>&lt;Invalid text&gt;</i>")
        end
        --tb = wibox.widget.textbox("AAA")
        w:add(tb)
    end
end

function make_list_update(margin)
    local function my_list_update(w, buttons, label, data, objects)
        -- update the widgets, creating them if needed
        w:reset()
        for i, o in ipairs(objects) do
        local cache = data[o]
        local ib, tb, bgb, tbm, ibm, l
        if cache then
            ib = cache.ib
            tb = cache.tb
            bgb = cache.bgb
            tbm = cache.tbm
            ibm = cache.ibm
        else
            ib = wibox.widget.imagebox()
            tb = wibox.widget.textbox()
            bgb = wibox.container.background()
            tbm = wibox.container.margin(tb, dpi(margin), dpi(margin))
            ibm = wibox.container.margin(ib, dpi(4))
            l = wibox.layout.fixed.horizontal()

            -- All of this is added in a fixed widget
            l:fill_space(true)
            l:add(ibm)
            l:add(tbm)

            -- And all of this gets a background
            bgb:set_widget(l)

            bgb:buttons(common.create_buttons(buttons, o))

            data[o] = {
            ib  = ib,
            tb  = tb,
            bgb = bgb,
            tbm = tbm,
            ibm = ibm,
            }
        end

        local text, bg, bg_image, icon = label(o, tb)
        -- The text might be invalid, so use pcall.
        if text == nil or text == "" then
            tbm:set_margins(0)
        else
            if not pcall(tb.set_markup, tb, text) then
            tb:set_markup("<i>&lt;Invalid text&gt;</i>")
            end
        end
        bgb:set_bg(bg)
        if type(bg_image) == "function" then
            bg_image = bg_image(tb,o,m,objects,i)
        end
        bgb:set_bgimage(bg_image)
        if icon then
            ib:set_image(icon)
        else
            ibm:set_margins(0)
        end
        w:add(bgb)
       end
    end
    return my_list_update
end

local si = 1
--for s = 1, screen.count() do
local si = 1
awful.screen.connect_for_each_screen(function(s)
    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Each screen has its own tag table.
    awful.tag({ "一", "二", "三", "四", "五", "六", "七", "八", "九" }, s, layouts[1])

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc(1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    --mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, mytaglist.buttons, nil, common.list_update)
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.noempty,
        mytaglist.buttons, nil, make_list_update(7))
    --local margin_layout = wibox.container.margin(mytaglist[s], 3, 2, 5, 4)

    -- Create a tasklist widget
    --mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags,
        mytasklist.buttons, nil, make_list_update(15), wibox.layout.fixed.horizontal())

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s,
        font = theme.font,
        height = round(beautiful.get_font_height(theme.font) * 2 + 5)
    })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(mylauncher)
    left_layout:add(s.mytaglist)
    left_layout:add(s.mypromptbox)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if si == 1 then
        si = si + 1
        right_layout:add(separator)
        right_layout:add(wibox.container.margin(wibox.widget.systray(), 2, 2, 0, 0))
    end
    right_layout:add(separator)
    right_layout:add(comp)

    if batterywidget then
        right_layout:add(batterywidget)
    end
    if not small then
        right_layout:add(mpd_widget)
        right_layout:add(separator)
        right_layout:add(volumebar_widget)
        right_layout:add(mytextclock)
    else
        right_layout:add(smalltextclock)
    end

    right_layout:add(s.mylayoutbox)
    local mright_layout = wibox.container.margin(right_layout, 0, 5, 5, 5)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(mytasklist[s])
    --layout:set_middle(wibox.container.margin(mytasklist[s], 5, 5, 0, 0))
    local mtasklist = wibox.container.margin(s.mytasklist, 5, 5, 0, 0)
    local cmtasklist = wibox.layout.align.horizontal()
    cmtasklist:set_expand("none")
    cmtasklist:set_middle(mtasklist)
    layout:set_middle(wibox.container.margin(cmtasklist, 5, 5, 0, 0))
    layout:set_right(mright_layout)

    local bgb = wibox.container.background(layout, theme.bg_normal)

    local mlayout = {}
    if gaps then
        mlayout = wibox.container.margin(bgb, 5, 5, 5, 0)
    else
        mlayout = wibox.container.margin(bgb, 0, 0, 0, 0)
    end

    --mywibox[s]:set_widget(layout)
    --mywibox[s]:set_widget(bgb)
    s.mywibox:set_widget(mlayout)
    s.mywibox:set_bg("#00000000")
    si = si + 1
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
--    awful.button({ }, 3, function () mymainmenu:toggle() end)
 --   awful.button({ }, 4, awful.tag.viewnext),
 --   awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    --awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    --awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Left",   function() awful.spawn("mpc prev", false) end),
    awful.key({ modkey,           }, "Right",  function() awful.spawn("mpc next", false) end),
    awful.key({ modkey,           }, "Down",  function() awful.spawn(
        "bash -c 'if mpc | grep playing; then mpc pause; else mpc play; fi'", false) end),
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
    --awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    --awful.key({ modkey,           }, "Tab",
    --    function ()
    --        awful.client.focus.history.previous()
    --        if client.focus then
    --            client.focus:raise()
    --        end
    --    end),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey, "Shift"   }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "r",
      function ()
        --awful.spawn("killall compton", false)
        awesome.restart()
    end),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit),

    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "n",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "n",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "n",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    --awful.key({ modkey,           }, "d", function () awful.spawn("dmenu_run -h 20 -dim 0.5") end),
    --awful.key({ modkey,           }, "d", function () awful.spawn("rofi -show run") end),
    awful.key({ modkey,           }, "d", function () awful.spawn(
        "rofi -show combi -combi-modi drun,run") end),
    awful.key({ modkey,           }, "\\", function () awful.spawn("exo-open --launch FileManager") end),
    awful.key({ modkey,           }, "]", function () awful.spawn("exo-open --launch WebBrowser") end),
   -- awful.key({                   }, "Print", function () awful.spawn("import /tmp/latest-screenshot.png") end),
    awful.key({                   }, "Print", function ()
        if hostname == "evangelion" then
            awful.spawn("mixtape-maim.sh -g 1600x900+0+0")
        else
            awful.spawn("mixtape-maim.sh -g 1920x1080+0+0")
        end
    end),
    awful.key({ modkey,           }, "Print", function () awful.spawn("mixtape-maim.sh") end),
    awful.key({ "Shift"           }, "Print", function () awful.spawn("mixtape-maim.sh -u -s") end),
    awful.key({ "Control"         }, "Print", function () awful.spawn("maim -s -u") end),
    --awful.key({ modkey,           }, "F12", function () awful.spawn("randwallpaper", false) end),
    awful.key({ modkey,           }, "F12", function ()
        awful.spawn("comp_randwallpaper", false)
    end),
    awful.key({ modkey,           }, "F11", function () awful.spawn("nfortune", false) end),

    -- Prompt
    --awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey, "Shift" }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    --awful.key({ modkey }, "p", function() menubar.show() end),

    --
    awful.key({ modkey, "Control" }, "x", function() awful.spawn("pkill -f 'x11grab'", false) end),

    -- padding
    awful.key({ modkey, "Control" }, "r", function()
        local amount = 6
        if padding < 200 then
            padding = padding + amount
        end
        set_paddings()
    end),
    awful.key({ modkey, "Control" }, "l", function()
        local amount = 6
        if padding - amount >= 0 then
            padding = padding - amount
        end
        set_paddings()
    end),
    awful.key({ modkey, "Control" }, "i", function()
        local amount = 3
        if theme.useless_gap < 200 then
            theme.useless_gap = theme.useless_gap + amount
        end
        awful.layout.inc(layouts,  1)
        awful.layout.inc(layouts, -1)
    end),
    awful.key({ modkey, "Control" }, "o", function()
        local amount = 3
        if theme.useless_gap - amount >= 0 then
            theme.useless_gap = theme.useless_gap - amount
        end
        awful.layout.inc(layouts,  1)
        awful.layout.inc(layouts, -1)
    end),
    awful.key({}, "XF86AudioMute", function()
        awful.spawn("pulseaudio-ctl mute", false)
    end),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn("pulseaudio-ctl down", false)
    end),
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn("pulseaudio-ctl up", false)
    end),
    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn("light -U 20", false)
    end),
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn("light -A 20", false)
    end)
    --awful.key({ modkey }, "v", treetile.vertical),
    --awful.key({ modkey }, "s", treetile.horizontal)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "q",
        function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",
        awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return",
        function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",
        awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",
        function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = c.maximized_horizontal
            c.maximized            = c.maximized_horizontal
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

local border_width = beautiful.border_width

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     --size_hints_honor = false,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
                 } },
    --{ rule = { class = "MPlayer" },
    --  properties = { floating = true } },
    --{ rule = { class = "pinentry" },
    --  properties = { floating = true } },
    --{ rule = { class = "gimp" },
    --  properties = { floating = true } },
    --{ rule = { class = "feh" },
    --  properties = { floating = true } },
    { rule = { class = "csgo_linux" },
      properties = { border_width = 0 } },
    --{ rule = { class = "mpv" },
    --  properties = { border_width = 0 } },
    { rule = { class = "Steam" },
      properties = { size_hints_honor = true } },
    { rule = { class = "Godot" },
      properties = { floating = true,
                     maximized = false,
                     maximized_horizontal = false,
                     maximized_vertical = false } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)

    --if not startup then
    --    -- Set the windows at the slave,
    --    -- i.e. put it at the end of others instead of setting it master.
    --    -- awful.client.setslave(c)

    --    -- Put windows in a smart way, only if they does not set an initial position.
    --    if not c.size_hints.user_position and not c.size_hints.program_position then
    --        awful.placement.no_overlap(c)
    --        awful.placement.no_offscreen(c)
    --    end
    --end


    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.spawn.with_shell("~/.config/autostart.sh")

comptimer = timer({ timeout = 5 })
comptimer:connect_signal("timeout", function()
    comp:update()
    comptimer:stop()
    comptimer:start()
end)
comptimer:start()


-- }}}
