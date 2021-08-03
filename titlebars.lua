local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')

local function colorize_text(text, color)
    return "<span foreground='" .. color .."'>" .. text .. "</span>"
end

client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
    awful.button({ }, 1, function()
	c:emit_signal("request::activate", "titlebar", {raise = true})
	awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
	c:emit_signal("request::activate", "titlebar", {raise = true})
	awful.mouse.client.resize(c)
    end)
    )
    function titlebarbtn(char, color, func)
	return wibox.widget{
	    {
		{
		    font = beautiful.titlebar_font,
		    markup = colorize_text(char, color),
		    widget = wibox.widget.textbox,
		},
		top = dpi(20), bottom = 4, 
		widget = wibox.container.margin
	    },
	    font = beautiful.titlebar_font,
	    bg = color,
	    widget = wibox.container.background,
	    buttons = gears.table.join(
	    awful.button({}, 1, func)),
	    shape = gears.shape.circle
	}
    end

    local minimize = titlebarbtn("", beautiful.xcolor3, function ()
	awful.client.next(1)
	c.minimized = true
    end)
    local maximize = titlebarbtn("", beautiful.xcolor2, function ()
	c.maximized = not c.maximized
	c:raise()
    end)
    local floating = titlebarbtn("", beautiful.xcolor4,
	function () c.floating = not c.floating
    end)
    local close = titlebarbtn("", beautiful.xcolor1, function ()
	c:kill()
    end)

    awful.titlebar(c, {size = beautiful.titlebar_size}) : setup {
	layout = wibox.layout.align.horizontal,
	expand = "none",
	{
	    buttons = buttons,
	    {
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10),
		floating,
	    },
	    left = dpi(10),
	    right = dpi(10),
	    widget = wibox.container.margin,
	},
	{
	    buttons = buttons,
	    {
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10)
	    },
	    left = dpi(10),
	    right = dpi(10),
	    widget = wibox.container.margin,
	},
	{
	    {
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10),
		minimize,
		maximize,
		close
	    },
	    left = dpi(10),
	    right = dpi(10),
	    widget = wibox.container.margin,
	}
    }
end)
