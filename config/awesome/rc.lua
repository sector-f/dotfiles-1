-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
local spawn = require("awful.spawn")
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

local common = require("awful.widget.common")

local dpi = require("beautiful").xresources.apply_dpi

local util = require("awful.util")

local capi = { screen = screen,
               client = client }

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
local layouts =
{
    lain.layout.uselesstile,
    lain.layout.uselessfair,
    lain.layout.termfair,
    lain.layout.uselesspiral,
    awful.layout.suit.floating,
    awful.layout.suit.max.fullscreen,
}

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

local awesompd = require("awesompd/awesompd")
musicwidget = awesompd:create() -- Create awesompd widget
--musicwidget.font = "Liberation Mono" -- Set widget font
musicwidget.font = theme.font -- Set widget font
musicwidget.font_color = theme.music_color
musicwidget.scrolling = true -- If true, the text in the widget will be scrolled
musicwidget.output_size = 30 -- Set the size of widget in symbols
musicwidget.update_interval = 5 -- Set the update interval in seconds
-- Set the folder where icons are located (change username to your login name)
musicwidget.path_to_icons = "/home/jaume/.config/awesome/awesompd/icons"
-- Set the default music format for Jamendo streams. You can change
-- this option on the fly in awesompd itself.
-- possible formats: awesompd.FORMAT_MP3, awesompd.FORMAT_OGG
musicwidget.jamendo_format = awesompd.FORMAT_MP3
-- If true, song notifications for Jamendo tracks and local tracks will also contain
-- album cover image.
musicwidget.show_album_cover = true
-- Specify how big in pixels should an album cover be. Maximum value
-- is 100.
musicwidget.album_cover_size = 50
-- This option is necessary if you want the album covers to be shown
-- for your local tracks.
musicwidget.mpd_config = "/home/jaume/.config/mpd/mpd.conf"
-- Specify the browser you use so awesompd can open links from
-- Jamendo in it.
musicwidget.browser = "firefox"
-- Specify decorators on the left and the right side of the
-- widget. Or just leave empty strings if you decorate the widget
-- from outside.

