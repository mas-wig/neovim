return {

	{ "nvim-tree/nvim-web-devicons", lazy = true },

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	{ "MunifTanjim/nui.nvim", lazy = true },

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 3000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
		},
		init = function()
			local Util = require("setup.utils")
			if not Util.has("noice.nvim") then
				Util.on_very_lazy(function()
					vim.notify = require("notify")
				end)
			end
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

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
	{
		"folke/tokyonight.nvim",
		event = "VimEnter",
		opts = {
			style = "night",
			transparent = false,
			terminal_colors = true,
			styles = {
				comments = { italic = true },
				keywords = { italic = true },
				functions = { italic = true, bold = true },
				variables = {},
				-- Background styles. Can be "dark", "transparent" or "normal"
				sidebars = "normal",
				floats = "normal", -- style for floating windows
			},
			sidebars = { "qf", "help", "lazy", "neo-tree", "TelescopePrompt" },
			hide_inactive_statusline = false,
			dim_inactive = false,
			lualine_bold = false,
			on_highlights = function(highlights, _)
				local override = require("ui.highlight")
				for name, color in pairs(override) do
					highlights[name] = color
				end
			end,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd.colorscheme("tokyonight")
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

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

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	{
		"akinsho/bufferline.nvim",
		dependencies = {
			"tiagovla/scope.nvim",
			config = true,
		},
		event = "VeryLazy",
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-tree",
						highlight = "Directory",
						text_align = "center",
					},
				},
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
				separator_style = "thick",
			},
			highlights = {
				buffer_selected = {
					fg = "#b3ff66",
					bold = true,
					italic = true,
				},
				tab_selected = {
					bg = "#c6ff1a",
					fg = "#000000",
				},
			},
		},
		config = function(_, opts)
			require("bufferline").setup(opts)
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
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

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
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

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

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

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		lazy = true,
		config = function()
			local colors = require("ui.colors")

			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
				hide_in_width = function()
					return vim.fn.winwidth(0) > 80
				end,
				check_git_workspace = function()
					local filepath = vim.fn.expand("%:p:h")
					local gitdir = vim.fn.finddir(".git", filepath .. ";")
					return gitdir and #gitdir > 0 and #gitdir < #filepath
				end,
			}

			local configs = {
				options = {
					component_separators = "",
					section_separators = "",
					theme = {
						normal = { c = { fg = colors.lualine_fg, bg = colors.lualine_bg } },
						inactive = { c = { fg = colors.lualine_fg, bg = colors.lualine_bg } },
					},
					refresh = {
						statusline = 500,
						winbar = 500,
					},
					disabled_filetypes = {
						"lazy",
						"crunner_main",
						"neo-tree",
						"terminal",
						"help",
						"dbui",
						"toggleterm",
						"dapui_console",
						"dapui_watches",
						"dapui_scopes",
						"dapui_breakpoints",
						"dapui_stacks",
						"spectre_panel",
						"dap_repl",
						"aplha",
					},
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_y = {},
					lualine_z = {},
					lualine_c = {},
					lualine_x = {},
				},
				winbar = {
					lualine_a = {},
				},
			}

			local function ins_left(component)
				table.insert(configs.sections.lualine_c, component)
			end

			local function ins_right(component)
				table.insert(configs.sections.lualine_x, component)
			end

			ins_left({
				"mode",
				color = function()
					-- auto change color according to neovims mode
					local mode_color = {
						n = colors.red,
						i = colors.green,
						v = colors.blue,
						[""] = colors.blue,
						V = colors.blue,
						c = colors.magenta,
						no = colors.red,
						s = colors.orange,
						S = colors.orange,
						[""] = colors.orange,
						ic = colors.yellow,
						R = colors.violet,
						Rv = colors.violet,
						cv = colors.red,
						ce = colors.red,
						r = colors.cyan,
						rm = colors.cyan,
						["r?"] = colors.cyan,
						["!"] = colors.red,
						t = colors.red,
					}
					return { fg = mode_color[vim.fn.mode()] }
				end,
				icons_enabled = true,
			})

			ins_left({ "filename", color = { fg = "#e066ff" } })

			ins_left({
				"branch",
				icon = "",
				color = { fg = colors.green, gui = "bold" },
			})

			ins_left({
				"diff",
				symbols = { added = " ", modified = " ", removed = " " },
				diff_color = {
					added = { fg = colors.green },
					modified = { fg = colors.yellow },
					removed = { fg = colors.red },
				},
				cond = conditions.hide_in_width,
			})

			ins_right({
				function()
					return require("nvim-navic").get_location()
				end,
				cond = function()
					return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
				end,
				color = { bg = colors.lualine_bg },
			})

			ins_right({
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = { error = " ", warn = "  ", hint = " ", info = " " },
				diagnostics_color = {
					color_error = { fg = colors.red },
					color_warn = { fg = colors.yellow },
					color_info = { fg = colors.cyan },
					color_hint = { fg = colors.blue },
				},
			})

			ins_right({
				require("lsp-progress").progress,
				color = { fg = "#ffff33" },
			})

			ins_right({ "%l:%c", color = { fg = colors.orange, gui = "bold" } })
			ins_right({ "%p%%", color = { fg = colors.green } })

			require("lualine").setup(configs)
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
	{
		"linrongbin16/lsp-progress.nvim",
		event = { "BufAdd", "TabEnter" },
		lazy = true,
		config = function()
			require("lsp-progress").setup({
				spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
				event_update_time_limit = 200,
				client_format = function(_, spinner, series_messages)
					return #series_messages > 0 and (spinner .. " " .. table.concat(series_messages, ", ")) or nil
				end,
				format = function(client_messages)
					if rawget(vim, "lsp") then
						for _, client in ipairs(vim.lsp.get_active_clients()) do
							if client.attached_buffers[vim.api.nvim_get_current_buf()] then
								if client.name == "phpactor" then
									return client.name .. " 🪷"
								else
									return #client_messages > 0 and (" " .. table.concat(client_messages, " "))
										or client.name .. " 🪷"
								end
							end
						end
					end
				end,
			})
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
	{
		"kevinhwang91/nvim-ufo",
		event = { "VeryLazy" },
		dependencies = {
			"kevinhwang91/promise-async",
			{
				"luukvbaal/statuscol.nvim",
				event = "VeryLazy",
				config = function()
					local builtin = require("statuscol.builtin")
					require("statuscol").setup({
						bt_ignore = { "alpha", "lazy", "neo-tree" },
						relculright = true,
						segments = {
							{
								sign = { name = { "GitSigns" }, maxwidth = 1, auto = true },
								click = "v:lua.ScSa",
								condition = {
									true,
									builtin.not_empty,
									function(args)
										return vim.api.nvim_get_current_win() == args.win
									end,
								},
							},
							{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
							{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
							{
								sign = { name = { "Diagnostic" }, maxwidth = 1, auto = true },
								click = "v:lua.ScSa",
								condition = {
									true,
									builtin.not_empty,
									function(args)
										return vim.api.nvim_get_current_win() == args.win
									end,
								},
							},
							-- {
							-- 	sign = { name = { ".*" }, maxwidth = 1, colwidth = 1, auto = true },
							-- 	click = "v:lua.ScSa",
							-- },
						},
					})
				end,
			},
		},
		opts = {
			preview = {
				mappings = {
					scrollB = "<C-b>",
					scrollF = "<C-f>",
					scrollU = "<C-u>",
					scrollD = "<C-d>",
				},
			},
			provider_selector = function(_, filetype, buftype)
				local function handleFallbackException(bufnr, err, providerName)
					if type(err) == "string" and err:match("UfoFallbackException") then
						return require("ufo").getFolds(bufnr, providerName)
					else
						return require("promise").reject(err)
					end
				end

				return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
					or function(bufnr)
						return require("ufo")
							.getFolds(bufnr, "lsp")
							:catch(function(err)
								return handleFallbackException(bufnr, err, "treesitter")
							end)
							:catch(function(err)
								return handleFallbackException(bufnr, err, "indent")
							end)
					end
			end,
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = ("  📌 %d Line Folded"):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, "MoreMsg" })
				return newVirtText
			end,
		},
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

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	{
		"SmiteshP/nvim-navic",
		lazy = true,
		init = function()
			vim.g.navic_silence = true
			require("setup.utils").on_attach(function(client, buffer)
				if client.server_capabilities.documentSymbolProvider then
					require("nvim-navic").attach(client, buffer)
				end
			end)
		end,
		opts = function()
			return {
				separator = "   ",
				highlight = true,
				depth_limit = 5,
				depth_limit_indicator = "  ",
				icons = require("ui.icons").winbar,
			}
		end,
	},
}
