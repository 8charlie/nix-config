return {
	"stevearc/conform.nvim",
	opts = {
		format_on_save = {
			lsp_fallback = true, -- Use LSP formatting if no formatter is available
			async = false, -- Synchronous formatting
			timeout_ms = 500, -- Timeout for formatting
		},
		formatters_by_ft = {
			nix = { "alejandra" },
			rust = { "rust_analyzer" },
		},
	},
}
