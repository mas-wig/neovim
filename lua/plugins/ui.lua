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
			require("setup.plugins.notify").setup()
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
			-- char = "▏",
			char = "│",
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
			show_trailing_blankline_indent = false,
			show_current_context = false,
		},
	},

	{
		"echasnovski/mini.indentscope",
		version = false, -- wait till new 0.7.0 release to put it back on semver
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- symbol = "▏",
			symbol = "│",
			options = { try_as_border = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
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
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
		config = function(_, opts)
			require("mini.indentscope").setup(opts)
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		lazy = true,
		config = function()
			require("setup.plugins.noice").setup()
		end,
	},

	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		init = function()
			if vim.o.filetype == "alpha" then
				vim.opt.laststatus = 0
			end
		end,
		config = function()
			require("setup.plugins.aplha").setup()
		end,
	},

	{
		"echasnovski/mini.animate",
		event = "VeryLazy",
		opts = function()
			local mouse_scrolled = false
			for _, scroll in ipairs({ "Up", "Down" }) do
				local key = "<ScrollWheel" .. scroll .. ">"
				vim.keymap.set({ "", "i" }, key, function()
					mouse_scrolled = true
					return key
				end, { expr = true })
			end

			local animate = require("mini.animate")
			return {
				resize = {
					timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
				},
				scroll = {
					timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
					subscroll = animate.gen_subscroll.equal({
						predicate = function(total_scroll)
							if mouse_scrolled then
								mouse_scrolled = false
								return false
							end
							return total_scroll > 1
						end,
					}),
				},
			}
		end,
		config = function(_, opts)
			require("mini.animate").setup(opts)
		end,
	},
}
