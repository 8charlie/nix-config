vim.g.mapleader = " "
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.fn.systemlist("git -C " .. lazypath .. " rev-parse --is-inside-work-tree")[1] == "true") then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- theme
vim.cmd.colorscheme("gruvbox")                    -- theme
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" }) -- removes neovim background so we have terminal background color instead

-- sets tab to 4 spaces
vim.o.expandtab = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.number = true
vim.o.relativenumber = true
vim.o.ignorecase = true    -- search is case insensitive
vim.o.smartcase = true     -- search is case sensitive if capital letter
vim.o.inccommand = "split" -- previews what youll replace stuff with during replace
vim.o.splitbelow = true
vim.o.splitright = true

vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = false,
	},
})

vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			analysis = {
				typeCheckingMode = "standard", -- default "recommended" is too strict
			},
		},
	},
})

vim.lsp.enable({ "lua_ls", "clangd", "nil_ls", "rust_analyzer", "hls", "basedpyright" })

-- keybinds
local key = vim.keymap.set

key({ 'n', 'v' }, '<leader>y', '"+y')
key({ 'n', 'v' }, '<leader>d', '"+d')
key("n", "<leader>rc", ":%s/<C-r><C-w>//g<Left><Left>") -- replace under cursor
key("n", "<down>", ":resize +2<cr>")                    -- resizes windows
key("n", "<up>", ":resize -2<cr>")
key("n", "<right>", ":vertical resize +2<cr>")
key("n", "<left>", ":vertical resize -2<cr>")
key("n", ",h", "<c-w>h") -- switch between windows
key("n", ",j", "<c-w>j")
key("n", ",k", "<c-w>k")
key("n", ",l", "<c-w>l")
key("n", "<TAB>", ":bnext<cr>")                               -- next buffer
key("n", "<S-TAB>", ":bprevious<cr>")                         -- previous buffer
key("n", "<C-d>", "<C-d>zz")                                  -- centers screen after ctrl d
key("n", "<C-u>", "<C-u>zz")                                  -- centers screen after ctrl u
key("n", "<leader>b", ":lua vim.diagnostic.open_float()<cr>") -- open floating window for error/warnings
key("n", "<leader>n", ":lua vim.diagnostic.setloclist()<cr>") -- show all errors

-- plugin binds
key("n", "<leader>g", ":Pick grep_live<cr>")
key("n", "<leader>e", ":lua MiniFiles.open()<cr>")
key("n", "<leader>f", ":Pick files<cr>")