--musicwidget.ldecorator = (" <span color='"..util.ensure_pango_color(theme.music_color)..
musicwidget.ldecorator = (separator_text.."<span font_desc='"..theme.icon_font.."'>Î</span> ")
musicwidget.rdecorator = separator_text
-- Set all the servers to work with (here can be any servers you use)
musicwidget.servers = {
	{ server = "localhost",
	port = 6600 }
}
-- Set the buttons of the widget
musicwidget:register_buttons(
{
	{ "", awesompd.MOUSE_LEFT, musicwidget:command_playpause() },
	{ "Control", awesompd.MOUSE_SCROLL_UP, musicwidget:command_prev_track() },
	{ "Control", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_next_track() },
	{ "", awesompd.MOUSE_SCROLL_UP, musicwidget:command_volume_up() },
	{ "", awesompd.MOUSE_SCROLL_DOWN, musicwidget:command_volume_down() },
	{ "", awesompd.MOUSE_RIGHT, musicwidget:command_show_menu() },
	{ "", "XF86AudioLowerVolume", musicwidget:command_volume_down() },
	{ "", "XF86AudioRaiseVolume", musicwidget:command_volume_up() },
	{ modkey, "Pause", musicwidget:command_playpause() }
})
musicwidget:run() -- After all configuration is done, run the widget

--local comp = require("compton_widget")

comp = wibox.widget.textbox()
--comp.running = false

comp.update = function(self)
	self.running = spawn.pread("pgrep compton") ~= ""
	comp:set_text(comp.running and " C- " or " C+ ")
end

comp.toggle = function(self)
	if self.running then
		spawn.spawn("killall compton", false)
	else
		spawn.spawn("compton --config /home/jaume/.config/compton", false)
	end
	self:update()
end

comp:update()

comp:buttons(awful.util.table.join(
	awful.button({ }, 1, function () comp:toggle() end)
))

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    --tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
    tags[s] = awful.tag(
    { "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX" }, s, layouts[1])
    --tags[s] = awful.tag({ ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

-- mymainmenu = awful.menu({ items = { { "awesome", applicationsmenu.applicationsmenu(), beautiful.awesome_icon },
mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu },
                                    { "applications",  applicationsmenu.applicationsmenu() },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Î
-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock(
	" <span color='"..util.ensure_pango_color(theme.clock_color)..
	"'><span font_desc='"..theme.icon_font..
	"'>Õ</span> %a %d-%m %H:%M</span> ")

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
		bgb = wibox.widget.background()
		--tbm = wibox.layout.margin(tb, dpi(4), dpi(4))
		--ibm = wibox.layout.margin(ib, dpi(4))
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
		    bgb = wibox.widget.background()
		    tbm = wibox.layout.margin(tb, dpi(margin), dpi(margin))
		    ibm = wibox.layout.margin(ib, dpi(4))
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

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    --mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.noempty, mytaglist.buttons, nil, common.list_update)
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.noempty,
    	mytaglist.buttons, nil, make_list_update(7))
    --local margin_layout = wibox.layout.margin(mytaglist[s], 3, 2, 5, 4)

    -- Create a tasklist widget
    --mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons,
    	nil, make_list_update(15), wibox.layout.fixed.horizontal())

    -- Create the wibox
    mywibox[s] = awful.wibox({
	    position = "top",
	    screen = s,
	    font = theme.font,
	    height = round(beautiful.get_font_height(theme.font) * 2 + 5)
    })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then
	    right_layout:add(separator)
	    right_layout:add(wibox.layout.margin(wibox.widget.systray(), 2, 2, 0, 0))
    end
    right_layout:add(separator)
    right_layout:add(comp)
    right_layout:add(musicwidget.widget)
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])
    local mright_layout = wibox.layout.margin(right_layout, 0, 5, 5, 5)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    --layout:set_middle(mytasklist[s])
    --layout:set_middle(wibox.layout.margin(mytasklist[s], 5, 5, 0, 0))
    local mtasklist = wibox.layout.margin(mytasklist[s], 5, 5, 0, 0)
    local cmtasklist = wibox.layout.align.horizontal()
    cmtasklist:set_expand("none")
    cmtasklist:set_middle(mtasklist)
    layout:set_middle(wibox.layout.margin(cmtasklist, 5, 5, 0, 0))
    layout:set_right(mright_layout)

    local bgb = wibox.widget.background(layout, theme.bg_normal)
    local mlayout = wibox.layout.margin(bgb, 5, 5, 5, 0)

    --mywibox[s]:set_widget(layout)
    --mywibox[s]:set_widget(bgb)
    mywibox[s]:set_widget(mlayout)
    mywibox[s]:set_bg("#00000000")
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
 --   awful.button({ }, 4, awful.tag.viewnext),
 --   awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    --awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    --awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Left",   function() spawn.spawn("mpc prev", false) end),
    awful.key({ modkey,           }, "Right",  function() spawn.spawn("mpc next", false) end),
    awful.key({ modkey,           }, "Down",  function() spawn.spawn(
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
    awful.key({ modkey,           }, "Return", function () spawn.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "r",
      function ()
        --spawn.spawn("killall compton", false)
        awesome.restart()
    end),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    --awful.key({ modkey,           }, "d", function () spawn.spawn("dmenu_run -h 20 -dim 0.5") end),
    awful.key({ modkey,           }, "d", function () spawn.spawn("rofi -show run") end),
    awful.key({ modkey,           }, "\\", function () spawn.spawn("exo-open --launch FileManager") end),
    awful.key({ modkey,           }, "]", function () spawn.spawn("exo-open --launch WebBrowser") end),
   -- awful.key({                   }, "Print", function () spawn.spawn("import /tmp/latest-screenshot.png") end),
    awful.key({                   }, "Print", function () spawn.spawn("mixtape-maim.sh -g 1920x1080+0+0") end),
    awful.key({ modkey,           }, "Print", function () spawn.spawn("mixtape-maim.sh") end),
    awful.key({ "Shift"           }, "Print", function () spawn.spawn("mixtape-maim.sh -s") end),
    awful.key({ "Control"         }, "Print", function () spawn.spawn("maim -s") end),
    awful.key({ modkey,           }, "F12", function () spawn.spawn("randwallpaper", false) end),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey, "Shift" }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    --
    awful.key({ modkey, "Control" }, "x", function() spawn.spawn("pkill -f 'x11grab'", false) end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
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
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
        --awful.key({ }, "Print",
        --          function ()
        --              spawn.spawn("scrot -e 'mv $f ~/screenshots/ 2>/dev/null'")
        --          end))

end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

local border_width = beautiful.border_width
--local border_width = 0

--for s = 1, screen.count() do
--    screen[s]:connect_signal("arrange", function ()
--        local clients = awful.client.visible(s)
--        local layout  = awful.layout.getname(awful.layout.get(s))
--
--        -- No borders with only one visible client or in maximized layout
--        if #clients > 1 and layout ~= "max" then
--            for _, c in pairs(clients) do -- Floaters always have borders
--                if not awful.rules.match(c, {class = "Synapse"}) and awful.client.floating.get(c) or layout == "floating" then
--                    c.border_width = beautiful.border_width
--                    c.border_color = beautiful.border_focus
--                end
--            end
--        end
--    end)
--end

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "feh" },
      properties = { floating = true } },
    { rule = { class = "csgo_linux" },
      properties = { border_width = 0 } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
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

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

spawn.with_shell("~/.xsession")

-- }}}