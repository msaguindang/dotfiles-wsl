-- WezTerm Configuration for Windows + WSL2
-- WezTerm runs on Windows, default_prog launches WSL. Uses WebGpu renderer.
-- WezTerm automatically sets TERM_PROGRAM=WezTerm for bash scripts

local wezterm = require("wezterm")
local act = wezterm.action

-- Use config builder if available
local config = wezterm.config_builder and wezterm.config_builder() or {}

-- Add WezTerm Sessions plugin
local sessions = wezterm.plugin.require("https://github.com/abidibo/wezterm-sessions")
-- Don't apply default keybindings, we'll define our own to match our Ctrl+Alt scheme

-- ========================================
-- UI APPEARANCE CONFIGURATION
-- ========================================

-- Color scheme
config.color_scheme = "Tokyo Night"

-- Font configuration with fallbacks
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", weight = "Medium" },
	{ family = "JetBrains Mono", weight = "Medium" },
	{ family = "Cascadia Code", weight = "Regular" },
	{ family = "Fira Code", weight = "Regular" },
	{ family = "Monospace", weight = "Regular" },
})
config.font_size = 10.0
config.line_height = 1.0

-- Font features (enable ligatures)
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

-- Window appearance
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.85
config.text_background_opacity = 1.0

-- Padding around the entire window
config.window_padding = {
	left = "1cell",
	right = "1cell",
	top = "0.5cell",
	bottom = "0.5cell",
}

-- Inactive pane dimming for better focus
config.inactive_pane_hsb = {
	saturation = 0.8,
	brightness = 0.3,
}

-- Tab bar configuration
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.tab_max_width = 32

-- Tab bar font size
config.window_frame = {
	font = wezterm.font({ family = "Iosevka Nerd Font", weight = "Bold" }),
	font_size = 8.0,
}

-- Cursor configuration
config.default_cursor_style = "BlinkingBlock"
config.cursor_thickness = 2
config.cursor_blink_rate = 1200
config.animation_fps = 60
config.cursor_blink_ease_in = "EaseInOut"
config.cursor_fade_in_duration_ms = 600
config.cursor_fade_out_duration_ms = 600
config.cursor_blink_ease_out = "EaseInOut"

-- Custom color overrides for the cursor
config.colors = {
	cursor_bg = "#ff9e64", -- High-contrast Tokyo Night Orange
	cursor_fg = "black",
	cursor_border = "#ff9e64",
	split = "#3b4261", -- Subtle Tokyo Night border gap for split panes
}

-- Scrollbar
config.enable_scroll_bar = false
config.scrollback_lines = 10000

-- Bell/notification - disabled
config.audible_bell = "Disabled"
config.visual_bell = {
	fade_in_function = "EaseIn",
	fade_in_duration_ms = 0,
	fade_out_function = "EaseOut",
	fade_out_duration_ms = 0,
}

-- ========================================
-- WINDOWS-SPECIFIC PERFORMANCE SETTINGS
-- ========================================
-- WebGpu performs better than OpenGL on Windows
config.front_end = "WebGpu"
-- Conservative frame rate for Windows
config.max_fps = 60
-- WebGpu power preference
config.webgpu_power_preference = "HighPerformance"

-- Window behavior
config.window_close_confirmation = "AlwaysPrompt"
config.adjust_window_size_when_changing_font_size = false
config.use_resize_increments = false
config.warn_about_missing_glyphs = false

-- ========================================
-- DEFAULT SHELL CONFIGURATION (WSL2)
-- ========================================
-- Launch WSL as the default program
config.default_prog = { "wsl.exe", "--cd", "~" }

-- ========================================
-- KEYBINDINGS (CTRL+ALT SCHEME)
-- ========================================
-- NOTE: All keybindings use Ctrl+Alt or Ctrl+Alt+Shift
-- These bindings work on Windows + WSL without i3 conflicts

