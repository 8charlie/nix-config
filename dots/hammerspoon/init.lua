require("hs.ipc") -- TEMP for testing
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

-- a menu bar strip naming the current Space's windows, the way a bar's
-- workspace widget would on niri: "2 │ Ghostty · [Firefox] · Emacs/Code".
-- columns read left to right, "/" joins a column's rows, the focused window
-- is in brackets and floating ones in parens. click it to pick a window
local max_name = 12 -- characters of an app name the strip shows
local max_strip = 60 -- longer than this and it names only the focused window
local max_menu = 70 -- characters of a window title the menu shows

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

local function strip_title()
	local space, columns, floating = space_windows()
	local number
	for _, spaces in pairs(hs.spaces.allSpaces() or {}) do
		number = number or hs.fnutils.indexOf(spaces, space)
	end

	local parts, count, focused_at, focused_name = {}, 0, nil, nil
	local function label(window)
		count = count + 1
		local name = shorten(app_name(window), max_name)
		if not is_focused(window) then return name end
		focused_at, focused_name = count, name
		return "[" .. name .. "]"
	end
	for _, column in ipairs(columns) do
		table.insert(parts, table.concat(hs.fnutils.imap(column, label), "/"))
	end
	for _, window in ipairs(floating) do table.insert(parts, "(" .. label(window) .. ")") end

	local windows = count == 0 and "–" or table.concat(parts, " · ")
	if (utf8.len(windows) or #windows) > max_strip then
		windows = focused_at and string.format("%s (%d/%d)", focused_name, focused_at, count)
			or string.format("%d windows", count)
	end
	return number and (number .. " │ " .. windows) or windows
end

local function strip_menu()
	local _, columns, floating = space_windows()
	local items = {}
	local function add(window, indent)
		local title = window:title()
		table.insert(items, {
			title = app_name(window) .. (title ~= "" and " — " .. shorten(title, max_menu) or ""),
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
WindowStrip.menu = strip_menu -- TEMP
WindowStrip.update = hs.timer.delayed.new(0.05, function() WindowStrip.menubar:setTitle(strip_title()) end)

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
