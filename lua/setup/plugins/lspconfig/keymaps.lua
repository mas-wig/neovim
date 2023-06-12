local M = {}

M._keys = nil
function M.get()
	if not M._keys then
		M._keys = {
			{
				"gr",
				function()
					require("navigator.reference").async_ref()
				end,
				desc = "⚡️ Async Ref",
			},
			{
				"<Leader>gr",
				function()
					require("navigator.reference").reference()
				end,
				desc = "⚡️ Reference",
			}, -- reference deprecated
			{
				"<c-k>",
				function()
					vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
						border = "rounded",
						wrap = true,
					})
					return vim.lsp.buf.signature_help()
				end,
				mode = "i",
				desc = "⚡️ Signature Help",
			},
			{
				"K",
				function()
					vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
						border = "rounded",
						wrap = true,
					})
					return vim.lsp.buf.hover()
				end,
				desc = "⚡️ Hover",
			},
			-- {
			-- 	"g0",
			-- 	function()
			-- 		require("navigator.symbols").document_symbols()
			-- 	end,
			-- 	desc = "⚡️ Document Symbols",
			-- },
			-- {
			-- 	"gW",
			-- 	function()
			-- 		require("navigator.workspace").workspace_symbol_live()
			-- 	end,
			-- 	desc = "⚡️ Workspace Symbols Live",
			-- },
			{
				"gd",
				function()
					require("navigator.definition").definition()
				end,
				desc = "⚡️ Definition",
			},
			{
				"gD",
				function()
					vim.lsp.buf.declaration()
				end,
				desc = "⚡️ Declaration",
			},

			{
				"gt",
				function()
					vim.lsp.buf.type_definition()
				end,
				desc = "⚡️ Type Definition",
			},
			{
				"gp",
				function()
					require("navigator.definition").definition_preview()
				end,
				desc = "Definition Preview",
			},
			{
				"gP",
				function()
					require("navigator.definition").type_definition_preview()
				end,
				desc = "⚡️ Type Definition Preview",
			},
			-- {
			-- 	"<Leader>gt",
			-- 	function()
			-- 		require("navigator.treesitter").buf_ts()
			-- 	end,
			-- 	desc = "⚡️ Buf TS",
			-- },
			-- {
			-- 	"<Leader>gT",
			-- 	function()
			-- 		require("navigator.treesitter").bufs_ts()
			-- 	end,
			-- 	desc = "⚡️ Bufs TS",
			-- },
			-- {
			-- 	"<Leader>ct",
			-- 	function()
			-- 		require("navigator.ctags").ctags()
			-- 	end,
			-- 	desc = "⚡️ Ctags",
			-- },
			{
				"<leader>ca",
				mode = "n",
				function()
					require("navigator.codeAction").code_action()
				end,
				desc = "⚡️ Code Action",
			},
			{
				"<leader>ca",
				mode = "v",
				function()
					require("navigator.codeAction").range_code_action()
				end,
				desc = "⚡️ Range Code Action",
			},
			-- {  '<Leader>re', function() 'rename()' },
			{
				"<leader>rn",
				function()
					require("navigator.rename").rename()
				end,
				desc = "⚡️ Rename",
			},
			{
				"<Leader>gi",
				function()
					vim.lsp.buf.incoming_calls()
				end,
				desc = "⚡️ Incoming Calls",
			},
			{
				"<Leader>go",
				function()
					vim.lsp.buf.outgoing_calls()
				end,
				desc = "⚡️ Outgoing Calls",
			},
			{
				"gi",
				function()
					vim.lsp.buf.implementation()
				end,
				desc = "⚡️ Implementation",
			},
			{
				"gL",
				function()
					require("navigator.diagnostics").show_diagnostics()
				end,
				desc = "⚡️ Show Diagnostics",
			},
			{
				"gG",
				function()
					require("navigator.diagnostics").show_buf_diagnostics()
				end,
				desc = "⚡️ Show Buf Diagnostics",
			},
			{
				"<Leader>dt",
				function()
					require("navigator.diagnostics").toggle_diagnostics()
				end,
				desc = "⚡️ Toggle Diagnostics",
			},
			{
				"]d",
				function()
					vim.diagnostic.goto_next()
				end,
				desc = "⚡️ Next Diagnostics",
			},
			{
				"[d",
				function()
					vim.diagnostic.goto_prev()
				end,
				desc = "⚡️ Prev Diagnostics",
			},
			{
				"]O",
				function()
					vim.diagnostic.set_loclist()
				end,
				desc = "⚡️ Diagnostics set loclist",
			},
			{
				"]r",
				function()
					require("navigator.treesitter").goto_next_usage()
				end,
				desc = "⚡️ Goto Next Usage",
			},
			{
				"[r",
				function()
					require("navigator.treesitter").goto_previous_usage()
				end,
				desc = "⚡️ Goto Previous Usage",
			},
			-- {
			-- 	"<Leader>k",
			-- 	function()
			-- 		require("navigator.dochighlight").hi_symbol()
			-- 	end,
			-- 	desc = "⚡️ HI Symbol",
			-- },
			{
				"<leader>wa",
				function()
					require("navigator.workspace").add_workspace_folder()
				end,
				desc = "⚡️ Add Workspace Folder",
			},
			{
				"<leader>wr",
				function()
					require("navigator.workspace").remove_workspace_folder()
				end,
				desc = "⚡️ Remove Workspace Folder",
			},
			-- {
			-- 	"<leader>ff",
			-- 	function()
			-- 		vim.lsp.buf.format()
			-- 	end,
			-- 	mode = "n",
			-- 	desc = "⚡️ Format",
			-- },
			-- {
			-- 	"<leader>ff",
			-- 	function()
			-- 		vim.lsp.buf.range_formatting()
			-- 	end,
			-- 	mode = "v",
			-- 	desc = "⚡️ Range format",
			-- },
			-- {
			-- 	"<leader>gm",
			-- 	function()
			-- 		require("navigator.formatting").range_format()
			-- 	end,
			-- 	mode = "n",
			-- 	desc = "⚡️  Range format operator e.g gmip",
			-- },
			{
				"<leader>wl",
				function()
					require("navigator.workspace").list_workspace_folders()
				end,
				desc = "⚡️ List workspace folders",
			},
			{
				"<leader>la",
				mode = "n",
				function()
					require("navigator.codelens").run_action()
				end,
				desc = "⚡️ Run code lens action",
			},
		}
	end
	return M._keys
end

function M.on_attach(client, buffer)
	local Keys = require("lazy.core.handler.keys")
	local keymaps = {}

	for _, value in ipairs(M.get()) do
		local keys = Keys.parse(value)
		if keys[2] == vim.NIL or keys[2] == false then
			keymaps[keys.id] = nil
		else
			keymaps[keys.id] = keys
		end
	end

	for _, keys in pairs(keymaps) do
		if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
			local opts = Keys.opts(keys)
			opts.has = nil
			opts.silent = opts.silent ~= false
			opts.buffer = buffer

			require("legendary").keymaps({
				{
					itemgroup = "Navigator",
					description = "Navigate me Daddy",
					icon = "🚀 ",
					keymaps = {
						{
							keys[1],
							keys[2],
							opts = { silent = opts.silent, buffer = opts.buffer },
							description = opts.desc,
							mode = { keys.mode or "n" },
						},
					},
				},
			})
		end
	end
end

return M