config.keys = {
	-- ========================================
	-- PANE SPLITTING
	-- ========================================
	-- Vertical split (side-by-side)
	{
		key = "\\",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},

	-- Horizontal split (top-bottom)
	{
		key = "-",
		mods = "CTRL|ALT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- ========================================
	-- PANE NAVIGATION (VIM-STYLE: H/J/K/L)
	-- ========================================
	{ key = "h", mods = "CTRL|ALT", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CTRL|ALT", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CTRL|ALT", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CTRL|ALT", action = wezterm.action.ActivatePaneDirection("Right") },

	-- ========================================
	-- PANE SWAPPING (I3-STYLE: H/J/K/L)
	-- ========================================
	-- Swap with adjacent pane (requires version 20240127+)
	{
		key = "h",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local tab = win:active_tab()
			local target = tab:get_pane_direction("Left")
			if target then
				local panes = tab:panes()
				local target_idx = nil
				for i, p in ipairs(panes) do
					if p.pane_id == target.pane_id then
						target_idx = i - 1
						break
					end
				end
				if target_idx then
					tab:swap_active_with_index(target_idx, true)
				end
			end
		end),
	},
	{
		key = "j",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local tab = win:active_tab()
			local target = tab:get_pane_direction("Down")
			if target then
				local panes = tab:panes()
				local target_idx = nil
				for i, p in ipairs(panes) do
					if p.pane_id == target.pane_id then
						target_idx = i - 1
						break
					end
				end
				if target_idx then
					tab:swap_active_with_index(target_idx, true)
				end
			end
		end),
	},
	{
		key = "k",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local tab = win:active_tab()
			local target = tab:get_pane_direction("Up")
			if target then
				local panes = tab:panes()
				local target_idx = nil
				for i, p in ipairs(panes) do
					if p.pane_id == target.pane_id then
						target_idx = i - 1
						break
					end
				end
				if target_idx then
					tab:swap_active_with_index(target_idx, true)
				end
			end
		end),
	},
	{
		key = "l",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action_callback(function(win, pane)
			local tab = win:active_tab()
			local target = tab:get_pane_direction("Right")
			if target then
				local panes = tab:panes()
				local target_idx = nil
				for i, p in ipairs(panes) do
					if p.pane_id == target.pane_id then
						target_idx = i - 1
						break
					end
				end
				if target_idx then
					tab:swap_active_with_index(target_idx, true)
				end
			end
		end),
	},

	-- ========================================
	-- PANE RESIZING (CTRL+ALT+ARROW — no conflict with swap or navigation)
	-- ========================================
	{ key = "LeftArrow", mods = "CTRL|ALT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "DownArrow", mods = "CTRL|ALT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
	{ key = "UpArrow", mods = "CTRL|ALT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "RightArrow", mods = "CTRL|ALT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },

	-- ========================================
	-- TAB MANAGEMENT
	-- ========================================
	-- New tab
	{
		key = "t",
		mods = "CTRL|ALT",
		action = wezterm.action.SpawnTab("CurrentPaneDomain"),
	},

	-- Close current pane/tab
	{
		key = "w",
		mods = "CTRL|ALT",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},

	-- Navigate tabs
	{
		key = "[",
		mods = "CTRL|ALT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		key = "]",
		mods = "CTRL|ALT",
		action = wezterm.action.ActivateTabRelative(1),
	},

	-- ========================================
	-- WORKSPACE MANAGEMENT
	-- ========================================
	-- Show workspace selector
	{
		key = "w",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},

	-- Create/switch to new workspace
	{
		key = "n",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.SwitchToWorkspace,
	},

	-- Rename current workspace
	{
		key = "r",
		mods = "CTRL|ALT|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new workspace name",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},

	-- Navigate workspaces
	{
		key = "PageUp",
		mods = "CTRL|ALT",
		action = wezterm.action_callback(function(window, pane)
			local workspaces = wezterm.mux.get_workspace_names()
			if not workspaces or #workspaces < 2 then
				return
			end
			local current = window:active_workspace()
			local idx = 1
			for i, name in ipairs(workspaces) do
				if name == current then
					idx = i
					break
				end
			end
			local prev = idx - 1
			if prev < 1 then
				prev = #workspaces
			end
			window:perform_action(wezterm.action.SwitchToWorkspace({ name = workspaces[prev] }), pane)
		end),
	},
	{
		key = "PageDown",
		mods = "CTRL|ALT",
		action = wezterm.action_callback(function(window, pane)
			local workspaces = wezterm.mux.get_workspace_names()
			if not workspaces or #workspaces < 2 then
				return
			end
			local current = window:active_workspace()
			local idx = 1
			for i, name in ipairs(workspaces) do
				if name == current then
					idx = i
					break
				end
			end
			local nexti = idx + 1
			if nexti > #workspaces then
				nexti = 1
			end
			window:perform_action(wezterm.action.SwitchToWorkspace({ name = workspaces[nexti] }), pane)
		end),
	},

	-- ========================================
	-- SESSION MANAGEMENT (wezterm-sessions plugin)
	-- ========================================
	-- Save current session (layout, directories, processes)
	{
		key = "s",
		mods = "CTRL|ALT|SHIFT",
		action = act({ EmitEvent = "save_session" }),
	},

	-- Load a saved session (select from list)
	{
		key = "l",
		mods = "CTRL|ALT|SHIFT",
		action = act({ EmitEvent = "load_session" }),
	},

	-- Restore session matching current workspace name
	{
		key = "o",
		mods = "CTRL|ALT|SHIFT",
		action = act({ EmitEvent = "restore_session" }),
	},

	-- Delete a saved session
	{
		key = "d",
		mods = "CTRL|ALT|SHIFT",
		action = act({ EmitEvent = "delete_session" }),
	},

	-- Edit session state (opens in $EDITOR)
	{
		key = "e",
		mods = "CTRL|ALT|SHIFT",
		action = act({ EmitEvent = "edit_session" }),
	},

	-- ========================================
	-- FONT SIZING
	-- ========================================
	{ key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = wezterm.action.DecreaseFontSize },
	{ key = "0", mods = "CTRL", action = wezterm.action.ResetFontSize },

	-- ========================================
	-- FULLSCREEN
	-- ========================================
	{ key = "F11", mods = "NONE", action = wezterm.action.ToggleFullScreen },

	-- ========================================
	-- TAB BAR TOGGLE
	-- ========================================
	{
		key = "b",
		mods = "CTRL|ALT",
		action = wezterm.action_callback(function(window, pane)
			local overrides = window:get_config_overrides() or {}
			if overrides.hide_tab_bar_if_only_one_tab == false then
				overrides.hide_tab_bar_if_only_one_tab = true
			else
				overrides.hide_tab_bar_if_only_one_tab = false
			end
			window:set_config_overrides(overrides)
		end),
	},

	-- ========================================
	-- COPY/PASTE (STANDARD)
	-- ========================================
	{ key = "c", mods = "CTRL|SHIFT", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL|SHIFT", action = wezterm.action.PasteFrom("Clipboard") },

	-- ========================================
	-- SEARCH & SELECTION
	-- ========================================
	-- Enter copy mode (vim-style selection/copy)
	-- Use v/V to select text, y to yank
	{ key = "x", mods = "CTRL|ALT|SHIFT", action = wezterm.action.ActivateCopyMode },

	-- Search current viewport
	{ key = "f", mods = "CTRL|SHIFT", action = wezterm.action.Search("CurrentSelectionOrEmptyString") },

	-- Quick Select (copy recognized patterns like URLs/Git hashes)
	{ key = "Space", mods = "CTRL|SHIFT", action = wezterm.action.QuickSelect },
}

