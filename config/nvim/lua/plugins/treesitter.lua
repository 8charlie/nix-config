return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			treesitter.setup({
				highlight = { enable = true },
				indent = { enable = true },
				auto_install = true,
				sync_install = true,
				ensure_installed = {
					"lua",
				},
			})
		end,
	},
}
