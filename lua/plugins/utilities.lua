return {
	{ "nvim-lua/plenary.nvim", lazy = true },
	{
		"mrjones2014/legendary.nvim",
		lazy = false,
		priority = 1000,
		dependencies = "kkharji/sqlite.lua",
		init = function()
			require("legendary").keymaps({
				{
					"<leader>lg",
					require("legendary").find,
					hide = true,
					description = "Open Legendary",
					mode = { "n", "v" },
				},
			})
		end,
		config = function()
			require("legendary").setup({
				select_prompt = "Legendary",
				include_builtin = false,
				include_legendary_cmds = false,
				which_key = { auto_register = false },
				autocmds = require("wiggy.autocmds"),
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
            require("setup.plugins.whichkey")()
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		lazy = true,
		cmd = "ToggleTerm",
		init = function()
			require("setup.plugins.toggleterm").init()
		end,
		config = function()
			require("setup.plugins.toggleterm").setup()
		end,
	},

	{
		"olimorris/persisted.nvim", -- Session management
		priority = 100,
		opts = {
			save_dir = Sessiondir .. "/",
			use_git_branch = true,
			silent = true,
			-- autoload = true,
			should_autosave = function()
				if vim.bo.filetype == "alpha" or vim.bo.filetype == "oil" or vim.bo.filetype == "lazy" then
					return false
				end
				return true
			end,
		},
		init = function()
			require("setup.plugins.persisted")()
		end,
	},
}
