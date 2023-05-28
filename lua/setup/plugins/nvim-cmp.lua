return function()
	local ok, cmp = pcall(require, "cmp")
	local compare = require("cmp.config.compare")

	if not ok then
		return
	end

	local duplicates = {
		buffer = 1,
		path = 1,
		nvim_lsp = 0,
		luasnip = 1,
	}

	cmp.setup({
		completion = {
			completeopt = "menu,menuone,noinsert",
		},
		window = {
			completion = {
				scrollbar = false,
				border = "rounded",
				winhighlight = "Normal:CmpMenu,FloatBorder:WinSeparator,Search:None,CursorLine:PmenuSel",
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
			comparators = {
				compare.score,
				compare.recently_used,
				compare.offset,
				compare.exact,
				compare.kind,
				compare.sort_text,
				compare.length,
				compare.order,
			},
		},
		sources = cmp.config.sources({
			{ name = "luasnip", priority = 100, max_item_count = 4, group_index = 1 },
			{ name = "rg", priority = 95, max_item_count = 2, group_index = 1 },
			{ name = "nvim_lsp", priority = 90, keyword_length = 3, max_item_count = 10, group_index = 1 },
			{ name = "path", priority = 20, group_index = 2 },
			{ name = "buffer", priority = 10, keyword_length = 3, max_item_count = 5, group_index = 2 },
		}),
		formatting = {
			format = function(entry, vim_item)
				local duplicates_default = 0
				local cmp_kinds = require("setup.ui.icons").kind
				local menu = entry.source.name
				vim_item.dup = duplicates[menu] or duplicates_default
				vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
				return vim_item
			end,
		},
		experimental = { ghost_text = false },
		filetype = {
			{ "sql", "mysql", "txt", "sh" },
			{ experimental = { ghost_text = false }, window = { documentation = false } },
		},
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
			["<CR>"] = cmp.mapping.confirm({ select = true }),
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
					vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
				else
					fallback()
				end
			end, {
				"i",
				"s",
			}),
		},
	})

	cmp.setup.cmdline({ "/", "?" }, {
		formatting = { fields = { cmp.ItemField.Abbr } },
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	cmp.setup.cmdline(":", {
		formatting = { fields = { cmp.ItemField.Abbr } },
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
			{ name = "cmdline_history" },
			{
				name = "cmdline",
				option = {
					ignore_cmds = { "Man", "!" },
				},
			},
		}),
	})
end
