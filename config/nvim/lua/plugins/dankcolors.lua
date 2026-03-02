return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#13140f',
				base01 = '#13140f',
				base02 = '#83867c',
				base03 = '#83867c',
				base04 = '#d4d9cc',
				base05 = '#fcfff8',
				base06 = '#fcfff8',
				base07 = '#fcfff8',
				base08 = '#ffae9f',
				base09 = '#ffae9f',
				base0A = '#cde3a4',
				base0B = '#a8f8a1',
				base0C = '#f1ffd9',
				base0D = '#cde3a4',
				base0E = '#eaffc4',
				base0F = '#eaffc4',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#83867c',
				fg = '#fcfff8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#cde3a4',
				fg = '#13140f',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#83867c' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#f1ffd9', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#eaffc4',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#cde3a4',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#cde3a4',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#f1ffd9',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#a8f8a1',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#d4d9cc' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#d4d9cc' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#83867c',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
