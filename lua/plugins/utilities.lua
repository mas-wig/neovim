return {

	-- Plenary : for main dependencies telescope
	{ "nvim-lua/plenary.nvim", lazy = true },

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	-- Lagendary : plugins for set keymap,autocmd, command etc...
	{
		"mrjones2014/legendary.nvim",
		lazy = false, -- Never lazy load this
		priority = 900,
		dependencies = "kkharji/sqlite.lua",
		init = function()
			require("legendary").keymaps({
				{
					"<C-p>",
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
				autocmds = require("setup.autocmds"),
			})
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
			return require("which-key").setup({
				icons = {

					breadcrumb = " 🌐",
					separator = " 🡆 ",
					group = "🔰 ",
				},
				popup_mappings = {
					scroll_down = "<c-d>",
					scroll_up = "<c-u>",
				},
				window = {
					border = "single", -- none/single/double/shadow
				},
				layout = {
					spacing = 6, -- spacing between columns
				},
				hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
				triggers_blacklist = {
					i = { "j", "k" },
					v = { "j", "k" },
				},
			})
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
	{
		"dstein64/vim-startuptime",
		cmd = "StartupTime",
		config = function()
			vim.g.startuptime_tries = 10
		end,
	},
}
