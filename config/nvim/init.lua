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
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" }) -- removes background for transparency

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

-- keybinds
local keyset = vim.keymap.set

keyset({ 'n', 'v' }, '<leader>y', '"+y')
keyset({ 'n', 'v' }, '<leader>d', '"+d')
keyset("n", "<leader>rc", ":%s/<C-r><C-w>//g<Left><Left>") -- replace under cursor
keyset("n", "<down>", ":resize +2<cr>")                    -- resizes windows
keyset("n", "<up>", ":resize -2<cr>")
keyset("n", "<right>", ":vertical resize +2<cr>")
keyset("n", "<left>", ":vertical resize -2<cr>")
keyset("n", ",h", "<c-w>h") -- switch between windows
keyset("n", ",j", "<c-w>j")
keyset("n", ",k", "<c-w>k")
keyset("n", ",l", "<c-w>l")
keyset("n", "<TAB>", ":bnext<cr>")                               -- next buffer
keyset("n", "<S-TAB>", ":bprevious<cr>")                         -- previous buffer
keyset("n", "<C-d>", "<C-d>zz")                                  -- centers screen after ctrl d
keyset("n", "<C-u>", "<C-u>zz")                                  -- centers screen after ctrl u
keyset("n", "<leader>b", ":lua vim.diagnostic.open_float<cr>")   -- open floating window for error/warnings
keyset("n", "<leader>n", ":lua vim.diagnostic.setloclist()<cr>") -- show all errors
keyset("n", "<leader>d", ":put =strftime('%d/%m/%y %H:%M')<cr>")

-- plugin binds
keyset("n", "<leader>g", ":Telescope live_grep<cr>")
keyset("n", "<leader>f", ":lua MiniFiles.open()<cr>")
keyset("n", "<leader>e", ":Pick files<cr>")
