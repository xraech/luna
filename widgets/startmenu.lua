local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")

terminal = "st"
modkey = "Mod4"
editor = os.getenv("EDITOR") or "vi"
editor_cmd =  terminal .. " -e " .. editor

myawesomemenu = {
    { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

-- {{{ Menu
mymainmenu = awful.menu(
{ 
    items = { 
	{ "awesome", myawesomemenu, beautiful.awesome_icon },
	{ "open terminal", terminal }
    }
})
