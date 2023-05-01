return {
	lua_ls = {
		filetypes = { "lua" },
		Lua = {
			workspace = { checkThirdParty = false },
			telemetry = { enable = false },
			completion = { callSnippet = "Replace" },
		},
	},
	phpactor = {
		cmd = { "phpactor", "language-server" },
		filetypes = { "php" },
		single_file_support = true,
		root_dir = function(fname)
			return require("lspconfig").util.root_pattern(".git")(fname) or require("setup.utils").dirname(fname)
		end,
	},

	jdtls = {
		settings = {
			java = {
				signatureHelp = { enabled = true },
				contentProvider = { preferred = "fernflower" },
			},
		},
	},

	pyright = {
		on_init = function(client)
			require("navigator.lspclient.python").on_init(client)
		end,
		root_dir = function(fname)
			return require("lspconfig").util.root_pattern(".git")(fname) or require("setup.utils").dirname(fname)
		end,
		cmd = { "pyright-langserver", "--stdio" },
		filetypes = { "python" },
		flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
		settings = {
			python = {
				formatting = { provider = "black" },
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "workspace",
				},
			},
		},
		single_file_support = true,
	},

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

	ccls = {
		init_options = {
			compilationDatabaseDirectory = "build",
			root_dir = require("lspconfig").util.root_pattern(
				"compile_commands.json",
				"compile_flags.txt",
				"CMakeLists.txt",
				"Makefile",
				".git"
			)(fname) or require("setup.utils").dirname(fname),
			index = { threads = 2 },
			clang = { excludeArgs = { "-frounding-math" } },
		},
		flags = { allow_incremental_sync = true },
	},
}
