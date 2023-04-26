return {
	{
		"echasnovski/mini.comment",
		event = "VeryLazy",
		opts = {
			hooks = {
				pre = function()
					require("ts_context_commentstring.internal").update_commentstring({})
				end,
			},
		},
		config = function(_, opts)
			require("mini.comment").setup(opts)
		end,
	},

	{
		"tpope/vim-dadbod",
		lazy = true,
		dependencies = { "kristijanhusak/vim-dadbod-ui", lazy = true },
		cmd = {
			"DBUI",
			"DBUIAddConnection",
			"DBUIFindBuffer",
			"DBUILastQueryInfo",
			"DBUIToggle",
			"DBUIRenameBuffer",
		},
	},
	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
	{
		"ray-x/web-tools.nvim",
		cmd = {
			"BrowserSync",
			"BrowserOpen",
			"BrowserPreview",
			"BrowserRestart",
			"Browserstop",
			"TagRename",
			"HurlRun",
		},
		config = function()
			return require("web-tools").setup({
				keymaps = {
					rename = nil,
					repeat_rename = ".",
				},
				hurl = {
					show_headers = false,
					floating = false,
					formatters = {
						json = { "jq" },
						html = { "prettier", "--parser", "html" },
					},
				},
			})
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝
	{
		"echasnovski/mini.surround",
		keys = function(_, keys)
			local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
			local opts = require("lazy.core.plugin").values(plugin, "opts", false)
			local mappings = {
				{ opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
				{ opts.mappings.delete, desc = "Delete surrounding" },
				{ opts.mappings.find, desc = "Find right surrounding" },
				{ opts.mappings.find_left, desc = "Find left surrounding" },
				{ opts.mappings.highlight, desc = "Highlight surrounding" },
				{ opts.mappings.replace, desc = "Replace surrounding" },
				{ opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
			}
			mappings = vim.tbl_filter(function(m)
				return m[1] and #m[1] > 0
			end, mappings)
			return vim.list_extend(mappings, keys)
		end,
		opts = {
			mappings = {
				add = "gza",
				delete = "gzd",
				find = "gzf",
				find_left = "gzF",
				highlight = "gzh",
				replace = "gzr",
				update_n_lines = "gzn",
			},
		},
		config = function(_, opts)
			require("mini.surround").setup(opts)
		end,
	},

	{
		"VidocqH/lsp-lens.nvim",
		event = "LspAttach",
		config = function()
			require("lsp-lens").setup({
				enable = true,
				include_declaration = false, -- Reference include declaration
				sections = { -- Enable / Disable specific request
					definition = false,
					references = true,
					implementation = true,
				},
				ignore_filetype = {
					"prisma",
				},
			})
		end,
	},
}
