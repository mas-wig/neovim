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
		cmd = {
			"SessionToggle",
			"SessionStart",
			"SessionStop",
			"SessionSave",
			"SessionLoad",
			"SessionLoadLast",
			"SessionLoadFromPath",
			"SessionDelete",
		},
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
		"akinsho/toggleterm.nvim",
		lazy = true,
		cmd = "ToggleTerm",
		init = function()
			require("legendary").keymaps({
				{
					itemgroup = "ToggleTerm",
					description = "Toggle me Daddy",
					icon = "🔭",
					keymaps = {
						{ "<A-i>", "<cmd>ToggleTerm direction=float<cr>", description = "Open Float Term" },
						{ "<A-v>", "<cmd>ToggleTerm direction=vertical<cr>", description = "Open Vert Term" },
						{ "<A-h>", "<cmd>ToggleTerm direction=horizontal<cr>", description = "Open Horz Term" },
						{
							"<A-i>",
							{
								n = "<cmd>ToggleTerm direction=float<cr>",
								t = "<cmd>ToggleTerm direction=float<cr>",
							},
							description = "Open Float Term",
						},
						{
							"<A-v>",
							{
								n = "<cmd>ToggleTerm direction=vertical<cr>",
								t = "<cmd>ToggleTerm direction=vertical<cr>",
							},
							description = "Open Vert Term",
						},
						{
							"<A-h>",
							{
								n = "<cmd>ToggleTerm direction=horizontal<cr>",
								t = "<cmd>ToggleTerm direction=horizontal<cr>",
							},
							description = "Open Horz Term",
						},
					},
				},
			})
		end,
		config = function()
			return require("toggleterm").setup({
				size = function(term)
					if term.direction == "horizontal" then
						return 13
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.35
					end
				end,
				open_mapping = [[<c-\>]],
				hide_numbers = true,
				autochdir = true,
				highlights = {
					FloatBorder = {
						guifg = require("ui.colors").magenta,
						guibg = "none",
					},
				},
				shade_terminals = true,
				start_in_insert = true,
				insert_mappings = true,
				terminal_mappings = true,
				persist_size = true,
				persist_mode = true,
				direction = "horizontal",
				close_on_exit = true,
				shell = vim.o.shell,
				float_opts = {
					border = "rounded",
					width = 140,
					height = 28,
					winblend = 0,
				},
				winbar = {
					enabled = false,
				},
			})
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
}
