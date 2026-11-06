return {
	{
		"lervag/vimtex",
		-- vimtex loads itself per filetype already, and lazy-loading it breaks
		-- inverse search from the PDF viewer
		lazy = false,
		init = function()
			-- plain "zathura" needs xdotool, which can't see windows under Wayland
			if vim.fn.has("mac") == 0 then
				vim.g.vimtex_view_method = "zathura_simple"
			end
		end,
	},
}