-- ========================================
-- UI EVENT HANDLERS & STATUS CUSTOMIZATION
-- ========================================

-- Clear the default left status (which defaults to injecting the workspace name/window title)
wezterm.on("update-status", function(window, pane)
	window:set_left_status("")
end)

-- Enhanced Powerline status bar with CWD and Remote Context
wezterm.on("update-right-status", function(window, pane)
	-- Smart Cursor Override for Gemini CLI
	local overrides = window:get_config_overrides() or {}
	local process_info = pane:get_foreground_process_info()
	if process_info and process_info.name:match("([^/]+)$") == "gemini" then
		overrides.colors = {
			cursor_bg = "#0db9d7", -- Vibrant Cyan for Gemini
			cursor_fg = "black",
			cursor_border = "#0db9d7",
		}
		overrides.default_cursor_style = "BlinkingBlock"
	else
		overrides.colors = nil
		overrides.default_cursor_style = nil
	end
	window:set_config_overrides(overrides)

	-- WezTerm format array
	local elements = {}

	-- Add Foundry Branding - REMOVED

	-- Remote Context
	local user = os.getenv("USER") or os.getenv("LOGNAME") or os.getenv("USERNAME") or "user"
	local host = wezterm.hostname()
	local domain = pane:get_domain_name() or "local"

	local context_fg = "#73daca" -- Soft Teal (Local)
	local context_icon = "󰌢"

	if domain:match("WSL") then
		context_fg = "#e0af68" -- Soft Gold (WSL)
		context_icon = ""
		local domain_host = domain:gsub("^WSL[:%s]*", "")
		if domain_host ~= "" and domain_host ~= "local" then
			host = domain_host
		end
	elseif domain:match("SSH") then
		context_fg = "#c53b53" -- Muted Red (SSH)
		context_icon = "󰒋"
		local domain_host = domain:gsub("^SSH[:%s]*", "")
		if domain_host ~= "" and domain_host ~= "local" then
			host = domain_host
		end
	end

	-- Dynamically determine previous background color for seamless powerline chaining
	local prev_bg = "#1a1b26" -- Default to tab bar background
	for i = #elements, 1, -1 do
		if elements[i].Background and elements[i].Background.Color then
			prev_bg = elements[i].Background.Color
			break
		end
	end

	-- Add Remote Context Widget
	local widget_bg = "#3b4261" -- Tokyo Night gray/blue
	table.insert(elements, { Foreground = { Color = widget_bg } })
	table.insert(elements, { Background = { Color = prev_bg } })
	table.insert(elements, { Text = "" })
	table.insert(elements, { Foreground = { Color = context_fg } })
	table.insert(elements, { Background = { Color = widget_bg } })
	table.insert(elements, { Attribute = { Intensity = "Bold" } })
	table.insert(elements, { Attribute = { Italic = true } })
	table.insert(elements, { Text = " " .. context_icon .. " " .. user .. "@" .. host .. " " })
	table.insert(elements, { Attribute = { Italic = false } })
	table.insert(elements, { Attribute = { Intensity = "Normal" } })

	window:set_right_status(wezterm.format(elements))
end)

