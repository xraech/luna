local naughty = require("naughty")
local gears = require("gears")
local wibox = require("wibox")
local ruled = require("ruled")
local beautiful = require('beautiful')

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
	urgency = "critical",
	title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
	message = message
    }
end)

local rainbow_stripe = wibox.widget {
    {
	bg = beautiful.xcolor1,
	widget = wibox.container.background
    },
    {
	bg = beautiful.xcolor5,
	widget = wibox.container.background
    },
    {
	bg = beautiful.xcolor4,
	widget = wibox.container.background
    },
    {
	bg = beautiful.xcolor6,
	widget = wibox.container.background
    },
    {
	bg = beautiful.xcolor2,
	widget = wibox.container.background
    },
    {
	bg = beautiful.xcolor3,
	widget = wibox.container.background
    },
    layout = wibox.layout.flex.horizontal
}

ruled.notification.connect_signal('request::rules', function()
    local custom_notification_icon = wibox.widget {
	align = "center",
	valign = "center",
	widget = naughty.widget.icon
    }
    -- All notifications
    ruled.notification.append_rule {
	id = "global",
	rule = {},
	properties = {
	    font = beautiful.notification_font,
	    bg = beautiful.notification_bg, 
	    fg = beautiful.notification_fg,
	    margin = beautiful.notification_margin,
	    padding = beautiful.notification_padding,
	    position = beautiful.notification_position,
	    implicit_timeout = beautiful.notification_timeout,
	    widget_template = {
		{
		    {
			{
			    {
				{
				    {
					{
					    widget = custom_notification_icon,
					},
					margins = beautiful.notification_margin,
					widget  = wibox.container.margin,
				    },
				    bg = beautiful.bg_normal,
				    widget  = wibox.container.background,
				},
				{
				    rainbow_stripe,
				    forced_height = dpi(4),
				    widget = wibox.container.background
				},
				{
				    {
					{
					    {
						align = "center",
						widget = naughty.widget.title,
					    },
					    {
						align = "center",
						widget = naughty.widget.message,
					    },
					    layout  = wibox.layout.fixed.vertical,
					},
					margins = beautiful.notification_margin,
					widget  = wibox.container.margin,
				    },
				    bg = notification_bg,
				    widget  = wibox.container.background,
				},
				layout  = wibox.layout.fixed.vertical,
			    },
			    bg = "#00000000",
			    id     = "background_role",
			    widget = naughty.container.background,
			},
			strategy = "min",
			width    = dpi(200),
			widget   = wibox.container.constraint,
		    },
		    strategy = "max",
		    width    = beautiful.notification_max_width or dpi(500),
		    widget   = wibox.container.constraint,
		},
		bg = notification_bg,
		--shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, beautiful.border_radius or 0) end,
		shape = gears.shape.rectangle,
		widget = wibox.container.background
	    }
	}
    }

    -- Critical notifs
    ruled.notification.append_rule {
	rule       = { urgency = 'critical' },
	properties = { 
	    font = beautiful.notification_urgent_font,
	    bg = beautiful.notification_urgent_bg, 
	    fg = beautiful.notification_urgent_fg,
	    position = beautiful.notification_urgent_position,
	    implicit_timeout = beautiful.notification_urgent_timeout,
	}
    }

    -- Low notifs
    ruled.notification.append_rule {
	rule       = { urgency = 'low' },
	properties = { 
	    implicit_timeout = 2
	}
    }
end)

naughty.connect_signal("request::display", function(n) naughty.layout.box { notification = n } end)
