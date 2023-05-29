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
}