-- Window title customization
wezterm.on("format-window-title", function(tab, pane, tabs, panes, config)
	local zoomed = ""
	if tab.active_pane.is_zoomed then
		zoomed = "[Z] "
	end

	local index = ""
	if #tabs > 1 then
		index = string.format("[%d/%d] ", tab.tab_index + 1, #tabs)
	end

	-- Elevate alerts to the window title for visibility
	local window_alert = ""
	local emojis = { "✋", "👋", "⏳", "⚠️", "💬", "✅", "❌", "✨", "🤖" }
	for _, t in ipairs(tabs) do
		for _, p in ipairs(t.panes) do
			local p_title = p.title or ""
			for _, emoji in ipairs(emojis) do
				if p_title:find(emoji) then
					window_alert = emoji .. " "
					break
				end
			end
			if window_alert ~= "" then
				break
			end
		end
		if window_alert ~= "" then
			break
		end
	end

	-- Use foreground process name to prevent stuck titles
	local title = ""
	local process_name = tab.active_pane.foreground_process_name or ""
	if process_name ~= "" then
		title = process_name:match("([^/\\]+)$") or process_name
	else
		title = tab.active_pane.title or ""
	end

	return window_alert .. zoomed .. index .. title
end)

-- Tab title customization
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	-- Tokyo Night Background to hide the "tab" boxes
	local background = "#1a1b26"
	local inactive_fg = "#565f89"
	local active_fg = "#7aa2f7"
	local hover_fg = "#c0caf5"
	local alert_fg = "#ff9e64" -- Tokyo Night Orange

	local foreground = inactive_fg
	local circle = "○"

	if tab.is_active then
		foreground = active_fg
		circle = "●"
	elseif hover then
		foreground = hover_fg
	end

	-- Check for action/status emojis across ALL panes in this tab
	local status_emoji = ""
	local has_alert = false

	-- Look for common CLI agent status emojis
	local emojis = { "✋", "👋", "⏳", "⚠️", "💬", "✅", "❌", "✨", "🤖" }

	-- Scan every pane inside the tab so we don't miss alerts in unfocused splits
	-- We loop over the global tabs array because the local `panes` array only holds the active pane
	for _, t in ipairs(tabs) do
		if t.tab_id == tab.tab_id then
			for _, p in ipairs(t.panes) do
				local pane_title = p.title or ""
				for _, emoji in ipairs(emojis) do
					if pane_title:find(emoji) then
						status_emoji = emoji
						has_alert = true
						break
					end
				end
				if has_alert then
					break
				end
			end
		end
		if has_alert then
			break
		end
	end

	-- If the user manually forced a title, check that too
	if tab.tab_title and #tab.tab_title > 0 then
		for _, emoji in ipairs(emojis) do
			if tab.tab_title:find(emoji) then
				status_emoji = emoji
				has_alert = true
				break
			end
		end
	end

	-- Soft Blink Animation (Performance Optimized)	-- We ONLY perform color math if this specific tab has an active alert.
	-- This prevents wasted CPU cycles on idle tabs.
	if has_alert then
		-- Use a conservative pulse speed: math.sin(time) oscillates smoothly
		-- We offset by tab_index so multiple alerting tabs pulse slightly out-of-phase
		local time = tonumber(wezterm.time.now():format("%S.%f")) or 0
		-- math.sin output ranges from -1 to 1. We map it to 0.0 to 1.0.
		local pulse = (math.sin(time * 3 + tab.tab_index) + 1) / 2

		-- Smoothly blend the base color (inactive/active) with the bright alert color
		local base_color = wezterm.color.parse(foreground)
		local alert_color = wezterm.color.parse(alert_fg)
		foreground = base_color:lerp(alert_color, pulse):format_hex()
	end

	-- Replace the default circle with the alert emoji if one exists
	local final_indicator = has_alert and status_emoji or circle

	-- Use custom tab title if set, otherwise fall back to foreground process name
	local title = tab.tab_title
	if not title or #title == 0 then
		local process_name = tab.active_pane.foreground_process_name or ""
		if process_name ~= "" then
			title = process_name:match("([^/\\]+)$") or process_name
		else
			title = tab.active_pane.title or ""
		end
	end

	-- Consistent width logic:
	-- Truncate if too long (max_width usually provided by WezTerm)
	local max_title_width = max_width - 8
	if #title > max_title_width then
		title = title:sub(1, max_title_width - 3) .. "..."
	end

	-- Add padding around the indicator ONLY, keeping tabs totally minimalist
	local display_title = string.format("  %s  ", final_indicator)

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = display_title },
	}
end)

-- Force UI updates slightly faster to power the animation without melting the CPU
-- Default is 1000ms. 250ms (4 frames per second) is a perfect sweet spot
-- for a smooth LED-style pulse that uses negligible resources.
config.status_update_interval = 1000

-- Auto-reload configuration
config.automatically_reload_config = true

-- Default workspace name
-- config.default_workspace = 'main'

return config
