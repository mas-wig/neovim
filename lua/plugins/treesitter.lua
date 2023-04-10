return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "BufReadPost", "BufNewFile" },
		cmd = {
			"TSInstall",
			"TSBufEnable",
			"TSUpdate",
			"TSBufDisable",
			"TSEnable",
			"TSDisable",
			"TSModuleInfo",
		},
		dependencies = {
			{ "JoosepAlviste/nvim-ts-context-commentstring", lazy = true },
			{ "windwp/nvim-ts-autotag", lazy = true, config = true },
			{ "RRethy/nvim-treesitter-endwise", lazy = true },
			{ "HiPhish/nvim-ts-rainbow2", lazy = true },
			{
				"windwp/nvim-autopairs",
				lazy = true,
				opts = {
					close_triple_quotes = true,
					check_ts = true,
					fast_wrap = {
						map = "<c-e>",
					},
				},
			},
			{
				"abecodes/tabout.nvim",
				lazy = true,
				opts = {
					tabkey = "<Tab>",
					backwards_tabkey = "<S-Tab>",
					completion = true,
				},
			},
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				init = function()
					local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
					local opts = require("lazy.core.plugin").values(plugin, "opts", false)
					local enabled = false
					if opts.textobjects then
						for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
							if opts.textobjects[mod] and opts.textobjects[mod].enable then
								enabled = true
								break
							end
						end
					end
					if not enabled then
						require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
					end
				end,
			},
		},
		opts = {
			ensure_installed = {
				"go",
				"html",
				"css",
				"javascript",
				"php",
				"lua",
				"vim",
				"regex",
				"markdown",
				"markdown_inline",
			},
			sync_install = false,
			ignore_install = { "phpdoc" },
			highlight = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			textsubjects = { enable = true, keymaps = { [","] = "textsubjects-smart" } },
			indent = { enable = true },
			autotag = { enable = true },
			endwise = { enable = true },
			context_commentstring = { enable = true },
			rainbow = {
				enable = true,
				disable = { "jsx", "cpp" },
				query = "rainbow-parens",
			},
			query_linter = {
				enable = true,
				use_virtual_text = true,
				lint_events = { "BufWrite", "CursorHold" },
			},
		},
		config = function(_, opts)
			return require("nvim-treesitter.configs").setup(opts)
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			return require("treesitter-context").setup({
				max_lines = 1,
				trim_scope = "outer",
				min_window_height = 0,
			})
		end,
	},
}
