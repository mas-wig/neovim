return {

	{ "nvim-tree/nvim-web-devicons", lazy = true },

	{ "MunifTanjim/nui.nvim", lazy = true },

	{
		"SmiteshP/nvim-navic",
		lazy = true,
		init = function()
			vim.g.navic_silence = true
		end,
		opts = function()
			return {
				separator = "   ",
				highlight = true,
				depth_limit = 5,
				depth_limit_indicator = "  ",
				icons = require("setup.ui.icons").kind,
			}
		end,
	},
	{
		"rcarriga/nvim-notify",
		init = function()
			vim.notify = require("notify")
			local Util = require("setup.utils")
			if not Util.has("noice.nvim") then
				Util.on_very_lazy(function()
					vim.notify = require("notify")
				end)
			end
		end,
		config = function()
			require("setup.plugins.notify")
		end,
	},

	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
		opts = {
			input = {
				title_pos = "center",
				border = "single",
			},
		},
		config = function(_, opts)
			require("dressing").setup(opts)
		end,
	},

	{
		"NvChad/nvim-colorizer.lua",
		ft = { "css", "html", "lua", "javascriptreact", "javascript", "typescript", "typescriptreact" },
		config = function()
			return require("colorizer").setup({
				filetypes = { "css", "html", "lua", "javascriptreact", "javascript", "typescript", "typescriptreact" },
				user_default_options = {
					names = false,
					rgb_fn = true,
					tailwind = true,
				},
			})
		end,
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			char = "▏",
			context_char = "▏",
			filetype_exclude = {
				"toggleterm",
				"alpha",
				"terminal",
				"help",
				"dashboard",
				"Trouble",
				"octo",
				"mason",
				"dbui",
				"help",
				"neo-tree",
				"Trouble",
				"lazy",
			},
			use_treesitter = true,
			show_trailing_blankline_indent = false,
			show_current_context = true,
			show_current_context_start = true,
		},
		config = function(_, opts)
			require("indent_blankline").setup(opts)
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			require("setup.plugins.noice")
		end,
	},
}
