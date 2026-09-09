-- Hyprland Configuration (Lua)
-- Converted from hyprland.conf for Hyprland 0.55+
-- https://wiki.hypr.land/Configuring/Start/

-- ==================
-- MONITOR CONFIG
-- ==================
hl.monitor({
	output = "DP-3",
	mode = "2560x1440@269",
	position = "auto",
	scale = "auto",
})

hl.monitor({
	output = "DP-2",
	mode = "1920x1080@240",
	position = "auto",
	scale = "auto",
})

hl.monitor({
	output = "DP-1",
	mode = "1920x1080@240",
	position = "auto",
	scale = "auto",
})

-- ==================
-- ENVIRONMENT VARS
-- ==================
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")
hl.env("QT_QPA_PLATFORMTHEME_QT6", "gtk3")
hl.env("TERMINAL", "ghostty")

-- ==================
-- STARTUP APPS
-- ==================
hl.on("hyprland.start", function()
	-- hl.exec_cmd() is asynchronous, so the trailing shell '&' is unnecessary.
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd("dms run -d")

	hl.exec_cmd("firefox", { workspace = "1 silent" })
	hl.exec_cmd("spotify", { workspace = "1 silent" })
	hl.exec_cmd("freetube", { workspace = "1 silent" })
	hl.exec_cmd("ghostty -e tmux", { workspace = "2 silent" })
end)

-- ==================
-- INPUT CONFIG
-- ==================
hl.config({
	input = {
		kb_layout = "us",
		numlock_by_default = true,
		-- Focus only follows clicks, matching niri.
		follow_mouse = 0,
	},
})

-- ==================
-- GENERAL LAYOUT
-- ==================
hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 0, -- off in niri

		col = {
			active_border = "rgba(707070ff)",
			inactive_border = "rgba(d0d0d0ff)",
		},

		layout = "scrolling",
	},
})

-- ==================
-- DECORATION
-- ==================
hl.config({
	decoration = {
		rounding = 0,

		active_opacity = 1.0,
		inactive_opacity = 0.9,

		shadow = {
			enabled = true,
			range = 30,
			-- The old config used 5; current Hyprland documents 1-4.
			render_power = 4,
			offset = { 0, 5 },
			color = "rgba(00000070)",
		},
	},
})

-- ==================
-- ANIMATIONS
-- ==================
hl.config({
	animations = {
		enabled = false,
	},
})

-- Kept even though animations are globally disabled, matching the old config.
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "default" })

-- ==================
-- LAYOUTS
-- ==================
hl.config({
	dwindle = {
		preserve_split = true,
	},

	master = {
		mfact = 0.5,
	},
	hl.config({
		scrolling = {
			column_width = 0.5,
			follow_focus = true,

			-- 0 = center focused column
			-- 1 = only scroll enough to fit it onscreen
			focus_fit_method = 1,

			-- Minimum visible fraction before focus causes scrolling.
			follow_min_visible = 0.4,

			-- Widths usable with "colresize +conf/-conf".
			explicit_column_widths = "0.333, 0.5, 0.667, 1.0",

			-- Wrap at the beginning/end of the tape.
			wrap_focus = true,
			--wrap_swapcol = true,

			-- Horizontal niri/PaperWM-style scrolling.
			direction = "right",

			-- A workspace containing only one column fills the display.
			fullscreen_on_one_column = true,
		},
	})
})

-- ==================
-- MISC
-- ==================
hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 0, -- VRR causes flickering on the GTX 1080 / AW2518H.
	},
})

-- ==================
-- WINDOW RULES
-- ==================
hl.window_rule({
	match = { class = [[^(org\.wezfurlong\.wezterm)$]] },
	tile = true,
})

hl.window_rule({
	match = { class = [[^(org\.gnome\.)]] },
	rounding = 12,
})

hl.window_rule({
	match = { class = [[^(org\.gnome\.)]] },
	border_size = 0,
})

hl.window_rule({
	match = { class = [[^(gnome-control-center)$]] },
	tile = true,
})
hl.window_rule({
	match = { class = [[^(pavucontrol)$]] },
	tile = true,
})
hl.window_rule({
	match = { class = [[^(nm-connection-editor)$]] },
	tile = true,
})

hl.window_rule({
	match = { class = [[^(gnome-calculator)$]] },
	float = true,
})
hl.window_rule({
	match = { class = [[^(galculator)$]] },
	float = true,
})
hl.window_rule({
	match = { class = [[^(blueman-manager)$]] },
	float = true,
})
hl.window_rule({
	match = { class = [[^(org\.gnome\.Nautilus)$]] },
	float = true,
})
-- hl.window_rule({
--     match = { class = [[^(steam)$]] },
--     float = true,
-- })
hl.window_rule({
	match = { class = [[^(xdg-desktop-portal)$]] },
	float = true,
})

