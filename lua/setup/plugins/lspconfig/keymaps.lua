return require("setup.plugins.lspconfig").on_attach(function(_, bufnr)
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
						vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
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
							border = "single",
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
end)
