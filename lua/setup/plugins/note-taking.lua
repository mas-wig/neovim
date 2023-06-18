local M = {}
M.template = {
	template = [[
---
id: "{{filename}}"
date: "{{date}}"
tags:
alias:
---
]],
	placeholders = {
		before = {
			date = function()
				return os.date("%A, %B %d, %Y") -- Wednesday, March 1, 2023
			end,
		},
		after = {
			filename = function()
				return vim.fn.expand("%:t:r")
			end,
		},
	},
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
			find_in_root = false,
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
				-- if title ~= nil then
				-- 	suffix = title:gsub(" ", "_"):gsub("[^A-Za-z0-9-]", "")
				-- else
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
				-- end
				return tostring(os.date("%d%m%Y")) .. "_" .. suffix
			end,
		},
		new_file_template = {
			use_template = true,
			placeholders = {
				before = M.template.placeholders.before,
				after = M.template.placeholders.after,
			},
			template = M.template.template,
		},
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
		mappings = {
			MkdnEnter = false,
			MkdnTab = false,
			MkdnSTab = false,
			MkdnNextLink = false,
			MkdnPrevLink = false,
			MkdnNextHeading = false,
			MkdnPrevHeading = false,
			MkdnGoBack = false,
			MkdnGoForward = false,
			MkdnCreateLink = false,
			MkdnCreateLinkFromClipboard = false,
			MkdnFollowLink = false,
			MkdnDestroyLink = false,
			MkdnTagSpan = false,
			MkdnMoveSource = false,
			MkdnYankAnchorLink = false,
			MkdnYankFileAnchorLink = false,
			MkdnIncreaseHeading = false,
			MkdnDecreaseHeading = false,
			MkdnToggleToDo = false,
			MkdnNewListItem = false,
			MkdnNewListItemBelowInsert = false,
			MkdnNewListItemAboveInsert = false,
			MkdnExtendList = false,
			MkdnUpdateNumbering = false,
			MkdnTableNextCell = false,
			MkdnTablePrevCell = false,
			MkdnTableNextRow = false,
			MkdnTablePrevRow = false,
			MkdnTableNewRowBelow = false,
			MkdnTableNewRowAbove = false,
			MkdnTableNewColAfter = false,
			MkdnTableNewColBefore = false,
			MkdnFoldSection = false,
			MkdnUnfoldSection = false,
		},
	})
end

M.mkdn_expl = {
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
			itemgroup = "MKdnFlow Note Taking",
			description = "Take a Note for me Daddy",
			icon = "🚀 ",
			keymaps = {
				{ "<leader>nn", "<cmd>MkdnEnter<cr>", desc = "Create New Note" },
				{ "<leader>nL", "<cmd>MkdnNextLink<cr>", desc = "Navigate to Next Link" },
				{ "<leader>nP", "<cmd>MkdnPrevLink<cr>", desc = "Navigate to Previous Link" },
				{ "<leader>nh", "<cmd>MkdnNextHeading<cr>", desc = "Navigate to Next Heading" },
				{ "<leader>ng", "<cmd>MkdnPrevHeading<cr>", desc = "Navigate to Previous Heading" },
				{ "<leader>nb", "<cmd>MkdnGoBack<cr>", desc = "Go Back" },
				{ "<leader>nf", "<cmd>MkdnGoForward<cr>", desc = "Go Forward" },
				{ "<leader>ncl", "<cmd>MkdnCreateLink<cr>", desc = "Create Link", mode = { "n", "v" } },
				{ "<leader>ncL", "<cmd>MkdnCreateLinkFromClipboard<cr>", desc = "Create Link from Clipboard" },
				{ "<leader>nl", "<cmd>MkdnFollowLink<cr>", desc = "Follow Link", mode = { "n", "v" } },
				{ "<leader>nx", "<cmd>MkdnDestroyLink<cr>", desc = "Destroy Link" },
				{ "<leader>nt", "<cmd>MkdnTagSpan<cr>", desc = "Tag Span" },
				{ "<leader>nm", "<cmd>MkdnMoveSource<cr>", desc = "Move Source" },
				{ "<leader>ny", "<cmd>MkdnYankAnchorLink<cr>", desc = "Yank Anchor Link" },
				{ "<leader>nY", "<cmd>MkdnYankFileAnchorLink<cr>", desc = "Yank File Anchor Link" },
				{ "<leader>ni", "<cmd>MkdnIncreaseHeading<cr>", desc = "Increase Heading Level" },
				{ "<leader>nd", "<cmd>MkdnDecreaseHeading<cr>", desc = "Decrease Heading Level" },
				{ "<leader>Nt", "<cmd>MkdnToggleToDo<cr>", desc = "Toggle Todo" },
				{ "<leader>nu", "<cmd>MkdnUpdateNumbering<cr>", desc = "Update Numbering" },
				{ "<leader>ni", "<cmd>MkdnNewListItem<cr>", desc = "New List Item" },
				{ "<leader>nbli", "<cmd>MkdnNewListItemBelowInsert<cr>", desc = "New List Item Below and Insert" },
				{ "<leader>nai", "<cmd>MkdnNewListItemAboveInsert<cr>", desc = "New List Item Above and Insert" },
				{ "<leader>nel", "<cmd>MkdnExtendList<cr>", desc = "Extend List" },
				{ "<leader>ntt", "<cmd>MkdnTable<cr>", desc = "Table" },
				{ "<leader>ntf", "<cmd>MkdnTableFormat<cr>", desc = "Table Format" },
				{ "<leader>ntn", "<cmd>MkdnTableNextCell<cr>", desc = "Table Next Cell" },
				{ "<leader>ntp", "<cmd>MkdnTablePrevCell<cr>", desc = "Table Previous Cell" },
				{ "<leader>ntb", "<cmd>MkdnTableNewRowBelow<cr>", desc = "Table New Row Below" },
				{ "<leader>nta", "<cmd>MkdnTableNewRowAbove<cr>", desc = "Table New Row Above" },
				{ "<leader>ntca", "<cmd>MkdnTableNewColAfter<cr>", desc = "Table New Column After" },
				{ "<leader>ntcb", "<cmd>MkdnTableNewColBefore<cr>", desc = "Table New Column Before" },
				{ "<leader>nt", "<cmd>MkdnTab<cr>", desc = "Tab" },
				{ "<leader>nT", "<cmd>MkdnSTab<cr>", desc = "Shift + Tab" },
				{ "<leader>nf", "<cmd>MkdnFoldSection<cr>", desc = "Fold Section" },
				{ "<leader>nF", "<cmd>MkdnUnfoldSection<cr>", desc = "Unfold Section" },
				{ "<leader>nN", "<cmd>Mkdnflow<cr>", desc = "Flow" },
			},
		},
	})
end
return M
