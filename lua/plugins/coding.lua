return {
	{
		"echasnovski/mini.comment",
		event = "BufRead",
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
		cmd = "DBUI",
		init = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
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

	-- {
	-- 	"VidocqH/lsp-lens.nvim",
	-- 	event = "LspAttach",
	-- 	config = function()
	-- 		require("lsp-lens").setup({
	-- 			enable = true,
	-- 			include_declaration = true, -- Reference include declaration
	-- 			sections = { -- Enable / Disable specific request
	-- 				definition = true,
	-- 				references = true,
	-- 				implementation = true,
	-- 			},
	-- 			ignore_filetype = {
	-- 				"prisma",
	-- 				"html",
	-- 				"css",
	-- 				"sql",
	-- 				"md",
	-- 			},
	-- 		})
	-- 	end,
	-- },

	{
		"nvim-neotest/neotest",
		lazy = true,
		dependencies = {
			{ "antoinemadec/FixCursorHold.nvim", lazy = true },
			{ "nvim-neotest/neotest-go", lazy = true },
		},
		init = function()
			require("setup.plugins.neotest").keymaps()
		end,
		config = function()
			require("setup.plugins.neotest").setup()
		end,
	},

	{
		"stevearc/overseer.nvim",
		lazy = true,
		opts = {
			templates = { "builtin", "go.go-run" },
			component_aliases = {
				default_neotest = {
					"on_output_summarize",
					"on_exit_set_status",
					"on_complete_dispose",
				},
			},
		},
		init = function()
			require("setup.plugins.overseer").init()
		end,
	},

	{
		"mfussenegger/nvim-dap",
		lazy = true,
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
		},
		init = function()
			require("setup.plugins.nvim-dap").init()
		end,
		config = function()
			require("setup.plugins.nvim-dap").setup()
		end,
	},

	{
		"mhartington/formatter.nvim",
		cmd = { "Format", "FormatWrite" },
		keys = { { "<leader>fw", "<cmd>FormatWrite<cr>", desc = "Format documennt" } },
		config = function()
			require("setup.plugins.formatter")
		end,
	},

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
				add = "gza", -- Add surrounding in Normal and Visual modes
				delete = "gzd", -- Delete surrounding
				find = "gzf", -- Find surrounding (to the right)
				find_left = "gzF", -- Find surrounding (to the left)
				highlight = "gzh", -- Highlight surrounding
				replace = "gzr", -- Replace surrounding
				update_n_lines = "gzn", -- Update `n_lines`
			},
		},
		config = function(_, opts)
			require("mini.surround").setup(opts)
		end,
	},

	{
		"echasnovski/mini.ai",
		-- keys = {
		-- 	{ "a", mode = { "x", "o" } },
		-- 	{ "i", mode = { "x", "o" } },
		-- },
		event = "VeryLazy",
		dependencies = { "nvim-treesitter-textobjects" },
		config = function()
			require("setup.plugins.mini-ai")()
		end,
	},
	{
		"CRAG666/code_runner.nvim",
		lazy = true,
		keys = { { "<leader>rc", "<cmd>RunCode<CR>", desc = "Run code" } },
		config = function()
			require("code_runner").setup({
				mode = "term",
				focus = false,
				startinsert = true,
				term = {
					position = "vert",
					size = 65,
				},
				filetype_path = vim.fn.expand("~/.config/nvim/setup/code-runner/code_runner.json"),
				-- project_path = vim.fn.expand("~/.config/nvim/setup/code-runner/project_manager.json"),
			})
		end,
	},

	{
		"ggandor/flit.nvim",
		keys = function()
			local ret = {}
			for _, key in ipairs({ "f", "F", "t", "T" }) do
				ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
			end
			return ret
		end,
		opts = { labeled_modes = "nx" },
	},
	{
		"ggandor/leap.nvim",
		keys = {
			{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
			{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
			{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			leap.add_default_mappings(true)
			vim.keymap.del({ "x", "o" }, "x")
			vim.keymap.del({ "x", "o" }, "X")
		end,
	},
}
