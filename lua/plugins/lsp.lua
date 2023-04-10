return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
		dependencies = { "williamboman/mason-lspconfig.nvim", lazy = true },
		opts = {
			server = {
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
				phpactor = {
					cmd = { "phpactor", "language-server" },
					filetypes = { "php" },
					single_file_support = true,
				},

				pyright = {
					on_init = function(client)
						require("navigator.lspclient.python").on_init(client)
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
					cmd = { "vscode-html-language-server", "--stdio" },
					filetypes = { "html" },
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
					cmd = { "vscode-css-language-server", "--stdio" },
					filetypes = { "css", "scss", "less" },
					single_file_support = true,
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
				},
			},
		},
		config = function(_, opts)
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			local completion = require("cmp_nvim_lsp").default_capabilities(capabilities)

			capabilities.textDocument.completion = completion.textDocument.completion
			capabilities.textDocument.foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			}

			for name, icon in pairs(require("ui.icons").diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			local ensure_installed = {}
			for server, payload in pairs(opts.server) do
				local options = {
					capabilities = capabilities,
					on_attach = require("setup.utils").set_on_attach(function(client, bufnr)
						-- KEYMAP --
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
										description = "async_ref",
									},
									{
										"<Leader>gr",
										function()
											require("navigator.reference").reference()
										end,
										opts = { buffer = bufnr },
										description = "reference",
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
										description = "signature_help",
									},
									{
										"g0",
										function()
											require("navigator.symbols").document_symbols()
										end,
										opts = { buffer = bufnr },
										description = "document_symbols",
									},
									{
										"gW",
										function()
											require("navigator.workspace").workspace_symbol_live()
										end,
										opts = { buffer = bufnr },
										description = "workspace_symbol_live",
									},
									{
										"<c-]>",
										function()
											require("navigator.definition").definition()
										end,
										opts = { buffer = bufnr },
										description = "definition",
									},
									{
										"gd",
										function()
											require("navigator.definition").definition()
										end,
										opts = { buffer = bufnr },
										description = "definition",
									},
									{
										"gD",
										function()
											vim.lsp.buf.declaration()
										end,
										opts = { buffer = bufnr },
										description = "declaration",
									},
									{
										"gp",
										function()
											require("navigator.definition").definition_preview()
										end,
										opts = { buffer = bufnr },
										description = "definition_preview",
									},
									{
										"<Leader>gt",
										function()
											require("navigator.treesitter").buf_ts()
										end,
										opts = { buffer = bufnr },
										description = "buf_ts",
									},
									{
										"<Leader>gT",
										function()
											require("navigator.treesitter").bufs_ts()
										end,
										opts = { buffer = bufnr },
										description = "bufs_ts",
									},
									{
										"<Leader>ct",
										function()
											require("navigator.ctags").ctags()
										end,
										opts = { buffer = bufnr },
										description = "ctags",
									},
									{
										"<Space>ca",
										mode = "n",
										function()
											require("navigator.codeAction").code_action()
										end,
										opts = { buffer = bufnr },
										description = "code_action",
									},
									{
										"<Space>ca",
										mode = "v",
										function()
											require("navigator.codeAction").range_code_action()
										end,
										opts = { buffer = bufnr },
										description = "range_code_action",
									},
									{
										"<Space>rn",
										function()
											require("navigator.rename").rename()
										end,
										opts = { buffer = bufnr },
										description = "rename",
									},
									{
										"<Leader>gi",
										function()
											vim.lsp.buf.incoming_calls()
										end,
										opts = { buffer = bufnr },
										description = "incoming_calls",
									},
									{
										"<Leader>go",
										function()
											vim.lsp.buf.outgoing_calls()
										end,
										opts = { buffer = bufnr },
										description = "outgoing_calls",
									},
									{
										"gi",
										function()
											vim.lsp.buf.implementation()
										end,
										opts = { buffer = bufnr },
										description = "implementation",
									},
									{
										"<Space>D",
										function()
											vim.lsp.buf.type_definition()
										end,
										opts = { buffer = bufnr },
										description = "type_definition",
									},
									{
										"gL",
										function()
											require("navigator.diagnostics").show_diagnostics()
										end,
										opts = { buffer = bufnr },
										description = "show_diagnostics",
									},
									{
										"gG",
										function()
											require("navigator.diagnostics").show_buf_diagnostics()
										end,
										opts = { buffer = bufnr },
										description = "show_buf_diagnostics",
									},
									{
										"<Leader>dT",
										function()
											require("navigator.diagnostics").toggle_diagnostics()
										end,
										opts = { buffer = bufnr },
										description = "toggle_diagnostics",
									},
									{
										"]d",
										function()
											vim.diagnostic.goto_next()
										end,
										opts = { buffer = bufnr },
										description = "next diagnostics",
									},
									{
										"[d",
										function()
											vim.diagnostic.goto_prev()
										end,
										opts = { buffer = bufnr },
										description = "prev diagnostics",
									},
									{
										"]O",
										function()
											vim.diagnostic.set_loclist()
										end,
										opts = { buffer = bufnr },
										description = "diagnostics set loclist",
									},
									{
										"]r",
										function()
											require("navigator.treesitter").goto_next_usage()
										end,
										opts = { buffer = bufnr },
										description = "goto_next_usage",
									},
									{
										"[r",
										function()
											require("navigator.treesitter").goto_previous_usage()
										end,
										opts = { buffer = bufnr },
										description = "goto_previous_usage",
									},
									{
										"<C-LeftMouse>",
										function()
											vim.lsp.buf.definition()
										end,
										opts = { buffer = bufnr },
										description = "definition",
									},
									{
										"K",
										function()
											vim.lsp.handlers["textDocument/hover"] =
												vim.lsp.with(vim.lsp.handlers.hover, {
													border = "rounded",
												})
											return vim.lsp.buf.hover()
										end,
										opts = { buffer = bufnr },
										description = "hover doc",
									},
									{
										"g<LeftMouse>",
										function()
											vim.lsp.buf.implementation()
										end,
										opts = { buffer = bufnr },
										description = "implementation",
									},
									{
										"<Leader>k",
										function()
											require("navigator.dochighlight").hi_symbol()
										end,
										opts = { buffer = bufnr },
										description = "hi_symbol",
									},
									{
										"<Space>wa",
										function()
											require("navigator.workspace").add_workspace_folder()
										end,
										opts = { buffer = bufnr },
										description = "add_workspace_folder",
									},
									{
										"<Space>wr",
										function()
											require("navigator.workspace").remove_workspace_folder()
										end,
										opts = { buffer = bufnr },
										description = "remove_workspace_folder",
									},
									{
										"<Space>gm",
										function()
											require("navigator.formatting").range_format()
										end,
										mode = "n",
										opts = { buffer = bufnr },
										description = "range format operator e.g gmip",
									},
									{
										"<Space>wl",
										function()
											require("navigator.workspace").list_workspace_folders()
										end,
										opts = { buffer = bufnr },
										description = "list_workspace_folders",
									},
									{
										"<Space>la",
										mode = "n",
										function()
											require("navigator.codelens").run_action()
										end,
										opts = { buffer = bufnr },
										description = "run code lens action",
									},
								},
							},
						})

						-- Formatter --

						if client.name == "gopls" then
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						else
							if client.supports_method("textDocument/formatting") then
								vim.api.nvim_clear_autocmds({
									group = vim.api.nvim_create_augroup("LspFormatting", {}),
									buffer = bufnr,
								})
								vim.api.nvim_create_autocmd("BufWritePre", {
									group = vim.api.nvim_create_augroup("LspFormatting", {}),
									buffer = bufnr,
									callback = function()
										vim.lsp.buf.format({
											filter = function(client)
												return client.name == "null-ls"
											end,
											bufnr = bufnr,
											id = client.id,
											timeout_ms = 5000,
											async = true,
										})
									end,
								})
							end
							client.server_capabilities.documentFormattingProvider = true
							client.server_capabilities.documentRangeFormattingProvider = true
						end
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
					end),
					flags = {
						debounce_text_changes = 150,
					},
					root_dir = function(fname)
						return require("lspconfig").util.root_pattern(".git")(fname)
							or require("setup.utils").dirname(fname)
					end,
				}
				payload = vim.tbl_deep_extend("force", {}, options, payload or {})
				ensure_installed[#ensure_installed + 1] = server
				require("lspconfig")[server].setup(payload)
			end
			require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
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

	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "LspAttach",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua.with({
						extra_args = {
							"--indent-type",
							"Tabs",
							"--indent-width",
							"4",
						},
					}),
					null_ls.builtins.formatting.prettier.with({
						extra_args = {
							"--use-tabs",
							"true",
							"--tab-width",
							"4",
						},
					}),
				},
			})
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	{
		"ray-x/navigator.lua",
		branch = "master",
		event = { "BufReadPre", "BufNewFile" },
		lazy = true,
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
							-- format = function(diagnostic)
							-- 	if diagnostic.severity == vim.diagnostic.severity.ERROR then
							-- 		return string.format(" %s", diagnostic.message)
							-- 	elseif diagnostic.severity == vim.diagnostic.severity.WARN then
							-- 		return string.format("⚠️  %s", diagnostic.message)
							-- 	elseif diagnostic.severity == vim.diagnostic.severity.HINT then
							-- 		return string.format(" %s", diagnostic.message)
							-- 	elseif diagnostic.severity == vim.diagnostic.severity.INFO then
							-- 		return string.format(" %s", diagnostic.message)
							-- 	end
							-- 	return diagnostic.message
							-- end,
						},
						severity_sort = true,
					},
					diagnostic_virtual_text = true,
					diagnostic_update_in_insert = true,
					disply_diagnostic_qf = true,
				},
			})
		end,
	},
}
