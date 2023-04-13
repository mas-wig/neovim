return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = { "williamboman/mason-lspconfig.nvim", lazy = true },
		opts = {
			setup = {},
			servers = {
				lua_ls = {
					filetypes = { "lua" },
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
				phpactor = {
					cmd = { "phpactor", "language-server" },
					filetypes = { "php" },
					single_file_support = true,
					root_dir = function(fname)
						return require("lspconfig").util.root_pattern(".git")(fname)
							or require("setup.utils").dirname(fname)
					end,
				},

				pyright = {
					on_init = function(client)
						require("navigator.lspclient.python").on_init(client)
					end,
					root_dir = function(fname)
						return require("lspconfig").util.root_pattern(".git")(fname)
							or require("setup.utils").dirname(fname)
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
						return require("lspconfig").util.root_pattern(".git")(fname)
							or require("setup.utils").dirname(fname)
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
						return require("lspconfig").util.root_pattern(".git")(fname)
							or require("setup.utils").dirname(fname)
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
					single_file_support = true,
					root_dir = function(fname)
						return require("lspconfig").util.root_pattern(".git")(fname)
							or require("setup.utils").dirname(fname)
					end,
				},
			},
		},
		config = function(_, opts)
			-- for name, icon in pairs(require("ui.icons").diagnostics) do
			-- 	name = "DiagnosticSign" .. name
			-- 	vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			-- end
			require("setup.utils").on_attach(function(client, bufnr)
				require("legendary").keymaps({
					{
						itemgroup = "Navigator",
						description = "Navigate me Daddy",
						icon = "🚀 ",
						keymaps = {
							{
								"gr",
								function()
									require("navigator.reference").async_ref()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Async Reference",
							},
							{
								"<Leader>gr",
								function()
									require("navigator.reference").reference()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Reference",
							}, -- reference deprecated
							{
								mode = "i",
								"<c-k>",
								function()
									vim.lsp.handlers["textDocument/signatureHelp"] =
										vim.lsp.with(vim.lsp.handlers.signature_help, {
											border = "single",
										})
									vim.lsp.buf.signature_help()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Signature Help",
							},
							{
								"g0",
								function()
									require("navigator.symbols").document_symbols()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Doc Symbols",
							},
							{
								"gW",
								function()
									require("navigator.workspace").workspace_symbol_live()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Workspace Symbols",
							},
							{
								"gd",
								function()
									require("navigator.definition").definition()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Goto definition",
							},
							{
								"gD",
								function()
									vim.lsp.buf.declaration()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Goto Declaration",
							},
							{
								"gp",
								function()
									require("navigator.definition").definition_preview()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Peek Definition",
							},
							{
								"<Leader>gt",
								function()
									require("navigator.treesitter").buf_ts()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ TreeSitter Symbol",
							},
							{
								"<Leader>gT",
								function()
									require("navigator.treesitter").bufs_ts()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ TreeSitter Symbols",
							},
							{
								"<Leader>ct",
								function()
									require("navigator.ctags").ctags()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Ctags",
							},
							{
								"<Space>ca",
								mode = "n",
								function()
									require("navigator.codeAction").code_action()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Code Action",
							},
							{
								"<Space>ca",
								mode = "v",
								function()
									require("navigator.codeAction").range_code_action()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Range Code Action",
							},
							{
								"<Space>rn",
								function()
									require("navigator.rename").rename()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Rename",
							},
							{
								"<Leader>gi",
								function()
									vim.lsp.buf.incoming_calls()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Incoming Calls",
							},
							{
								"<Leader>go",
								function()
									vim.lsp.buf.outgoing_calls()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Outgoing Calls",
							},
							{
								"gi",
								function()
									vim.lsp.buf.implementation()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Implementation",
							},
							{
								"<Space>D",
								function()
									vim.lsp.buf.type_definition()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Type Definition",
							},
							{
								"gL",
								function()
									require("navigator.diagnostics").show_diagnostics()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Show Diagnostics",
							},
							{
								"gG",
								function()
									require("navigator.diagnostics").show_buf_diagnostics()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Show Buf Diagnostics",
							},
							{
								"<Leader>dT",
								function()
									require("navigator.diagnostics").toggle_diagnostics()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Toggle Diagnostics",
							},
							{
								"]d",
								function()
									vim.diagnostic.goto_next()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Next Diagnostics",
							},
							{
								"[d",
								function()
									vim.diagnostic.goto_prev()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Prev Diagnostics",
							},
							{
								"]O",
								function()
									vim.diagnostic.set_loclist()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Diagnostics SetLoclist",
							},
							{
								"]r",
								function()
									require("navigator.treesitter").goto_next_usage()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Goto Next Usage",
							},
							{
								"[r",
								function()
									require("navigator.treesitter").goto_previous_usage()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Goto Prev Usage",
							},
							{
								"K",
								function()
									vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
										border = "rounded",
									})
									return vim.lsp.buf.hover()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Hover Doc",
							},
							{
								"<Leader>k",
								function()
									require("navigator.dochighlight").hi_symbol()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ HL Symbol",
							},
							{
								"<Space>wa",
								function()
									require("navigator.workspace").add_workspace_folder()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Add to Workspace",
							},
							{
								"<Space>wr",
								function()
									require("navigator.workspace").remove_workspace_folder()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ Remove Workspace",
							},
							{
								"<Space>wl",
								function()
									require("navigator.workspace").list_workspace_folders()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ List Workspace",
							},
							{
								"<Space>la",
								mode = "n",
								function()
									require("navigator.codelens").run_action()
								end,
								opts = { buffer = bufnr },
								description = "⚡️ CodeLens Action",
							},
						},
					},
				})
				-- Formatter --
				-- if client.supports_method("textDocument/formatting") then
				-- 	vim.api.nvim_clear_autocmds({
				-- 		group = vim.api.nvim_create_augroup("LspFormatting", {}),
				-- 		buffer = bufnr,
				-- 	})
				-- 	vim.api.nvim_create_autocmd("BufWritePre", {
				-- 		group = vim.api.nvim_create_augroup("LspFormatting", {}),
				-- 		buffer = bufnr,
				-- 		callback = function()
				-- 			vim.lsp.buf.format({
				-- 				filter = function(client)
				-- 					return client.name == "null-ls"
				-- 				end,
				-- 				bufnr = bufnr,
				-- 				id = client.id,
				-- 				timeout_ms = 5000,
				-- 				async = true,
				-- 			})
				-- 		end,
				-- 	})
				-- end
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
				-- Autocmd --
				require("legendary").autocmds({
					{
						name = "LspOnAttachAutocmds",
						clear = false,
						{
							{ "CursorHold", "CursorHoldI" },
							":silent! lua vim.lsp.buf.document_highlight()",
							opts = { buffer = bufnr },
						},
						{
							"CursorMoved",
							":silent! lua vim.lsp.buf.clear_references()",
							opts = { buffer = bufnr },
						},
					},
				})
			end)

			local servers = opts.servers
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local available = have_mason and mlsp.get_available_servers() or {}

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.mason == false or not vim.tbl_contains(available, server) then
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			if have_mason then
				mlsp.setup({ ensure_installed = ensure_installed })
				mlsp.setup_handlers({ setup })
			end
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	{
		"williamboman/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonInstallAll" },
		lazy = true,
		opts = {
			ensure_installed = { "stylua", "prettier" },
			PATH = "skip",
			ui = {
				icons = {
					package_pending = " ",
					package_installed = " ",
					package_uninstalled = " ﮊ",
				},
				keymaps = {
					toggle_server_expand = "<CR>",
					install_server = "i",
					update_server = "u",
					check_server_version = "c",
					update_all_servers = "U",
					check_outdated_servers = "C",
					uninstall_server = "X",
					cancel_installation = "<C-c>",
				},
			},
			max_concurrent_installers = 10,
		},
		config = function(_, opts)
			require("mason").setup(opts)
			vim.api.nvim_create_user_command("MasonInstallAll", function()
				vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
			end, {})
			vim.g.mason_binaries_list = opts.ensure_installed
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	-- {
	-- 	"jose-elias-alvarez/null-ls.nvim",
	-- 	event = "LspAttach",
	-- 	config = function()
	-- 		local null_ls = require("null-ls")
	-- 		null_ls.setup({
	-- 			root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
	-- 			sources = {
	-- 				null_ls.builtins.formatting.stylua.with({
	-- 					extra_args = {
	-- 						"--indent-type",
	-- 						"Tabs",
	-- 						"--indent-width",
	-- 						"4",
	-- 					},
	-- 				}),
	-- 				null_ls.builtins.formatting.prettier.with({
	-- 					extra_args = {
	-- 						"--use-tabs",
	-- 						"true",
	-- 						"--tab-width",
	-- 						"4",
	-- 					},
	-- 				}),
	-- 			},
	-- 		})
	-- 	end,
	-- },

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	{
		"ray-x/navigator.lua",
		branch = "master",
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
		init = function()
			if vim.o.ft == "clap_input" and vim.o.ft == "guihua" and vim.o.ft == "guihua_rust" then
				require("cmp").setup.buffer({ completion = { enable = false } })
			end
		end,
		dependencies = {
			"ray-x/guihua.lua",
			branch = "master",
			lazy = true,
			build = "cd lua/fzy && make",
		},
		config = function()
			return require("navigator").setup({
				border = "rounded",
				ts_fold = false,
				default_mapping = false,
				transparency = 100,
				lsp_signature_help = false,
				lsp = {
					disable_lsp = "all",
					format_on_save = false,
					diagnostic = {
						underline = true,
						update_in_insert = false,
						virtual_text = {
							spacing = 10,
							underline = true,
							update_in_insert = true,
							prefix = "  ",
						},
						severity_sort = true,
					},
					diagnostic_virtual_text = true,
					diagnostic_scrollbar_sign = false,
					diagnostic_update_in_insert = true,
					disply_diagnostic_qf = true,
				},
				icons = {
					diagnostic_err = require("ui.icons").diagnostics.Error,
					diagnostic_warn = require("ui.icons").diagnostics.Warn,
					diagnostic_info = require("ui.icons").diagnostics.Info,
					diagnostic_hint = require("ui.icons").diagnostics.Hint,
				},
			})
		end,
	},
}
