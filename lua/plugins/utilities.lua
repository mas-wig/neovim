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
}
