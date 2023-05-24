return {
	lua_ls = {
		filetypes = { "lua" },
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			completion = { callSnippet = "Replace" },
		},
	},
	-- phpactor = {
	-- 	cmd = { "phpactor", "language-server" },
	-- 	filetypes = { "php" },
	-- 	single_file_support = true,
	-- 	root_dir = function(fname)
	-- 		return require("lspconfig").util.root_pattern(".git")(fname) or require("setup.utils").dirname(fname)
	-- 	end,
	-- },

	-- jdtls = {
	-- 	settings = {
	-- 		java = {
	-- 			signatureHelp = { enabled = true },
	-- 			contentProvider = { preferred = "fernflower" },
	-- 		},
	-- 	},
	-- },
	--
	-- pyright = {
	-- 	on_init = function(client)
	-- 		require("navigator.lspclient.python").on_init(client)
	-- 	end,
	-- 	root_dir = function(fname)
	-- 		return require("lspconfig").util.root_pattern(".git")(fname) or require("setup.utils").dirname(fname)
	-- 	end,
	-- 	cmd = { "pyright-langserver", "--stdio" },
	-- 	filetypes = { "python" },
	-- 	flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
	-- 	settings = {
	-- 		python = {
	-- 			formatting = { provider = "black" },
	-- 			analysis = {
	-- 				autoSearchPaths = true,
	-- 				useLibraryCodeForTypes = true,
	-- 				diagnosticMode = "workspace",
	-- 			},
	-- 		},
	-- 	},
	-- 	single_file_support = true,
	-- },

	html = {
		filetypes = { "html" },
		root_dir = function(fname)
			return require("lspconfig").util.root_pattern(".git")(fname) or require("setup.utils").dirname(fname)
		end,
		init_options = {
			configurationSection = { "html", "css", "javascript" },
			embeddedLanguages = {
				css = true,
				javascript = true,
			},
			provideFormatter = true,
		},
		single_file_support = true,
	},

	cssls = {
		filetypes = { "css", "scss", "less" },
		single_file_support = true,
		root_dir = function(fname)
			return require("lspconfig").util.root_pattern(".git")(fname) or require("setup.utils").dirname(fname)
		end,
		settings = {
			css = {
				validate = true,
			},
			less = {
				validate = true,
			},
			scss = {
				validate = true,
			},
		},
	},
	clangd = {
		flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
		cmd = {
			"clangd",
			"--background-index",
			"--suggest-missing-includes",
			"--clang-tidy",
			"--header-insertion=iwyu",
			"--enable-config",
			"--offset-encoding=utf-16",
			"--clang-tidy-checks=-*,llvm-*,clang-analyzer-*",
			"--cross-file-rename",
		},
		filetypes = { "c", "cpp", "objc", "objcpp" },
		root_dir = require("lspconfig").util.root_pattern(".git")(fname) or require("setup.utils").dirname(fname),
	},
	solidity_ls_nomicfoundation = {
		cmd = { "nomicfoundation-solidity-language-server", "--stdio" },
		filetypes = { "solidity" },
		root_dir = require("lspconfig").util.root_pattern(".git")(fname) or require("setup.utils").dirname(fname),
	},
}
