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

			local lsp_keymap = require("setup.utils").map
			local telescope = require("telescope.builtin")

			for name, icon in pairs(require("ui.icons").diagnostics) do
				name = "DiagnosticSign" .. name
				vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
			end

			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 10,
					underline = true,
					update_in_insert = true,
					prefix = "  ",
					format = function(diagnostic)
						if diagnostic.severity == vim.diagnostic.severity.ERROR then
							return string.format(" %s", diagnostic.message)
						elseif diagnostic.severity == vim.diagnostic.severity.WARN then
							return string.format("⚠️  %s", diagnostic.message)
						elseif diagnostic.severity == vim.diagnostic.severity.HINT then
							return string.format(" %s", diagnostic.message)
						elseif diagnostic.severity == vim.diagnostic.severity.INFO then
							return string.format(" %s", diagnostic.message)
						end
						return diagnostic.message
					end,
				},
				severity_sort = true,
			})

			local ensure_installed = {}
			for server, payload in pairs(opts.server) do
				local options = {
					capabilities = capabilities,
					on_attach = require("setup.utils").set_on_attach(function(client, bufnr)
						-- KEYMAP --
						lsp_keymap("i", "<C-k>", function()
							vim.lsp.handlers["textDocument/signatureHelp"] =
								vim.lsp.with(vim.lsp.handlers.signature_help, {
									border = "rounded",
								})
							return vim.lsp.buf.signature_help()
						end, { desc = "signature help", buffer = bufnr })

						if client.supports_method("textDocument/implementation") then
							lsp_keymap("n", "gi", function()
								telescope.lsp_implementations()
							end, { desc = "goto implementation", buffer = bufnr })
						end

						if client.supports_method("workspace/symbol") then
							lsp_keymap("n", "<leader>ws", function()
								telescope.lsp_workspace_symbols()
							end, { desc = "lsp workspace symbol", buffer = bufnr })
						end

						lsp_keymap("n", "<leader>wa", function()
							vim.lsp.buf.add_workspace_folder()
						end, { desc = "add to workspace", buffer = bufnr })

						lsp_keymap("n", "<leader>wr", function()
							vim.lsp.buf.remove_workspace_folder()
						end, { desc = "remove workspace folder", buffer = bufnr })

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
		"glepnir/lspsaga.nvim",
		event = "LspAttach",
		cmd = "Lspsaga",
		config = function()
			require("lspsaga").setup({
				ui = {
					title = true,
					border = "rounded",
					winblend = 0,
					expand = "",
					collapse = "",
					code_action = "💡",
					incoming = " ",
					outgoing = " ",
					hover = " ",
				},
				symbol_in_winbar = {
					enable = false,
				},
			})
		end,
		keys = function()
			require("legendary").keymaps({
				{
					itemgroup = "LspSaga",
					description = "Inside me daddy",
					icon = "🐯",
					keymaps = {
						{ "gh", "<cmd>Lspsaga lsp_finder<CR>", desc = "lsp reference" },
						{ "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "lsp code action", mode = { "n", "v" } },
						{ "gr", "<cmd>Lspsaga rename<CR>", desc = "lsp rename" },
						{ "gr", "<cmd>Lspsaga rename ++project<CR>", desc = "lsp global rename" },
						{ "gp", "<cmd>Lspsaga peek_definition<CR>", desc = "lsp peek definition" },
						{ "gd", "<cmd>Lspsaga goto_definition<CR>", desc = "lsp goto definition" },
						{ "gt", "<cmd>Lspsaga peek_type_definition<CR>", desc = "lsp peek type def" },
						{ "gT", "<cmd>Lspsaga goto_type_definition<CR>", desc = "lsp goto type def" },
						{ "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "lsp line diagnostics" },
						{ "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc = "lsp buf diagnostics" },
						{ "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>", desc = "lsp workspace diag" },
						{ "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "lsp cursor diag" },
						{ "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "lsp diagnostic jump prev" },
						{ "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "lsp diagnostic jump next" },
						{
							"[E",
							function()
								require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
							end,
							desc = "lsp goto error prev",
						},
						{
							"]E",
							function()
								require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
							end,
							desc = "lsp goto error next",
						},
						{ "<leader>o", "<cmd>Lspsaga outline<CR>", desc = "lsp outline" },
						{ "K", "<cmd>Lspsaga hover_doc<CR>", desc = "lsp hover docs" },
						{ "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", desc = "lsp incoming call" },
						{ "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", desc = "lsp outcoming call " },
					},
				},
			})
		end,
	},
}
