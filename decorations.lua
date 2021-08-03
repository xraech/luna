local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
--local mymainmenu = require("widgets.startmenu")

-- Widgets
mytextclock = wibox.widget.textclock(" %H:%M  %d%A %B ")
mytextclock.align = "center"
mytextclock.valign = "center"
mytextclock.font = "SFNS Display 12"

gstart = wibox.widget.textbox(beautiful.startmenu_icon)


local rounded_shape = function(radius)
    return function(cr, width, height)
	gears.shape.rounded_rect(cr, width, height, radius)
    end
end

local function horizontal_pad(width)
    return wibox.widget{
        forced_width = width,
        layout = wibox.layout.fixed.horizontal
    }
end


screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    -- tag table
    awful.tag(beautiful.tag_names, s, beautiful.tag_styles)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
	screen  = s,
	filter  = awful.widget.taglist.filter.all,
	style   = {
	    shape = rounded_shape(dpi(30))
	},
	layout = {
	    spacing = dpi(6),
	    layout  = wibox.layout.flex.horizontal
	},
	buttons = {
	    awful.button({ }, 1, function(t) t:view_only() end),
	    awful.button({ modkey }, 1, function(t)
		if client.focus then
		    client.focus:move_to_tag(t)
		end
	    end),
	    awful.button({ }, 3, awful.tag.viewtoggle),
	    awful.button({ modkey }, 3, function(t)
		if client.focus then
		    client.focus:toggle_tag(t)
		end
	    end),
	    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
	    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end),
	},
    }

    local tstyle = {
	align = "center",
	valign = "center",
	shape_border_width = 0,
	shape  = rounded_shape(beautiful.l_border_radius)
    }
    local tlayout   = {
	spacing = 10,
	layout  = wibox.layout.fixed.horizontal,
    }

    -- float systray
    s.systray = wibox({	ontop = true, visible = beautiful.systray_vis, position = beautiful.systray_pos, screen = s, x = beautiful.systray_x, y = beautiful.systray_y, width = beautiful.systray_width, height = beautiful.systray_height, type = "normal", shape  = rounded_shape(beautiful.border_radius) })
    s.systray:setup { 
	layout = wibox.layout.align.horizontal,
	wibox.widget.systray(),
    }

    s.mywibox = wibox({ visible = beautiful.main_vis,
    position = beautiful.main_pos,
    screen = s,
    x = beautiful.main_x,
    y = beautiful.main_y,
    width = beautiful.main_width,
    height = beautiful.main_height,
    type = "normal",
    visible = true,
    shape  = rounded_shape(beautiful.border_radius)
    })

    s.startwibox = wibox({ visible = beautiful.start_vis,
    position = beautiful.start_pos,
    screen = s,
    x = beautiful.start_x,
    y = beautiful.start_y,
    width = beautiful.start_width,
    height = beautiful.start_height,
    type = "normal",
    shape  = rounded_shape(beautiful.l_border_radius)
    })

    s.leftwibox = wibox({ visible = beautiful.l_vis,
    position = beautiful.l_pos,
    screen = s,
    x = beautiful.l_x,
    y = beautiful.l_y,
    width = beautiful.l_width,
    height = beautiful.l_height,
    type = "normal",
    shape  = rounded_shape(beautiful.l_border_radius)
    })


    --teste
    local screen_size = awful.screen.focused().geometry.width
    mylist = awful.popup {

	widget = require("newtask")
	{
	    screen   = s,
	    filter   = awful.widget.tasklist.filter.currenttags,
	    buttons  = tasklist_buttons,
	    style = {
		shape = rounded_shape(beautiful.l_border_radius),
	    },
	layout = {
		spacing = 10,
		layout  = wibox.layout.fixed.horizontal
	    },
	    widget_template = 
	    {
		{
		    {
			{
			    {
				id = 'clienticon',
				widget = awful.widget.clienticon,
			    },
			    id = "mat_fg",
			    widget = wibox.container.background
			},
			layout = wibox.layout.align.horizontal,
			{
			    id = 'text_role',
			    font = beautiful.font,
			    widget = wibox.widget.textbox,
			},
		    },
		    left = dpi(8), right = dpi(8),
		    margins = 2,
		    widget = wibox.container.margin
		},
		id = 'background_role',
		forced_height = beautiful.c_height,
		forced_width = dpi(200),
		shape = rounded_shape(beautiful.l_border_radius),
		widget = wibox.container.background,
		create_callback = function(self, c, index, objects)
		    self:get_children_by_id("text_role")[1].client = c
		    self:get_children_by_id("clienticon")[1].client = c
		end,
		update_callback = function(self, c, index, objects)
		    gears.timer.start_new(1/1000, function() 
			awful.placement.top(mylist, {margins = beautiful.start_y})
		    end)
		end,

	    },
	},

	ontop        = false,
	y = beautiful.c_y,
	x = beautiful.c_x,
	shape        = rounded_shape(beautiful.l_border_radius),
    } 

    s.rightwibox = wibox({ visible = beautiful.r_vis,
    position = beautiful.r_pos,
    screen = s,
    x = beautiful.r_x,
    y = beautiful.r_y,
    width = beautiful.r_width,
    height = beautiful.r_height,
    type = "normal",
    shape  = rounded_shape(beautiful.l_border_radius)
    })

    s.startwibox:setup {
	layout = wibox.layout.align.horizontal,
	expand = "none",
	nil,
	--wibox.container.background(wibox.container.margin(gstart, 15, 15, 2, 2), "#FF0000", rounded_shape(beautiful.l_border_radius*30))
	gstart,
	nil,
    }
    s.startwibox:connect_signal("mouse::enter", function()
	s.startwibox.fg = beautiful.xcolor2
    end)
    s.startwibox:connect_signal("mouse::leave", function()
	s.startwibox.fg = beautiful.fg_normal
    end)

    s.leftwibox:setup {
	layout = wibox.layout.align.horizontal,
	wibox.container.background(wibox.container.margin(s.mytaglist, 15, 15, 2, 2), beautiful.bg_normal, rounded_shape(beautiful.l_border_radius))
    }

    s.rightwibox:setup {
	layout = wibox.layout.align.horizontal,
	horizontal_pad(dpi(2)),
        widget = wibox.container.place,
        {
            widget = wibox.container.background,
            bg = beautiful.bg_normal,
            {
                widget = wibox.container.margin,
                left = 10,
                right = 10,
                top = 2,
                bottom = 2,
                mytextclock,
            },
        },
	horizontal_pad(dpi(2)),
    }

    s.padding = { top = beautiful.useless_gap * 2 + beautiful.main_height }
    awful.placement.top(s.mywibox, {margins = beautiful.useless_gap * 2})
end)


-- Force icons
client.connect_signal("manage",
function(c)
    local t = {}
    t["St"] = "/usr/share/icons/McMojave-circle-red/apps/scalable/Terminal.svg"
    t["class2"] = "/path/to/class2/image.png"
    local icon = t[c.class]
    if not icon then
	return
    end
    icon = gears.surface(icon)
    c.icon = icon and icon._native or nil
end)

----test
--
--client.connect_signal("list",
--function(c)
--    awful.placement.top(mylist, {margins = beautiful.useless_gap * 3})
--end)
--
