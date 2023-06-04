return {
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
		{ "JoosepAlviste/nvim-ts-context-commentstring" },
		{ "windwp/nvim-ts-autotag", config = true },
		{ "HiPhish/nvim-ts-rainbow2" },
		{ "windwp/nvim-autopairs", config = true },
		{ "nvim-treesitter/nvim-treesitter-textobjects" },
		{ "nvim-treesitter/nvim-treesitter-context", opts = { max_lines = 3 } },
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
			"rust",
			"java",
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
			"sql",
			"solidity",
			"html",
			"query", -- treesitter query language
			"http", -- http requests as format, used for rest.nvim
		},
		sync_install = false,
		highlight = {
			enable = true,
			disable = function(_, bufnr)
				return vim.api.nvim_buf_line_count(bufnr) > 7000
			end,
			additional_vim_regex_highlighting = { "markdown" },
		},
		textsubjects = { enable = true, keymaps = { [","] = "textsubjects-smart" } },
		indent = { enable = true },
		autotag = { enable = true, filetypes = { "html", "jsx", "tsx", "xml" } },
		context_commentstring = { enable = true },
		rainbow = { enable = true, query = "rainbow-parens" },
		query_linter = { enable = true, use_virtual_text = true, lint_events = { "BufWrite", "CursorHold" } },
	},
	config = function(_, opts)
		return require("nvim-treesitter.configs").setup(opts)
	end,
}
