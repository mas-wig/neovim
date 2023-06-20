return {
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		opts = function()
			return {
				toggler = {
					line = "<leader>/",
					block = "gbc",
				},
				pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			}
		end,
		config = function(_, opts)
			require("Comment").setup(opts)
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
		"mhartington/formatter.nvim",
		cmd = { "Format", "FormatWrite" },
		keys = { { "<leader>fw", "<cmd>FormatWrite<cr>", desc = "Format documennt" } },
		config = function()
			require("setup.plugins.formatter")
		end,
	},

	{
		"cameron-wags/rainbow_csv.nvim",
		config = true,
		ft = {
			"csv",
			"tsv",
			"csv_semicolon",
			"csv_whitespace",
			"csv_pipe",
			"rfc_csv",
			"rfc_semicolon",
		},
		cmd = {
			"RainbowDelim",
			"RainbowDelimSimple",
			"RainbowDelimQuoted",
			"RainbowMultiDelim",
		},
	},
	{
		"echasnovski/mini.ai",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			init = function()
				require("setup.plugins.text-object").treesitter()
			end,
		},
		config = function()
			require("setup.plugins.text-object").miniai()
		end,
	},

	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {
			keymaps = {
				insert = "<C-g>s",
				insert_line = "<C-g>S",
				normal = "ys",
				normal_cur = "yss",
				normal_line = "yS",
				normal_cur_line = "ySS",
				visual = "S",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
			},
		},
		config = function(_, opts)
			require("nvim-surround").setup(opts)
		end,
	},

	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "rcarriga/nvim-dap-ui" },
			{ "theHamsta/nvim-dap-virtual-text" },
		},
		config = function()
			require("setup.plugins.dap").setup()
		end,
		keys = require("setup.plugins.dap").keys,
	},

	{
		"nvim-neotest/neotest",
		dependencies = {
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-go",
			-- "haydenmeade/neotest-jest",
		},
		keys = require("setup.plugins.neotest").keys,
		config = function()
			require("setup.plugins.neotest").setup()
		end,
	},

	{
		"stevearc/overseer.nvim",
		cmd = require("setup.plugins.overseer").cmd,
		config = function()
			require("setup.plugins.overseer").setup()
		end,
		keys = require("setup.plugins.overseer").keys,
	},
}
