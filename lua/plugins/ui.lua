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
				icons = require("ui.icons").kind,
			}
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
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
		opts = {
			timeout = 2000,
			top_down = true,
			icons = require("ui.icons").diagnostics,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			render = function(bufnr, notif, highlights)
				local message = {}
				for i, line in ipairs(notif.message) do
					if line ~= "" then
						local prefix = ""
						if notif.icon then
							if i == 1 then
								prefix = " " .. notif.icon .. " │ "
							else
								prefix = string.rep(" ", #notif.icon) .. "│ "
							end
						end

						-- Replace `heading` with `bold`
						line, _ = line:gsub("^# (.+)", "*%1*")
						table.insert(message, prefix .. line)
					end
				end

				vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, message)
				-- Color Icon and vertical bar
				local namespace = require("notify.render.base").namespace()
				for i = 0, #message - 1 do
					vim.api.nvim_buf_set_extmark(
						bufnr,
						namespace,
						i,
						0,
						{ hl_group = highlights.icon, end_col = 9, strict = false }
					)
				end
			end,
		},
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

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
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
			return require("noice").setup({
				cmdline = {
					enabled = true,
					view = "cmdline",
				},
				notify = {
					enabled = true,
					view = "notify",
				},
				lsp = {
					progress = {
						enabled = false,
					},
					hover = {
						enabled = false,
					},
					signature = {
						enabled = false,
					},
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					smart_move = {
						enabled = true,
						excluded_filetypes = { "sql", "cmp_menu", "cmp_docs", "notify" },
					},
				},
				presets = {
					bottom_search = false,
					command_palette = false,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = true,
				},
			})
		end,
	},

	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		config = function()
			local dashboard = require("alpha.themes.dashboard")
			local alpha = require("alpha")

			dashboard.section.header.val = {
				"██████╗  ██╗  ██████╗ ███╗   ███╗ ██╗ ██╗      ██╗       █████╗  ██╗  ██╗",
				"██╔══██╗ ██║ ██╔════╝ ████╗ ████║ ██║ ██║      ██║      ██╔══██╗ ██║  ██║",
				"██████╦╝ ██║ ╚█████╗  ██╔████╔██║ ██║ ██║      ██║      ███████║ ███████║",
				"██╔══██╗ ██║  ╚═══██╗ ██║╚██╔╝██║ ██║ ██║      ██║      ██╔══██║ ██╔══██║",
				"██████╦╝ ██║ ██████╔╝ ██║ ╚═╝ ██║ ██║ ███████╗ ███████╗ ██║  ██║ ██║  ██║",
				"╚═════╝  ╚═╝ ╚═════╝  ╚═╝     ╚═╝ ╚═╝ ╚══════╝ ╚══════╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝",
			}
			dashboard.section.buttons.val = {
				dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
				dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
				dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
				dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
				dashboard.button("s", "勒" .. " Restore Session", [[:SessionLoadLast<cr>]]),
				dashboard.button("l", "鈴" .. " Lazy", ":Lazy<CR>"),
				dashboard.button("q", " " .. " Quit", ":qa<CR>"),
			}
			for _, button in ipairs(dashboard.section.buttons.val) do
				button.opts.hl = "AlphaButtons"
				button.opts.hl_shortcut = "AlphaShortcut"
			end

			dashboard.section.footer.opts.hl = "Type"
			dashboard.section.header.opts.hl = "AlphaHeader"
			dashboard.section.buttons.opts.hl = "AlphaButtons"
			dashboard.opts.layout[1].val = 8

			alpha.setup(dashboard.opts)

			if vim.o.filetype == "lazy" then
				vim.cmd.close()
				vim.api.nvim_create_autocmd("User", {
					pattern = "AlphaReady",
					callback = function()
						require("lazy").show()
					end,
				})
			end

			vim.api.nvim_create_autocmd("User", {
				pattern = "LazyVimStarted",
				callback = function()
					local stats = require("lazy").stats()
					local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
					dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
					pcall(vim.cmd.AlphaRedraw)
				end,
			})
		end,
	},

	{
		"echasnovski/mini.animate",
		event = "VeryLazy",
		opts = function()
			-- don't use animate when scrolling with the mouse
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
