local M = {}
M.setup = function()
	return require("obsidian").setup({
		daily_notes = { folder = "Dailies" },
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
			return tostring(os.date("%d-%m-%Y")) .. "_" .. suffix
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

M.init = function()
	require("legendary").keymaps({
		{
			itemgroup = "Obsidian",
			description = "Notes me Daddy",
			icon = "🔭",
			keymaps = {
				{
					"<leader>fn",
					function()
						vim.ui.input({ prompt = " Note Name" }, function(name)
							if name ~= nil then
								vim.cmd("ObsidianLinkNew " .. name)
							end
						end)
					end,
					desc = "Create new Notes with name",
					mode = { "v" },
				},
				{
					"<leader>n",
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
				{
					"<leader>fl",
					"<cmd>ObsidianFollowLink<CR>",
					desc = "Obsidian Folow Link",
				},
			},
		},
	})
end
return M
