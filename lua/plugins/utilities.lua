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
			require("legendary").keymaps({
				{
					itemgroup = "Persisted",
					icon = "",
					description = "Session management...",
					keymaps = {
						{
							"<Leader>s",
							'<cmd>lua require("persisted").toggle()<CR>',
							description = "Toggle a session",
							opts = { silent = true },
						},
					},
				},
			})
			require("legendary").commands({
				{
					itemgroup = "Persisted",
					commands = {
						{
							":Sessions",
							function()
								vim.cmd([[Telescope persisted]])
							end,
							description = "List sessions",
						},
						{
							":SessionSave",
							description = "Save the session",
						},
						{
							":SessionStart",
							description = "Start a session",
						},
						{
							":SessionStop",
							description = "Stop the current session",
						},
						{
							":SessionLoad",
							description = "Load the last session",
						},
						{
							":SessionDelete",
							description = "Delete the current session",
						},
					},
				},
			})
		end,
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
