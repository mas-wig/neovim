local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local config = {
	defaults = {
		lazy = false,
		version = nil,
	},
	spec = {
		{ import = "plugins.utilities" },
		{ import = "plugins.telescope" },
		{ import = "plugins.colorscheme" },
		{ import = "plugins.heirline.main" },
		{ import = "plugins.editor" },
		{ import = "plugins.dap" },
		{ import = "plugins.neotree" },
		{ import = "plugins.languages" },
		{ import = "plugins.vcs" },
		{ import = "plugins.treesitter" },
		{ import = "plugins.lsp.main" },
		{ import = "plugins.completion.main" },
		{ import = "plugins.ui" },
		{ import = "plugins.testing" },
		{ import = "plugins.coding" },
		{ import = "plugins.text-obj" },
	},
	install = {
		missing = true,
		colorscheme = { "tokyonight" },
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
	performance = {
		cache = { enabled = true },
		reset_packpath = true,
		rtp = {
			reset = true,
			disabled_plugins = {
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
			},
		},
	},
}

return require("lazy").setup(config)
