return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		event = { "BufReadPre", "BufReadPost", "BufNewFile" },
		cmd = {
			"TSInstall",
			"TSBufEnable",
			"TSUpdate",
			"TSBufDisable",
			"TSEnable",
			"TSDisable",
			"TSModuleInfo",
		},
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
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
				"javascript",
				"typescript",
				"regex", -- js patterns
				"jsdoc", -- js annotations
				"bash",
				"css",
				"scss",
				"markdown",
				"markdown_inline", -- fenced code blocks
				"python",
				"lua",
				"luap", -- lua patterns
				"luadoc", -- lua annotations
				"gitignore",
				"gitcommit",
				"diff",
				"go",
				"bibtex",
				"vim",
				"vimdoc", -- help files
				"toml",
				"ini",
				"yaml",
				"json",
				"jsonc",
				"html",
				"query", -- treesitter query language
				"http", -- http requests as format, used for rest.nvim
			},
			sync_install = false,
			highlight = { enable = true },
			textsubjects = { enable = true, keymaps = { [","] = "textsubjects-smart" } },
			indent = { enable = true },
			autotag = { enable = true, filetypes = { "html", "jsx", "tsx", "xml" } },
			endwise = { enable = true },
			context_commentstring = { enable = true },
			rainbow = { enable = true, query = "rainbow-parens" },
			query_linter = { enable = true, use_virtual_text = true, lint_events = { "BufWrite", "CursorHold" } },
		},
		config = function(_, opts)
			return require("nvim-treesitter.configs").setup(opts)
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			return require("treesitter-context").setup({ max_lines = 1, trim_scope = "outer", min_window_height = 0 })
		end,
	},
}