hl.window_rule({
	match = { class = [[^(org\.wezfurlong\.wezterm)$]] },
	border_size = 0,
})
hl.window_rule({
	match = { class = [[^(Alacritty)$]] },
	border_size = 0,
})
hl.window_rule({
	match = { class = [[^(zen)$]] },
	border_size = 0,
})
hl.window_rule({
	match = { class = [[^(com\.mitchellh\.ghostty)$]] },
	border_size = 0,
})
hl.window_rule({
	match = { class = [[^(kitty)$]] },
	border_size = 0,
})

hl.window_rule({
	match = {
		class = [[^(firefox)$]],
		title = [[^(Picture-in-Picture)$]],
	},
	float = true,
})
hl.window_rule({
	match = { class = [[^(zoom)$]] },
	float = true,
})

hl.window_rule({
	match = {
		float = false,
		focus = false,
	},
	opacity = "0.9 0.9",
})

-- hl.layer_rule({
--     match = { namespace = [[^(quickshell)$]] },
--     no_anim = true,
-- })

-- ==================
-- KEYBINDINGS
-- ==================
local mod = "SUPER"

hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- === Application Launchers ===
hl.bind(mod .. " + T", hl.dsp.exec_cmd("ghostty -e tmux"))
hl.bind(mod .. " + space", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))
hl.bind(mod .. " + V", hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
hl.bind(mod .. " + M", hl.dsp.exec_cmd("dms ipc call processlist toggle"))
hl.bind(mod .. " + comma", hl.dsp.exec_cmd("dms ipc call settings toggle"))
hl.bind(mod .. " + N", hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("dms ipc call notepad toggle"))
hl.bind(mod .. " + Y", hl.dsp.exec_cmd("dms ipc call dankdash wallpaper"))
hl.bind(mod .. " + TAB", hl.dsp.exec_cmd("dms ipc call hypr toggleOverview"))

-- === Cheat sheet ===
hl.bind(mod .. " + SHIFT + Slash", hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland"))

-- === Security ===
hl.bind(mod .. " + ALT + L", hl.dsp.exec_cmd("dms ipc call lock lock"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("dms ipc call processlist toggle"))

-- === Audio Controls ===
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("dms ipc call audio increment 3"), {
	repeating = true,
	locked = true,
})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("dms ipc call audio decrement 3"), {
	repeating = true,
	locked = true,
})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("dms ipc call audio mute"), {
	locked = true,
})
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("dms ipc call audio micmute"), {
	locked = true,
})

-- === Brightness Controls ===
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[dms ipc call brightness increment 5 ""]]), {
	repeating = true,
	locked = true,
})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[dms ipc call brightness decrement 5 ""]]), {
	repeating = true,
	locked = true,
})

-- === Window Management ===
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mod .. " + SHIFT + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + W", hl.dsp.group.toggle())

-- === Focus Navigation ===
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

-- === Window Movement ===
hl.bind(mod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- === Column Navigation ===
-- NOTE: In the old dispatcher, `focuswindow first` / `focuswindow last`
-- treated "first" and "last" as class regexes. These two bindings preserve
-- that literal behavior rather than inventing first/last-window semantics.
hl.bind(mod .. " + Home", hl.dsp.focus({ window = "class:first" }))
hl.bind(mod .. " + End", hl.dsp.focus({ window = "class:last" }))

-- === Monitor Navigation ===
hl.bind(mod .. " + CTRL + left", hl.dsp.focus({ monitor = "left" }))
hl.bind(mod .. " + CTRL + right", hl.dsp.focus({ monitor = "right" }))
hl.bind(mod .. " + CTRL + H", hl.dsp.focus({ monitor = "left" }))
hl.bind(mod .. " + CTRL + J", hl.dsp.focus({ monitor = "down" }))
hl.bind(mod .. " + CTRL + K", hl.dsp.focus({ monitor = "up" }))
hl.bind(mod .. " + CTRL + L", hl.dsp.focus({ monitor = "right" }))

-- === Move to Monitor ===
hl.bind(mod .. " + SHIFT + CTRL + left", hl.dsp.window.move({ monitor = "left", follow = true }))
hl.bind(mod .. " + SHIFT + CTRL + down", hl.dsp.window.move({ monitor = "down", follow = true }))
hl.bind(mod .. " + SHIFT + CTRL + up", hl.dsp.window.move({ monitor = "up", follow = true }))
hl.bind(mod .. " + SHIFT + CTRL + right", hl.dsp.window.move({ monitor = "right", follow = true }))
hl.bind(mod .. " + SHIFT + CTRL + H", hl.dsp.window.move({ monitor = "left", follow = true }))
hl.bind(mod .. " + SHIFT + CTRL + J", hl.dsp.window.move({ monitor = "down", follow = true }))
hl.bind(mod .. " + SHIFT + CTRL + K", hl.dsp.window.move({ monitor = "up", follow = true }))
hl.bind(mod .. " + SHIFT + CTRL + L", hl.dsp.window.move({ monitor = "right", follow = true }))

-- === Workspace Navigation ===
hl.bind(mod .. " + Page_Down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + Page_Up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + U", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + I", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + CTRL + down", hl.dsp.window.move({ workspace = "e+1", follow = true }))
hl.bind(mod .. " + CTRL + up", hl.dsp.window.move({ workspace = "e-1", follow = true }))
hl.bind(mod .. " + CTRL + U", hl.dsp.window.move({ workspace = "e+1", follow = true }))
hl.bind(mod .. " + CTRL + I", hl.dsp.window.move({ workspace = "e-1", follow = true }))

-- === Move Workspaces ===
hl.bind(mod .. " + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "e+1", follow = true }))
hl.bind(mod .. " + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "e-1", follow = true }))
hl.bind(mod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "e+1", follow = true }))
hl.bind(mod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "e-1", follow = true }))

