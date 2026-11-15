-- PaperWM.spoon is pinned in flake.lock and linked into ~/.local/share by
-- home/hammerspoon.nix, so tell hs.loadSpoon where to look for it
package.path = os.getenv("HOME") .. "/.local/share/hammerspoon/Spoons/?.spoon/init.lua;" .. package.path

PaperWM = hs.loadSpoon("PaperWM")

-- layout mirrors dots/niri/config.kdl
PaperWM.window_gap = 7
PaperWM.window_ratios = { 1 / 3, 1 / 2, 2 / 3 } -- widths that cycle_width steps through
hs.window.animationDuration = 0 -- place windows instantly, like `animations { off }`

-- PaperWM changes Space by opening Mission Control and pressing a thumbnail.
-- ISSCli (built in home/hammerspoon.nix) posts a trackpad swipe too fast to
-- animate instead; Mission Control stays as the fallback if that doesn't land
local isscli = os.getenv("HOME") .. "/.local/share/hammerspoon/ISSCli"
local mission_control = PaperWM.space.MissionControl
local mission_control_goto = mission_control.gotoSpace

function mission_control:gotoSpace(space_id)
	if self.moving then return false, "a window move is in progress" end
	local screen = hs.screen(hs.spaces.spaceDisplay(space_id))
	local index = screen and hs.fnutils.indexOf(hs.spaces.allSpaces()[screen:getUUID()], space_id)
	if index and hs.fs.attributes(isscli) then
		-- the swipe lands on whichever display holds the cursor
		if hs.mouse.getCurrentScreen() ~= screen then hs.mouse.absolutePosition(screen:frame().center) end
		hs.task.new(isscli, nil, { "index", tostring(index) }):start()
		-- PaperWM focuses a window next, and doing that before the swipe lands
		-- makes macOS start a slow switch of its own, so wait here (up to 0.5s)
		for _ = 1, 250 do
			if hs.spaces.activeSpaceOnScreen(screen) == space_id then return true end
			hs.timer.usleep(2000)
		end
	end
	return mission_control_goto(self, space_id)
end

-- binds mirror niri, with alt standing in for Mod as it does in aerospace.toml
local mod = { "alt" }
local mod_shift = { "alt", "shift" }

local hotkeys = {
	focus_left = { mod, "h" },
	focus_down = { mod, "j" },
	focus_up = { mod, "k" },
	focus_right = { mod, "l" },

	-- left/right carry the whole column, up/down reorder within it
	swap_left = { mod_shift, "h" },
	swap_down = { mod_shift, "j" },
	swap_up = { mod_shift, "k" },
	swap_right = { mod_shift, "l" },

	full_width = { mod, "f" },
	cycle_width = { mod, "r" },
	decrease_width = { mod, "-" },
	increase_width = { mod, "=" },
	center_window = { { "alt", "ctrl" }, "c" },

	-- no niri binds to copy for these: drop the focused window into the bottom
	-- of the column on its left / pop it back out into a column of its own
	slurp_in = { mod, "i" },
	barf_out = { mod, "o" },
	toggle_stack = { mod, "w" }, -- nearest thing to niri's tabbed columns

	toggle_floating = { mod_shift, "t" },
	refresh_windows = { mod_shift, "r" }, -- re-scan and retile if a window gets lost
}

-- workspaces are Mission Control desktops, counted left to right. moving a
-- window still drives Mission Control: macOS 26 lets nothing else do it
for i = 1, 9 do
	hotkeys["switch_space_" .. i] = { mod, tostring(i) }
	hotkeys["move_window_" .. i] = { mod_shift, tostring(i) }
end

PaperWM:bindHotkeys(hotkeys)

-- niri's `set-column-width "50%"`, which PaperWM has no action for: two such
-- windows and the gap between them fill the screen, like cycle_width's 1/2
hs.hotkey.bind(mod, "s", function()
	local window = hs.window.focusedWindow()
	if not window then return end
	local canvas = PaperWM.windows.getCanvas(window:screen())
	local gap = (PaperWM.windows.getGap("left") + PaperWM.windows.getGap("right")) / 2
	local frame = window:frame()
	frame.w = (canvas.w - gap) / 2
	PaperWM.windows.moveWindow(window, frame)
	PaperWM:tileSpace(hs.spaces.windowSpaces(window)[1])
end)

PaperWM:start()

-- a menu bar strip showing the current Space's windows, the way a bar's
-- workspace widget would on niri: the Space number in an accent-coloured
-- pill, then an app icon per window, columns left to right with a column's
-- rows packed together and floating windows last. the focused window is
-- underlined and the rest dimmed. hover it for names, click to pick a window
local icon_size = 20 -- points; app icons carry about 2pt of clear margin
local icon_step = 18 -- advance per window, eating into that margin
local column_gap = 4 -- extra space between columns
local dim = 0.55 -- opacity of the windows that aren't focused
local max_menu = 70 -- characters of a window title the menu shows
local accent = { list = "System", name = "controlAccentColor" }

