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