-- === Mouse Wheel Navigation ===
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e+1", follow = true }))
hl.bind(mod .. " + CTRL + mouse_up", hl.dsp.window.move({ workspace = "e-1", follow = true }))

-- === Numbered Workspaces ===
for i = 1, 9 do
	hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end

-- === Move to Numbered Workspaces ===
for i = 1, 9 do
	hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = true }))
end

-- === Column Management ===
hl.bind(mod .. " + bracketleft", hl.dsp.layout("preselect l"))
hl.bind(mod .. " + bracketright", hl.dsp.layout("preselect r"))

-- === Sizing & Layout ===
hl.bind(mod .. " + R", hl.dsp.layout("togglesplit"))

-- The source used: resizeactive, exact 100%
-- Current Lua resize expects explicit numeric x/y sizes, so interpret that as
-- 100% of the active monitor's logical size.
local function resize_to_monitor()
	local monitor = hl.get_active_monitor()
	if not monitor then
		return
	end

	local scale = monitor.scale or 1
	hl.dispatch(hl.dsp.window.resize({
		x = math.floor(monitor.width / scale),
		y = math.floor(monitor.height / scale),
		relative = false,
	}))
end

hl.bind(mod .. " + CTRL + F", resize_to_monitor)

-- === Move/resize windows with mainMod + LMB/RMB and dragging ===
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), {
	mouse = true,
	description = "Move window",
})
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), {
	mouse = true,
	description = "Resize window",
})

-- === Resize by keycode ===
hl.bind(mod .. " + code:20", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), {
	description = "Expand window left",
})
hl.bind(mod .. " + code:21", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), {
	description = "Shrink window left",
})

-- === Manual Sizing ===
-- Lua's resize dispatcher takes numeric deltas, so percentage resizing is
-- computed from the active window's current size at keypress time.
local function resize_percent(x_fraction, y_fraction)
	return function()
		local window = hl.get_active_window()
		if not window then
			return
		end

		hl.dispatch(hl.dsp.window.resize({
			x = math.floor(window.size.x * x_fraction),
			y = math.floor(window.size.y * y_fraction),
			relative = true,
		}))
	end
end

hl.bind(mod .. " + minus", resize_percent(-0.10, 0), { repeating = true })
hl.bind(mod .. " + equal", resize_percent(0.10, 0), { repeating = true })
hl.bind(mod .. " + SHIFT + minus", resize_percent(0, -0.10), { repeating = true })
hl.bind(mod .. " + SHIFT + equal", resize_percent(0, 0.10), { repeating = true })

-- === Screenshots ===
-- Flameshot, same as the sway/i3 setup. Its GUI covers region select, full
-- screen, copy and save (save path lives in ~/.config/flameshot/flameshot.ini).
hl.bind(mod .. " + P", hl.dsp.exec_cmd("flameshot gui"))
hl.bind("Print", hl.dsp.exec_cmd("flameshot gui"))
hl.bind("XF86Launch1", hl.dsp.exec_cmd("flameshot gui"))

-- === System Controls ===
-- Hyprland's current docs recommend dispatching DPMS from a short timer rather
-- than directly from the key event.
local function dpms_off()
	hl.timer(function()
		hl.dispatch(hl.dsp.dpms({ action = "disable" }))
	end, {
		timeout = 500,
		type = "oneshot",
	})
end

hl.bind(mod .. " + SHIFT + P", dpms_off)

-- Original source was: source = ./dms/cursor.conf
-- Lua can require another Lua config after it has been converted, e.g.:
-- require("dms.cursor")
