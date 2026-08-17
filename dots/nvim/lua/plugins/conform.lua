return {
	"stevearc/conform.nvim",
	opts = {
		format_on_save = {
			lsp_format = "fallback", -- Use LSP formatting if no formatter is available
			async = false, -- Synchronous formatting
			timeout_ms = 2000, -- Allow slower formatters to finish
		},
		formatters_by_ft = {
			haskell = { "ormolu" },
			python = { "ruff_format" },
			nix = { "alejandra" },
			rust = { "rustfmt" },
		},
	},
}
