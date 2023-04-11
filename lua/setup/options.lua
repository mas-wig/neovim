local opts = {
	autowrite = true, -- Auto write enable
	clipboard = "unnamedplus", -- Sync with system clipboard
	completeopt = "menu,menuone,noselect",
	cursorlineopt = "screenline,number",
	-- dictionary = "/usr/share/dict/words", -- install dulu words package
	-- spell = true,
	-- spelllang = "en_us",
	conceallevel = 2, -- Hide * markup for bold and italic
	confirm = true, -- Confirm to save changes before exiting modified buffer
	cursorline = true, -- Enable highlighting of the current line
	expandtab = true, -- Use spaces instead of tabs
	formatoptions = "jcroqlnt", -- tcqj
	grepformat = "%f:%l:%c:%m",
	grepprg = "rg , --vimgrep",
	ignorecase = true, -- Ignore case
	inccommand = "nosplit", -- preview incremental substitute
	laststatus = 3,
	list = true, -- Show some invisible characters (tabs...
	listchars = require("ui.icons").listchars,
	mouse = "a", -- Enable mouse mode
	number = true, -- Print line number
	-- pumblend = 10, -- Popup blend
	-- pumheight = 10, -- Maximum number of entries in a popup
	relativenumber = true, -- Relative line numbers
	scrolloff = 4, -- Lines of context
	shell = "/usr/bin/zsh",
	sessionoptions = { "buffers", "curdir", "folds", "globals", "tabpages", "winpos", "winsize" },
	shiftround = true, -- Round indent
	shiftwidth = 4, -- Size of an indent
	showmode = false, -- Dont show mode since we have a statusline
	sidescrolloff = 8, -- Columns of context
	signcolumn = "yes", -- Always show the signcolumn, otherwise it would shift the text each time
	smartcase = true, -- Don't ignore case with capitals
	smartindent = true, -- Insert indents automatically
	splitbelow = true, -- Put new windows below current
	splitright = true, -- Put new windows right of current
	tabstop = 4, -- Number of spaces tabs count for
	termguicolors = true, -- True color support
	timeoutlen = 300,
	undofile = true,
	undolevels = 10000,
	updatetime = 200, -- Save swap file and trigger CursorHold
	wildmode = "longest:full,full", -- Command-line completion mode
	winminwidth = 5, -- Minimum window width
	wrap = false, -- Disable line wrap
	breakindent = true,
	splitkeep = "screen",
	fileencoding = "utf-8", -- File content encoding for the buffer
	fillchars = { eob = " " }, -- Disable `~` on nonexistent lines
	foldenable = true, -- enable fold for nvim-ufo
	foldlevel = 99, -- set high foldlevel for nvim-ufo
	foldlevelstart = 99, -- start with all code unfolded
	foldcolumn = "1",
	fillchars = {
		fold = " ",
		foldopen = "",
		foldclose = "",
		foldsep = " ",
		diff = "╱",
		eob = " ",
	},
	backupdir = vim.fn.stdpath("data") .. "/backups", -- Use backup files
	directory = vim.fn.stdpath("data") .. "/swaps", -- Use Swap files
	undodir = vim.fn.stdpath("data") .. "/undos", -- Set the undo directory
}

local global = {
	mapleader = " ",
	maplocalleader = " ",
	db_ui_use_nerd_fonts = 1,
	markdown_recommended_style = 0,
	cmp_enabled = true,
}

-- Disable Builtins
local builtins = {
	"gzip",
	"2html_plugin",
	"getscript",
	"getscriptPlugin",
	"logiPat",
	"matchit",
	"matchparen",
	"netrw",
	"netrwFileHandlers",
	"netrwPlugin",
	"netrwSettings",
	"rrhelper",
	"tar",
	"tarPlugin",
	"vimball",
	"vimballPlugin",
	"zip",
	"zipPlugin",
}

for _, plugin in ipairs(builtins) do
	vim.g["loaded_" .. plugin] = 1
end

for key, value in pairs(opts) do
	vim.opt[key] = value
end

for key, value in pairs(global) do
	vim.g[key] = value
end

vim.opt.shortmess:append({ W = true, I = true, c = true })

if vim.fn.has("nvim-0.9.0") == 1 then
	vim.opt.splitkeep = "screen"
	vim.opt.shortmess:append({ C = true })
end

Sessiondir = vim.fn.stdpath("data") .. "/sessions"

-- Create folders for our backups, undos, swaps and sessions if they don't exist
vim.cmd("silent call mkdir(stdpath('data').'/backups', 'p', '0700')")
vim.cmd("silent call mkdir(stdpath('data').'/undos', 'p', '0700')")
vim.cmd("silent call mkdir(stdpath('data').'/swaps', 'p', '0700')")
vim.cmd("silent call mkdir(stdpath('data').'/sessions', 'p', '0700')")
