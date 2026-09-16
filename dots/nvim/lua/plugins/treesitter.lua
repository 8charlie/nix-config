return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter")
			treesitter.setup()
			treesitter.install({ "lua", "markdown", "markdown_inline" })

			-- The main branch uses Neovim's highlighting API and explicit indentation.
			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
				callback = function(event)
					local lang = vim.treesitter.language.get_lang(event.match)
					if not lang or not require("nvim-treesitter.parsers")[lang] then
						return
					end

					-- Install missing parsers without blocking the editor, then attach.
					treesitter.install({ lang }):await(function()
						vim.schedule(function()
							if not vim.api.nvim_buf_is_valid(event.buf)
								or vim.bo[event.buf].filetype ~= event.match then
								return
							end
							if pcall(vim.treesitter.start, event.buf, lang)
								and vim.treesitter.query.get(lang, "indents") then
								vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
							end
						end)
					end)
				end,
			})
		end,
	},
}
