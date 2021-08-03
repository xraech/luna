-- Standard awesome library
------------------------------------------------------------
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
dpi = beautiful.xresources.apply_dpi
local gears = require("gears")
require("awful.autofocus")

-- Init Theme
------------------------------------------------------------
theme_name = "luna"
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/theme.lua")

-- Japanese Clock
------------------------------------------------------------
os.setlocale("ja_JP.UTF-8")

-- User modules
------------------------------------------------------------
require("config.keys")
require("config.rules")
require("widgets.startmenu")
require("titlebars")
require("decorations")
require("notifications")
-- Rounded corners
------------------------------------------------------------
if beautiful.border_radius or beautiful.border_radius ~= 0 then
    client.connect_signal("manage", function (c, startup)
	if not awesome.startup then awful.client.setslave(c) end
        if not c.fullscreen then
            c.shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
            end
        end
    end)

    -- Fullscreen clients should not have rounded corners
    client.connect_signal("property::fullscreen", function (c)
        if c.fullscreen then
            c.shape = function(cr, width, height)
                gears.shape.rectangle(cr, width, height)
            end
        else
            c.shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, beautiful.border_radius)
            end
        end
    end)
end

-- Garbage Collection
------------------------------------------------------------
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
