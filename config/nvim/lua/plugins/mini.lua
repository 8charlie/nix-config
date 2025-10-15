return {
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			require("mini.files").setup({})
			require("mini.pick").setup({})
			require("mini.pairs").setup({})
		end,
	},
}
