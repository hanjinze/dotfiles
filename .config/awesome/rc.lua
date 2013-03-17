-- {{{ License
--
--   * Awesome WM config Derek M. <derek@disflux.com>. Original config adapted from:
--   * Adrian C. <anrxc@sysphere.org>


-- This work is licensed under the Creative Commons Attribution-Share
-- Alike License: http://creativecommons.org/licenses/by-sa/3.0/
-- }}}


-- {{{ Libraries
awful = require("awful")
require("awful.rules")
require("awful.autofocus")
-- User libraries
vicious = require("vicious")
scratch = require("scratch")
beautiful = require("beautiful")
-- }}}

--terminal = "urxvt -sh 20 -fg gray -bg '#101010' -tint gray +sb -fn 'xft:terminus-8'"
terminal = "terminator"
cmd_nexttrack = "mpc next"
cmd_prevtrack = "mpc prev"
cmd_playpause = "mpc toggle"
cmd_browser = "google-chrome"
cmd_browserlite = "uzbl-browser"
cmd_filemanager = "thunar"
cmd_screenshot = "scrot '%Y%m%d-%H%M%S-full.png' -m -e 'mv $f ~/ss'"
cmd_windowshot = "import -quality 95 ~/ss/`date +'%Y%m%d-%H%M%S'`-sel.png"
cmd_volup = "amixer -c 0 -q set Master 3%+ unmute"
cmd_voldown = "amixer -c 0 -q set Master 3%- unmute"
cmd_volmute = "amixer -c 0 -q set Master toggle"
cmd_twitter = "urxvt +sb -fn 'xft:terminus-8' -e ttytter"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- {{{ Variable definitions
local altkey = "Mod1"
local modkey = "Mod4"

local home   = os.getenv("HOME")
local exec   = awful.util.spawn
local sexec  = awful.util.spawn_with_shell

-- Beautiful theme
beautiful.init(home .. "/.config/awesome/zenburn.lua")

-- Window management layouts
layouts = {
   awful.layout.suit.tile,        -- 1
   awful.layout.suit.tile.bottom, -- 2
   awful.layout.suit.fair,        -- 3
   awful.layout.suit.max,         -- 4
   awful.layout.suit.magnifier,   -- 5
   awful.layout.suit.floating     -- 6
}
-- }}}


-- {{{ Tags
tags = {}
for s = 1, screen.count() do
   -- Each screen has its own tag table.
   tags[s] = awful.tag({ 'main', 'web', 'dev', 'music', 'file', 'gfx', 'office', 'misc'}, s, layouts[1])
end
-- }}}


-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}
myofficemenu = {
   { "Writer", "lowriter" },
   { "Spreadsheet", "localc" },
   { "Acrobat", "acroread" }
}


mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
{ "Office", myofficemenu },
{ "open terminal", terminal }
                                  }
                               })

                               mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                               menu = mymainmenu })
                               -- }}}

                               -- {{{ Wibox
                               --
                               -- {{{ Widgets configuration
                               --
                               -- {{{ Reusable separator
                               separator = widget({ type = "imagebox" })
                               separator.image = image(beautiful.widget_sep)
                               -- }}}

                               -- {{{ CPU usage and temperature
                               cpuicon = widget({ type = "imagebox" })
                               cpuicon.image = image(beautiful.widget_cpu)
                               -- Initialize widgets
                               cpugraph  = awful.widget.graph()
                               tzswidget = widget({ type = "textbox" })
                               -- Graph properties
                               cpugraph:set_width(40):set_height(14)
                               cpugraph:set_background_color(beautiful.fg_off_widget)
                               cpugraph:set_gradient_angle(0):set_gradient_colors({
                                  beautiful.fg_end_widget, beautiful.fg_center_widget, beautiful.fg_widget
                               }) -- Register widgets
                               vicious.register(cpugraph,  vicious.widgets.cpu,      "$1")
                               vicious.register(tzswidget, vicious.widgets.thermal, " $1C", 19, "thermal_zone0")
                               -- }}}

                               -- {{{ mpd widget
                               mpdicon = widget({ type = "imagebox" })
                               mpdicon.image = image(beautiful.widget_music)
                               -- Initialize widget
                               mpdwidget = widget({ type = "textbox" })
                               -- Register widget
                               vicious.register(mpdwidget, vicious.widgets.mpd,
                               function (widget, args)
                                  if args["{state}"] == "Stop" then 
                                     return " - "
                                  else 
                                     return args["{Artist}"]..' - '.. args["{Title}"]
                                  end
                               end, 10)
                               -- }}}

                               -- {{{ Memory usage
                               memicon = widget({ type = "imagebox" })
                               memicon.image = image(beautiful.widget_mem)
                               -- Initialize widget
                               membar = awful.widget.progressbar()
                               -- Pogressbar properties
                               membar:set_vertical(true):set_ticks(true)
                               membar:set_height(12):set_width(8):set_ticks_size(2)
                               membar:set_background_color(beautiful.fg_off_widget)
                               membar:set_gradient_colors({ beautiful.fg_widget,
                               beautiful.fg_center_widget, beautiful.fg_end_widget
                            }) -- Register widget
                            vicious.register(membar, vicious.widgets.mem, "$1", 13)
                            -- }}}

                            -- {{{ File system usage
                            fsicon = widget({ type = "imagebox" })
                            fsicon.image = image(beautiful.widget_fs)
                            -- Initialize widgets
                            fs = {
                               r = awful.widget.progressbar(), h = awful.widget.progressbar(),
                               s = awful.widget.progressbar(), b = awful.widget.progressbar()
                            }
                            -- Progressbar properties
                            for _, w in pairs(fs) do
                               w:set_vertical(true):set_ticks(true)
                               w:set_height(14):set_width(5):set_ticks_size(2)
                               w:set_border_color(beautiful.border_widget)
                               w:set_background_color(beautiful.fg_off_widget)
                               w:set_gradient_colors({ beautiful.fg_widget,
                               beautiful.fg_center_widget, beautiful.fg_end_widget
                            }) -- Register buttons
                            w.widget:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () exec("thunar", false) end)
                            ))
                         end -- Enable caching
                         vicious.cache(vicious.widgets.fs)
                         -- Register widgets
                         vicious.register(fs.r, vicious.widgets.fs, "${/ used_p}",            599)
                         vicious.register(fs.h, vicious.widgets.fs, "${/tank used_p}",            599)

                         -- }}}

                         -- {{{ Network usage
                         dnicon = widget({ type = "imagebox" })
                         upicon = widget({ type = "imagebox" })
                         dnicon.image = image(beautiful.widget_net)
                         upicon.image = image(beautiful.widget_netup)
                         -- Initialize widget
                         netwidget = widget({ type = "textbox" })
                         -- Register widget
                         vicious.register(netwidget, vicious.widgets.net, '<span color="'
                         .. beautiful.fg_netdn_widget ..'">${eth0 down_kb}</span> <span color="'
                         .. beautiful.fg_netup_widget ..'">${eth0 up_kb}</span>', 3)
                         -- }}}

                         -- {{{ Volume level
                         volicon = widget({ type = "imagebox" })
                         volicon.image = image(beautiful.widget_vol)
                         -- Initialize widgets
                         volbar    = awful.widget.progressbar()
                         volwidget = widget({ type = "textbox" })
                         -- Progressbar properties
                         volbar:set_vertical(true):set_ticks(true)
                         volbar:set_height(12):set_width(8):set_ticks_size(2)
                         volbar:set_background_color(beautiful.fg_off_widget)
                         volbar:set_gradient_colors({ beautiful.fg_widget,
                         beautiful.fg_center_widget, beautiful.fg_end_widget
                      }) -- Enable caching
                      vicious.cache(vicious.widgets.volume)
                      -- Register widgets
                      vicious.register(volbar,    vicious.widgets.volume,  "$1",  2, "Master -c 0")
                      vicious.register(volwidget, vicious.widgets.volume, " $1%", 2, "Master -c 0")
                      -- Register buttons
                      volbar.widget:buttons(awful.util.table.join(
                      awful.button({ }, 1, function () exec("kmix") end),
                      awful.button({ }, 4, function () exec("amixer -c 0 -q set Master 2dB+", false) end),
                      awful.button({ }, 5, function () exec("amixer -c 0 -q set Master 2dB-", false) end)
                      )) -- Register assigned buttons
                      volwidget:buttons(volbar.widget:buttons())
                      -- }}}

                      -- {{{ Date and time
                      dateicon = widget({ type = "imagebox" })
                      dateicon.image = image(beautiful.widget_date)
                      -- Initialize widget
                      datewidget = widget({ type = "textbox" })
                      -- Register widget
                      vicious.register(datewidget, vicious.widgets.date, "%R", 61)
                      -- Register buttons
                      datewidget:buttons(awful.util.table.join(
                      awful.button({ }, 1, function () exec("pylendar.py") end)
                      ))
                      -- }}}

                      -- {{{ Uptime widget
                      uptimeicon = widget({ type = "imagebox" })
                      uptimeicon.image = image(beautiful.widget_info)
                      -- Initialize widget
                      uptimewidget = widget({ type = "textbox" })
                      -- Register widget
                      vicious.register(uptimewidget, vicious.widgets.uptime, 
                      function (widget, args)
                         return string.format("%2d:%02d:%02d ", args[1], args[2], args[3])
                      end, 61)
                      -- }}}


                      -- {{{ System tray
                      systray = widget({ type = "systray" })
                      -- }}}
                      -- }}}

                      -- {{{ Wibox initialisation
                      wibox     = {}
                      promptbox = {}
                      layoutbox = {}
                      taglist   = {}
                      taglist.buttons = awful.util.table.join(
                      awful.button({ },        1, awful.tag.viewonly),
                      awful.button({ modkey }, 1, awful.client.movetotag),
                      awful.button({ },        3, awful.tag.viewtoggle),
                      awful.button({ modkey }, 3, awful.client.toggletag),
                      awful.button({ },        4, awful.tag.viewnext),
                      awful.button({ },        5, awful.tag.viewprev
                      ))

                      for s = 1, screen.count() do
                         -- Create a promptbox
                         promptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
                         -- Create a layoutbox
                         layoutbox[s] = awful.widget.layoutbox(s)
                         layoutbox[s]:buttons(awful.util.table.join(
                         awful.button({ }, 1, function () awful.layout.inc(layouts,  1) end),
                         awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                         awful.button({ }, 4, function () awful.layout.inc(layouts,  1) end),
                         awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
                         ))

                         -- Create the taglist
                         taglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, taglist.buttons)
                         -- Create the wibox
                         wibox[s] = awful.wibox({      screen = s,
                         fg = beautiful.fg_normal, height = 12,
                         bg = beautiful.bg_normal, position = "top",
                         border_color = beautiful.border_focus,
                         border_width = beautiful.border_width
                      })
                      -- Add widgets to the wibox
                      wibox[s].widgets = {
                         {   taglist[s], separator, promptbox[s],
                         ["layout"] = awful.widget.layout.horizontal.leftright
                      },
                      s == screen.count() and systray or nil,
                      layoutbox[s],
                      separator, datewidget, dateicon,
                      separator, uptimewidget, uptimeicon,
                      separator, volwidget,  volbar.widget, volicon,
                      separator, upicon,     netwidget, dnicon,
                      separator, fs.b.widget, fs.s.widget, fs.h.widget, fs.r.widget, fsicon,
                      separator, membar.widget, memicon,
                      separator, cpugraph.widget, cpuicon,
                      separator, ["layout"] = awful.widget.layout.horizontal.rightleft,
                      mpdwidget, mpdicon
                   }
                end
                -- }}}
                -- }}}


                -- {{{ Mouse bindings
                root.buttons(awful.util.table.join(
                awful.button({ }, 3, function () mymainmenu:toggle() end),
                awful.button({ }, 4, awful.tag.viewnext),
                awful.button({ }, 5, awful.tag.viewprev)
                ))

                -- Client bindings
                clientbuttons = awful.util.table.join(
                awful.button({ },        1, function (c) client.focus = c; c:raise() end),
                awful.button({ modkey }, 1, awful.mouse.client.move),
                awful.button({ modkey }, 3, awful.mouse.client.resize)
                )
                -- }}}


                -- {{{ Key bindings
                globalkeys = awful.util.table.join(
                awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
                awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
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
                awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

                -- Layout manipulation
                awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
                awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
                awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
                awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
                awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
                awful.key({ modkey,           }, "Tab",
                function ()
                   awful.client.focus.history.previous()
                   if client.focus then
                      client.focus:raise()
                   end
                end),

                -- Standard program
                awful.key({ modkey,		      }, "Return", function () awful.util.spawn(terminal) end),
                awful.key({ 				  }, "F10", function () awful.util.spawn_with_shell(cmd_prevtrack) end),
                awful.key({                   }, "F12", function () awful.util.spawn_with_shell(cmd_nexttrack) end),
                awful.key({               	  }, "Print", function () awful.util.spawn_with_shell(cmd_screenshot) end),
                awful.key({ modkey,           }, "Print", function () awful.util.spawn_with_shell(cmd_windowshot) end),
                awful.key({                   }, "F11", function () awful.util.spawn_with_shell(cmd_playpause) end),
                awful.key({          		  }, "XF86AudioRaiseVolume", function () awful.util.spawn_with_shell(cmd_volup) end),
                awful.key({           		  }, "XF86AudioLowerVolume", function () awful.util.spawn_with_shell(cmd_voldown) end),
                awful.key({               	  }, "XF86AudioMute", function () awful.util.spawn_with_shell(cmd_volmute) end),
                awful.key({ modkey,			  }, "t", function () awful.util.spawn_with_shell(cmd_twitter) end),
                awful.key({ modkey, "Shift"   }, "o", function () awful.util.spawn(cmd_browser) end),
                awful.key({ modkey, "Shift"   }, "u", function () awful.util.spawn(cmd_browserlite) end),
                awful.key({ modkey, "Shift"   }, "f", function () awful.util.spawn(cmd_filemanager) end),
                awful.key({ modkey, "Control" }, "r", awesome.restart),
                awful.key({ modkey, "Shift"   }, "q", awesome.quit),

                awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
                awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
                awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
                awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
                awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
                awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
                awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
                awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

                -- Prompt
                awful.key({ modkey },            "r",     function () promptbox[mouse.screen]:run() end),

                awful.key({ modkey }, "x",
                function ()
                   awful.prompt.run({ prompt = "Run Lua code: " },
                   mypromptbox[mouse.screen].widget,
                   awful.util.eval, nil,
                   awful.util.getdir("cache") .. "/history_eval")
                end)
                )

                clientkeys = awful.util.table.join(
                awful.key({ modkey,  }, "t", function (c)
                   if   c.titlebar then awful.titlebar.remove(c)
                   else 
                      awful.titlebar.add(c, { modkey = modkey }) 
                   end
                end),

                awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
                awful.key({ modkey, "Control" }, "f",      awful.client.floating.toggle                     ),
                awful.key({ modkey,   	       }, "q",      function (c) c:kill()                         end),
                awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
                awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
                awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
                awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
                awful.key({ modkey,           }, "m",
                function (c)
                   c.maximized_horizontal = not c.maximized_horizontal
                   c.maximized_vertical   = not c.maximized_vertical
                end)
                )

                -- Compute the maximum number of digit we need, limited to 9
                keynumber = 0
                for s = 1, screen.count() do
                   keynumber = math.min(9, math.max(#tags[s], keynumber));
                end

                -- Bind all key numbers to tags.
                -- Be careful: we use keycodes to make it works on any keyboard layout.
                -- This should map on the top row of your keyboard, usually 1 to 9.
                for i = 1, keynumber do
                   globalkeys = awful.util.table.join(globalkeys,
                   awful.key({ modkey }, "#" .. i + 9,
                   function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                         awful.tag.viewonly(tags[screen][i])
                      end
                   end),
                   awful.key({ modkey, "Control" }, "#" .. i + 9,
                   function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                         awful.tag.viewtoggle(tags[screen][i])
                      end
                   end),
                   awful.key({ modkey, "Shift" }, "#" .. i + 9,
                   function ()
                      if client.focus and tags[client.focus.screen][i] then
                         awful.client.movetotag(tags[client.focus.screen][i])
                      end
                   end),
                   awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                   function ()
                      if client.focus and tags[client.focus.screen][i] then
                         awful.client.toggletag(tags[client.focus.screen][i])
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


                -- {{{ Rules
                awful.rules.rules = {
                   { rule = { }, properties = {
                      focus = true,      size_hints_honor = true,
                      keys = clientkeys, buttons = clientbuttons,
                      border_width = beautiful.border_width,
                      border_color = beautiful.border_normal }
                   },
                   { rule = { class = "MPlayer" 			},	properties = { floating = true, screen = 1 } }, 
                   { rule = { class = "Exe"					}, properties = { floating = true } },		
                   { rule = { class = "Skype"				}, properties = { floating = true } },
                   { rule = { class = "feh" 					},	properties = { floating = true } },
                   { rule = { name = "Firefox Preferences"              }, properties = { floating = true } },
                   { rule = { name = "Downloads"              }, properties = { floating = true } },
                   { rule = { name = "File Operation Progress"}, properties = { floating = true } },
                   { rule = { class = "Acroread" 			},	properties = { tag = tags[2][7] } },
                   { rule = { name = "Google+ Hangouts - Chromium" }, properties = { floating = true } },
                   { rule = { name = "GUVCVIdeo" }, properties = { floating = true } },
                   { rule = { class = "qemu-system-x86_64" }, properties = { floating = true } },
                   { rule = { class = "Virt-manager"}, properties = { floating = true } },
                   { rule = { class = "Pidgin"}, properties = { floating = true } },
                   { rule = { class = "Google-musicmanager"}, properties = { floating = true } },
                   { rule = { name = "Steam"}, properties = { floating = true } },
                   { rule = { class = "org-eclipse-jdt-internal-jarinjarloader-JarRsrcLoader"}, properties = { floating = true } },
                }
                -- }}}


                -- {{{ Signals
                --
                -- {{{ Manage signal handler
                client.add_signal("manage", function (c, startup)
                   -- Add titlebar to floaters, but remove those from rule callback
                   --if awful.client.floating.get(c)
                   --   or awful.layout.get(c.screen) == awful.layout.suit.floating then
                   --   if   c.titlebar then awful.titlebar.remove(c)
                   --   else awful.titlebar.add(c, {modkey = modkey}) end
                   --end

                   -- Enable sloppy focus
                   c:add_signal("mouse::enter", function (c)
                      if  awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                         and awful.client.focus.filter(c) then
                         client.focus = c
                      end
                   end)

                   -- Client placement
                   if not startup then
                      awful.client.setslave(c)

                      if  not c.size_hints.program_position
                         and not c.size_hints.user_position then
                         awful.placement.no_overlap(c)
                         awful.placement.no_offscreen(c)
                      end
                      if awful.client.floating.get(c) then
                         awful.titlebar.add(c, { modkey = modkey })
                         awful.placement.centered(c)
                         awful.placement.no_offscreen(c)
                      end
                   end
                end)
                -- }}}

                -- {{{ Focus signal handlers
                client.add_signal("focus",   function (c) c.border_color = beautiful.border_focus  end)
                client.add_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)
                -- }}}

                -- {{{ Arrange signal handler
                for s = 1, screen.count() do screen[s]:add_signal("arrange", function ()
                   local clients = awful.client.visible(s)
                   local layout = awful.layout.getname(awful.layout.get(s))

                   for _, c in pairs(clients) do -- Floaters are always on top
                      if   awful.client.floating.get(c) or layout == "floating"
                         then if not c.fullscreen then c.above       =  true  end
                      else                          c.above       =  false end
                   end
                end)
             end
             -- }}}
             -- }}}

