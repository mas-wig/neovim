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
}
