return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			{ "hrsh7th/cmp-buffer", lazy = true },
			{ "hrsh7th/cmp-path", lazy = true },
			{ "hrsh7th/cmp-cmdline", lazy = true },
			{ "saadparwaiz1/cmp_luasnip", lazy = true },
			{ "hrsh7th/cmp-nvim-lsp", lazy = true },
		},
		config = function()
			local _, cmp = pcall(require, "cmp")
			local compare = require("cmp.config.compare")

			cmp.setup({
				enabled = function()
					if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
						return false
					end
					return vim.g.cmp_enabled
				end,
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				window = {
					completion = {
						scrollbar = false,
						border = "rounded",
						winhighlight = "Normal:CmpMenu,FloatBorder:FloatBorder,Search:None,CursorLine:PmenuSel",
						side_padding = 1,
					},
					documentation = false,
					-- documentation = {
					-- 	border = "rounded",
					-- 	winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
					-- },
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sorting = {
					priority_weight = 2,
					comparators = {
						compare.score,
						compare.exact,
						compare.recently_used,
						compare.offset,
						compare.kind,
						compare.sort_text,
						compare.length,
						compare.order,
					},
				},
				sources = cmp.config.sources({
					{ name = "luasnip", priority = 100, max_item_count = 4 },
					{ name = "nvim_lsp", priority = 90, keyword_length = 3, max_item_count = 10 },
					{ name = "path", priority = 20 },
					{ name = "buffer", priority = 10, keyword_length = 3, max_item_count = 5 },
				}),
				formatting = {
					format = function(entry, vim_item)
						local cmp_kinds = require("ui.icons").kind
						local menu = entry.source.name

						if menu == "luasnip" or menu == "nvim_lsp" then
							vim_item.dup = 0
						end

						vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
						return vim_item
					end,
				},
				filetype = {
					{ "mysql", "sql" },
					{
						window = {
							documentation = cmp.config.disable,
						},
					},
				},
				experimental = { ghost_text = true },
				mapping = {
					["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
					["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
					["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
					["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
					["<C-y>"] = cmp.config.disable,
					["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif require("luasnip").expand_or_jumpable() then
							vim.fn.feedkeys(
								vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
								""
							)
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif require("luasnip").jumpable(-1) then
							vim.fn.feedkeys(
								vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true),
								""
							)
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
				},
			})

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				formatting = {
					fields = { "abbr" },
				},
				sources = cmp.config.sources({
					{ name = "buffer" },
				}),
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				formatting = {
					fields = { "abbr" },
				},
				sources = cmp.config.sources({
					{ name = "path", max_item_count = 5 },
					{ name = "cmdline", max_item_count = 10 },
				}),
			})
		end,
	},

	-- █████╗ █████╗ █████╗ █████╗ █████╗ █████╗
	-- ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝ ╚════╝

	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		build = (not jit.os:find("Windows"))
				and "echo -e 'NOTE: jsregexp is optional, so not a big deal if it fails to build\n'; make install_jsregexp"
			or nil,
		opts = { history = true, updateevents = "TextChanged,TextChangedI" },
		dependencies = { "rafamadriz/friendly-snippets", lazy = true },
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load({
				paths = vim.g.luasnippets_path or "",
			})

			vim.api.nvim_create_autocmd("InsertLeave", {
				callback = function()
					if
						require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
						and not require("luasnip").session.jump_active
					then
						require("luasnip").unlink_current()
					end
				end,
			})
		end,
	},
}
