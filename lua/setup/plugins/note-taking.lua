local M = {}
M.setup_obsidian = function()
	return require("obsidian").setup({
		daily_notes = { folder = "dailies" },
		dir = "~/Public/NOTES/",
		completion = { nvim_cmp = true },
		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				suffix = title:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", "")
			else
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.date("%d%m%Y")) .. "_" .. suffix
		end,
		disable_frontmatter = false,
		note_frontmatter_func = function(note)
			local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
			local modified = tostring((ftime > 0) and os.date("%x %X", ftime))
			local out = { id = note.id, aliases = note.aliases, tags = note.tags, date = modified }
			if note.metadata ~= nil and require("obsidian").util.table_length(note.metadata) > 0 then
				for k, v in pairs(note.metadata) do
					out[k] = v
				end
			end
			return out
		end,
		templates = {
			subdir = "templates",
			date_format = "%Y-%m-%d-%a",
			time_format = "%H:%M",
		},
	})
end

M.cmd_obsidian = {
	"ObsidianBacklinks",
	"ObsidianToday",
	"ObsidianYesterday",
	"ObsidianOpen",
	"ObsidianNew",
	"ObsidianSearch",
	"ObsidianQuickSwitch",
	"ObsidianLink",
	"ObsidianLinkNew",
	"ObsidianFollowLink",
	"ObsidianTemplate",
}

M.cmd_mkdnflow = {
	"MkdnEnter",
	"MkdnNextLink",
	"MkdnPrevLink",
	"MkdnNextHeading",
	"MkdnPrevHeading",
	"MkdnGoBack",
	"MkdnGoForward",
	"MkdnCreateLink",
	"MkdnCreateLinkFromClipboard",
	"MkdnFollowLink",
	"MkdnDestroyLink",
	"MkdnTagSpan",
	"MkdnMoveSource",
	"MkdnYankAnchorLink",
	"MkdnYankFileAnchorLink",
	"MkdnIncreaseHeading",
	"MkdnDecreaseHeading",
	"MkdnToggleToDo",
	"MkdnUpdateNumbering",
	"MkdnNewListItem",
	"MkdnNewListItemBelowInsert",
	"MkdnNewListItemAboveInsert",
	"MkdnExtendList",
	"MkdnTable",
	"MkdnTableFormat",
	"MkdnTableNextCell",
	"MkdnTablePrevCell",
	"MkdnTableNewRowBelow",
	"MkdnTableNewRowAbove",
	"MkdnTableNewColAfter",
	"MkdnTableNewColBefore",
	"MkdnTab",
	"MkdnSTab",
	"MkdnFoldSection",
	"MkdnUnfoldSection",
	"Mkdnflow",
}

M.mkdnflow_setup = function()
	return require("mkdnflow").setup({
		modules = {
			bib = true,
			buffers = true,
			conceal = true,
			cursor = true,
			folds = true,
			links = true,
			lists = true,
			maps = true,
			paths = true,
			tables = true,
			yaml = false,
		},
		filetypes = { md = true, rmd = true, markdown = true },
		create_dirs = true,
		perspective = {
			priority = "first",
			fallback = "current",
			root_tell = false,
			nvim_wd_heel = false,
			update = false,
		},
		wrap = false,
		default_path = nil,
		bib = {
			find_in_root = true,
		},
		silent = false,
		links = {
			style = "markdown",
			name_is_source = false,
			conceal = false,
			context = 0,
			implicit_extension = nil,
			transform_implicit = false,
			transform_explicit = function(title)
				local suffix = ""
				if title ~= nil then
					suffix = title:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", "")
				else
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				return tostring(os.date("%d%m%Y")) .. "_" .. suffix
			end,
		},
		-- new_file_template = {
		-- 	use_template = false,
		-- 	placeholders = {
		-- 		before = {
		-- 			title = "link_title",
		-- 			date = "os_date",
		-- 		},
		-- 		after = {},
		-- 	},
		-- 	template = "# {{ title }}",
		-- },
		to_do = {
			symbols = { " ", "-", "v" },
			update_parents = true,
			not_started = " ",
			in_progress = "-",
			complete = "v",
		},
		tables = {
			trim_whitespace = true,
			format_on_move = true,
			auto_extend_rows = true,
			auto_extend_cols = true,
		},
		yaml = {
			bib = { override = false },
		},
	})
end

M.obsidian_expl = {
	{
		"<A-n>",
		function()
			require("neo-tree.command").execute({
				toggle = true,
				dir = vim.fn.expand("~") .. "/Public/NOTES",
				position = "left",
				source = "filesystem",
			})
		end,
		desc = "Explorer NeoTree (root dir)",
	},
}

M.note_keys = function()
	return require("legendary").keymaps({
		{
			itemgroup = "Obsidian & MKdnFlow",
			description = "Note me Daddy",
			icon = "🚀 ",
			keymaps = {
				{
					"<leader>nn",
					function()
						local suffix = ""
						for _ = 1, 4 do
							suffix = suffix .. string.char(math.random(65, 90))
						end
						return vim.cmd("ObsidianLinkNew " .. suffix)
					end,
					desc = "Create new Notes with name",
					mode = { "v" },
				},
				{
					"<leader>nl",
					"<cmd>ObsidianFollowLink<CR>",
					desc = "Obsidian Folow Link",
				},
				{
					"<leader>nc",
					"<cmd>ObsidianNew<cr>",
					desc = "Create new note",
				},
				{
					"<leader>nd",
					"<cmd>ObsidianToday<cr>",
					desc = "Create dailies note",
				},

				-- Mkdnflow keys --
				{ "<Tab>", "<cmd>MkdnTableNextCell<cr>", desc = "Next cell tabel", mode = { "i" } },
				{ "<S-Tab>", "<cmd>MkdnTablePrevCell<cr>", desc = "Prev cell table", mode = { "i" } },
				{ "<leader>ir", "<cmd>MkdnTableNewRowBelow<cr>", desc = "Table new row below" },
				{ "<leader>iR", "<cmd>MkdnTableNewRowAbove<cr>", desc = "Table new row above" },
				{ "<leader>ic", "<cmd>MkdnTableNewColAfter<cr>", desc = "Table new coloumn after" },
				{ "<leader>iC", "<cmd>MkdnTableNewColBefore<cr>", desc = "Table new coloumn before" },
				-- { "<CR>", "<cmd>MkdnNewListItem<cr>", desc = "New list item", mode = { "i" } },
			},
		},
	})
end
return M
