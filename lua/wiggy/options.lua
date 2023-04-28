if vim.version().minor >= 9 then
	vim.opt.splitkeep = "screen"
	vim.opt.shortmess:append({ C = true })
end

local opts = {
	wrap = false,
	breakindent = false,
	linebreak = true,
	textwidth = 80,
	wrapmargin = 2,
	showtabline = 2,
	autowrite = true,
	autowriteall = true,
	clipboard = "unnamedplus",
	completeopt = "menu,menuone,noselect",
	cursorlineopt = "screenline,number",
	dictionary = "/usr/share/dict/words",
	confirm = true,
	cursorline = true,
	expandtab = true,
	formatoptions = "jcroqlnt",
	grepformat = "%f:%l:%c:%m",
	grepprg = "rg , --vimgrep",
	ignorecase = true,
	inccommand = "nosplit",
	laststatus = 3,
	list = true,
	listchars = require("setup.ui.icons").listchars,
	mouse = "a",
	number = true,
	pumblend = 0, -- Popup blend
	pumheight = 10, -- Maximum number of entries in a popup
	relativenumber = true,
	scrolloff = 4,
	shell = "/usr/bin/zsh",
	matchtime = 1, -- deci-seconds (higher amount feels laggy)
	sessionoptions = { "buffers", "curdir", "folds", "globals", "tabpages", "winpos", "winsize" },
	shiftround = true, -- Round indent
	shiftwidth = 4, -- Size of an indent
	showmode = false, -- Dont show mode since we have a statusline
	sidescrolloff = 8, -- Columns of context
	signcolumn = "yes", -- Always show the signcolumn, otherwise it would shift the text each time
	smartcase = true, -- Don't ignore case with capitals
	smartindent = true, -- Insert indents automatically
	splitbelow = true,
	splitright = true,
	tabstop = 4,
	termguicolors = true,
	timeoutlen = 300,
	undofile = true,
	undolevels = 10000,
	guifont = "JetBrainsMono Nerd Font:h9.0",
	updatetime = 200, -- Save swap file and trigger CursorHold
	wildmode = "longest:full,full", -- Command-line completion mode
	winminwidth = 5, -- Minimum window width
	splitkeep = "screen",
	fileencoding = "utf-8", -- File content encoding for the buffer
	foldenable = true, -- enable fold for nvim-ufo
	foldlevel = 99, -- set high foldlevel for nvim-ufo
	foldlevelstart = 99, -- start with all code unfolded
	foldcolumn = "1",
	backupdir = vim.fn.stdpath("data") .. "/backups",
	directory = vim.fn.stdpath("data") .. "/swaps",
	undodir = vim.fn.stdpath("data") .. "/undos",
}

local global = {
	db_ui_use_nerd_fonts = 1,
	markdown_recommended_style = 0,
	cmp_enabled = true,
	mapleader = " ",
	maplocalleader = " ",
}

for key, value in pairs(global) do
	vim.g[key] = value
end

for key, value in pairs(opts) do
	vim.opt[key] = value
end

local opt = vim.opt
opt.shortmess:append({ W = true, I = true, c = true })
opt.iskeyword:append("-")
opt.nrformats:append("unsigned")
opt.nrformats:remove({ "bin", "hex" })

Sessiondir = vim.fn.stdpath("data") .. "/sessions"

-- Create folders for our backups, undos, swaps and sessions if they don't exist
vim.cmd("silent call mkdir(stdpath('data').'/backups', 'p', '0700')")
vim.cmd("silent call mkdir(stdpath('data').'/undos', 'p', '0700')")
vim.cmd("silent call mkdir(stdpath('data').'/swaps', 'p', '0700')")
vim.cmd("silent call mkdir(stdpath('data').'/sessions', 'p', '0700')")
vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