local function shorten(text, limit)
	if (utf8.len(text) or #text) <= limit then return text end
	return text:sub(1, (utf8.offset(text, limit) or limit + 1) - 1) .. "…"
end

local function app_name(window)
	local app = window:application()
	return app and app:name() or "?"
end

-- the focused Space's windows: tiled ones column by column, then floating ones
local function space_windows()
	local space = hs.spaces.focusedSpace()
	local columns, floating = {}, {}
	for _, rows in ipairs(PaperWM.state.windowList(space)) do
		local column = {}
		for _, window in ipairs(rows) do table.insert(column, window) end
		table.insert(columns, column)
	end
	for id in pairs(PaperWM.state.is_floating) do
		local window = hs.window.get(id)
		if window and window:isVisible() and hs.fnutils.contains(hs.spaces.windowSpaces(window) or {}, space) then
			table.insert(floating, window)
		end
	end
	return space, columns, floating
end

local function is_focused(window)
	local focused = hs.window.focusedWindow()
	return focused ~= nil and focused:id() == window:id()
end

-- Mission Control's number for a Space, as alt+<n> counts them
local function space_number(space)
	for _, spaces in pairs(hs.spaces.allSpaces() or {}) do
		local index = hs.fnutils.indexOf(spaces, space)
		if index then return index end
	end
end

-- the icon macOS shows for the app, in whatever style (tinted, dark) is set
local icons = {} -- by bundle id, looked up once each
local generic_icon = hs.image.iconForFileType("com.apple.application-bundle")
local function app_icon(window)
	local app = window:application()
	local id = app and app:bundleID()
	if id and icons[id] == nil then icons[id] = hs.image.imageFromAppBundle(id) or false end
	return id and icons[id] or generic_icon
end

-- the strip in words, for its tooltip: "Ghostty · [Firefox] · Emacs/Code"
local function strip_text(columns, floating)
	local function label(window)
		local name = app_name(window)
		return is_focused(window) and "[" .. name .. "]" or name
	end
	local parts = {}
	for _, column in ipairs(columns) do
		table.insert(parts, table.concat(hs.fnutils.imap(column, label), "/"))
	end
	for _, window in ipairs(floating) do table.insert(parts, "(" .. label(window) .. ")") end
	return #parts > 0 and table.concat(parts, " · ") or "no windows"
end

local function strip_image(number, columns, floating)
	local elements, x = {}, 0
	if number then
		local width = number < 10 and 16 or 22
		table.insert(elements, {
			type = "rectangle", action = "fill", fillColor = accent,
			roundedRectRadii = { xRadius = 5, yRadius = 5 },
			frame = { x = 0, y = 2, w = width, h = 16 },
		})
		table.insert(elements, {
			type = "text", text = tostring(number), textFont = ".AppleSystemUIFontBold", textSize = 11,
			textColor = { white = 1 }, textAlignment = "center",
			frame = { x = 0, y = 3.5, w = width, h = 14 },
		})
		x = width + 4
	end

	local function draw(window)
		local focused = is_focused(window)
		table.insert(elements, {
			type = "image", image = app_icon(window), imageAlpha = focused and 1 or dim,
			imageScaling = "scaleProportionally",
			frame = { x = x - (icon_size - icon_step) / 2, y = 0, w = icon_size, h = icon_size },
		})
		if focused then
			table.insert(elements, {
				type = "rectangle", action = "fill", fillColor = accent,
				roundedRectRadii = { xRadius = 1, yRadius = 1 },
				frame = { x = x + 3, y = icon_size, w = icon_step - 6, h = 2 },
			})
		end
		x = x + icon_step
	end
	for i, column in ipairs(columns) do
		if i > 1 then x = x + column_gap end
		hs.fnutils.each(column, draw)
	end
	if #floating > 0 and #columns > 0 then x = x + column_gap * 2 end
	hs.fnutils.each(floating, draw)

	local canvas = hs.canvas.new({ x = 0, y = 0, w = math.max(x, 1), h = icon_size + 2 })
	canvas:appendElements(elements)
	local image = canvas:imageFromCanvas()
	canvas:delete()
	return image
end

local function strip_menu()
	local _, columns, floating = space_windows()
	local items = {}
	local function add(window, indent)
		local title = window:title()
		table.insert(items, {
			title = app_name(window) .. (title ~= "" and " — " .. shorten(title, max_menu) or ""),
			image = app_icon(window):setSize({ w = 16, h = 16 }),
			checked = is_focused(window),
			indent = indent,
			fn = function() window:focus() end, -- PaperWM scrolls it into view
		})
	end
	for _, column in ipairs(columns) do
		for row, window in ipairs(column) do add(window, row > 1 and 1 or 0) end
	end
	if #floating > 0 and #items > 0 then table.insert(items, { title = "-" }) end
	for _, window in ipairs(floating) do add(window, 0) end
	if #items == 0 then items = { { title = "no windows", disabled = true } } end
	return items
end

-- globals, so the menu bar item and watchers aren't garbage collected
WindowStrip = { menubar = hs.menubar.new(true, "paperwm-window-strip") }
WindowStrip.menubar:setMenu(strip_menu)
WindowStrip.update = hs.timer.delayed.new(0.05, function()
	local space, columns, floating = space_windows()
	WindowStrip.menubar:setIcon(strip_image(space_number(space), columns, floating), false)
	WindowStrip.menubar:setTooltip(strip_text(columns, floating))
end)

-- every PaperWM change to a Space (open, close, swap, slurp, move to another
-- Space) ends in a retile, so redraw after each; focus and Space switches
-- can happen without one
local tile_space = PaperWM.tiling.tileSpace
PaperWM.tiling.tileSpace = function(...)
	tile_space(...)
	WindowStrip.update:start()
end
PaperWM.window_filter:subscribe(
	{ hs.window.filter.windowFocused, hs.window.filter.windowDestroyed },
	function() WindowStrip.update:start() end
)
WindowStrip.space_watcher = hs.spaces.watcher.new(function() WindowStrip.update:start() end):start()
WindowStrip.update:start()
