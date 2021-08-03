local awful = require("awful")

local client_placement_f = awful.placement.no_overlap + awful.placement.no_offscreen
local mon_width = awful.screen.focused().geometry.width
local mon_height = awful.screen.focused().geometry.height
awful.rules.rules = {
    {
        id         = "global",
        rule       = { },
        properties = {
	    floating  = false,
	    size_hints_honor = false,
	    honor_workare = true,
	    honor_padding = true,
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.focused,
        },
    },

    {
        id       = "floating",
        rule_any = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer",
		"Wine"
            },
            name    = {
                "Event Tester",  -- xev.
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    },

    -- Add titlebars to normal clients and dialogs
    { id = "titlebars", rule_any   = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },
    -- Discord & Messengers
    { rule = { class = "discord" }, properties = { screen = 1, tag = awful.screen.focused().tags[3], titlebars_enabled = true } },
    -- Steam
    { rule = { class = "Steam", name = "Steam" }, properties = { screen = 1, tag = awful.screen.focused().tags[4], titlebars_enabled = false, floating = true, x = 100, y = 100 } },
    { rule = { class = "Steam", name = "Friends List" }, properties = { screen = 1, tag = awful.screen.focused().tags[4], titlebars_enabled = false, floating = true, x = mon_width-500, y = 100 } },
    -- Streaming
    { rule = { class = "obs" }, properties = { screen = 1, tag = awful.screen.focused().tags[6], titlebars_enabled = false, floating = true } },
    -- Games
    { rule_any = { class = { "Terraria.bin.x86", "yuzu" } }, properties = { screen = 1, tag = awful.screen.focused().tags[4], titlebars_enabled = false, floating = true, switch_to_tags = true } },
    { rule_any = { class = { "terraria.exe", "Terraria.exe", "steam_app_105600" } }, properties = { screen = 1, tag = awful.screen.focused().tags[4], titlebars_enabled = false, floating = false, switch_to_tags = true } },
    -- Deluge & Others
    { rule = { class = "Deluge" }, properties = { screen = 1, tag = awful.screen.focused().tags[5] } },
    { rule = { class = "Sxiv" }, properties = { screen = 1, width = mon_width/1.5, height = mon_height/1.5, x = mon_width/2 - (mon_width/1.5)/2, y = mon_height/2 - (mon_height/1.5)/2 } },
    -- Remove from my view
    { rule = { class = "bluetoothst" }, properties = { screen = 1, tag = awful.screen.focused().tags[5] } },
    -- Browsers
    { rule = { class = "Firefox" }, properties = { screen = 1, tag = awful.screen.focused().tags[2], switch_to_tags = true, titlebars_enabled = true } },
    -- Dialogues
    {
        rule_any = { type = { "dialog", }, role = { "GtkFileChooserDialog", "conversation", } },
        properties = { screen = 1, titlebars_enabled = false, floating = true },
        callback = function (c) awful.placement.centered(c, { honor_padding = true, honor_workarea = true }) end
    }
}
