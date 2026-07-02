return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#141310',
				base01 = '#141310',
				base02 = '#89877e',
				base03 = '#89877e',
				base04 = '#dddbd0',
				base05 = '#fffdf8',
				base06 = '#fffdf8',
				base07 = '#fffdf8',
				base08 = '#ffa89f',
				base09 = '#ffa89f',
				base0A = '#e8dca8',
				base0B = '#b0fda4',
				base0C = '#fff8da',
				base0D = '#e8dca8',
				base0E = '#fff4c5',
				base0F = '#fff4c5',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#89877e',
				fg = '#fffdf8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#e8dca8',
				fg = '#141310',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#89877e' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#fff8da', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#fff4c5',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#e8dca8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#e8dca8',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#fff8da',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#b0fda4',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#dddbd0' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#dddbd0' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#89877e',
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
