return {
	{ "nvim-lua/plenary.nvim", lazy = true },

	{
		"mrjones2014/legendary.nvim",
		lazy = false,
		branch = "master",
		priority = 900,
		dependencies = { "kkharji/sqlite.lua" },
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
				autocmds = require("core.autocmds"),
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
		"stevearc/resession.nvim",
		priority = 100,
		opts = function()
			local function is_valid(bufnr)
				if not bufnr or bufnr < 1 then
					return false
				end
				return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted
			end
			return {
				autosave = {
					enabled = true,
					interval = 60,
					notify = false,
				},
				buf_filter = function(bufnr)
					return is_valid(bufnr)
				end,
				tab_buf_filter = function(tabpage, bufnr)
					return vim.tbl_contains(vim.t[tabpage].bufs, bufnr)
				end,
				extensions = { bodrex = { enable_in_tab = true } },
			}
		end,
		init = function()
			require("legendary").commands({
				itemgroup = "Resession",
				desc = "Remember me daddy......",
				commands = {
					{
						":ResessionList",
						function()
							require("resession").list()
						end,
						desc = "List Session",
					},
					{
						":ResessionDelete",
						function()
							require("resession").delete()
						end,
						desc = "Delete Session",
					},
					{
						":ResessionLoad",
						function()
							require("resession").load()
						end,
						desc = "Load Session",
					},
					{
						":ResessionSave",
						function()
							require("resession").save()
						end,
						desc = "Save Session",
					},
				},
			})
		end,
	},

	{
		"m4xshen/hardtime.nvim",
		event = { "BufRead", "BufNewFile" },
		opts = {
			max_time = 50,
			max_count = 4,
			disable_mouse = true,
			hint = true,
			allow_different_key = false,
			resetting_keys = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "c", "d", "x", "X", "p", "P" },
			restricted_keys = { "h", "j", "k", "l", "-", "+", "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
			hint_keys = { "k", "j", "^", "$", "a", "i", "d", "y", "c", "l" },
			disabled_keys = { "<UP>", "<DOWN>", "<LEFT>", "<RIGHT>" },
			disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" },
		},
	},
}
