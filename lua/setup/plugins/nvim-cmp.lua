return function()
	local ok, cmp = pcall(require, "cmp")
	local compare = require("cmp.config.compare")
	local cmp_buffer = require("cmp_buffer")
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
		matching = {
			disallow_fuzzy_matching = false,
			disallow_partial_matching = false,
			disallow_prefix_unmatching = false,
			disallow_partial_fuzzy_matching = false,
		},
		window = {
			completion = {
				scrollbar = false,
				border = "rounded",
				winhighlight = "Normal:CmpMenu,FloatBorder:Pmenu,CursorLine:PmenuSel",
				side_padding = 1,
			},
			-- documentation = false,
			documentation = {
				border = "rounded",
				winhighlight = "Normal:CmpMenu,FloatBorder:Pmenu",
			},
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		sorting = {
			priority_weight = 2,
			comparators = {
				compare.scopes, -- treesitter scope
				compare.locality,
				compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
				compare.offset,
				compare.recently_used,
				compare.order,
			},
		},
		sources = cmp.config.sources({
			{ name = "luasnip", priority = 100, max_item_count = 4, group_index = 1 },
			{
				name = "buffer",
				priority = 90,
				max_item_count = 5,
				group_index = 1,
				option = {
					keyword_length = 3,
					indexing_interval = 200,
					indexing_batch_size = 1500,
					max_indexed_line_length = 1024 * 30, -- Size buffer pada kilo byte
					get_bufnrs = function() -- jika file melebihi 1 mb maka indexing tidak akan dilakukan sepenuhnya
						local buf = vim.api.nvim_get_current_buf()
						local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
						if byte_size > 1024 * 100 then -- 1 Megabyte max
							return {}
						end
						return { buf }
					end,
				},
			},
			{ name = "nvim_lsp", priority = 80, keyword_length = 3, max_item_count = 10, group_index = 1 },
			{ name = "path", priority = 20, group_index = 2 },
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
		experimental = { ghost_text = true },
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
