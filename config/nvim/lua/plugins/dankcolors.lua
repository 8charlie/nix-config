return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#161310',
				base01 = '#161310',
				base02 = '#98928d',
				base03 = '#98928d',
				base04 = '#f6eee7',
				base05 = '#fffbf8',
				base06 = '#fffbf8',
				base07 = '#fffbf8',
				base08 = '#ffa49f',
				base09 = '#ffa49f',
				base0A = '#ffd5b3',
				base0B = '#b5ffa5',
				base0C = '#ffe9d6',
				base0D = '#ffd5b3',
				base0E = '#ffdcc0',
				base0F = '#ffdcc0',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#98928d',
				fg = '#fffbf8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#ffd5b3',
				fg = '#161310',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#98928d' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#ffe9d6', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ffdcc0',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#ffd5b3',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#ffd5b3',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#ffe9d6',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#b5ffa5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#f6eee7' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#f6eee7' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#98928d',
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
