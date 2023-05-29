local M = {}
M.setup = function()
	return require("obsidian").setup({
		daily_notes = { folder = "dailies" },
		dir = "~/Public/NOTES/",
		completion = { nvim_cmp = true },
		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
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
					"<leader>mn",
					function()
						vim.ui.input({ prompt = " Note Name" }, function(name)
							if name ~= nil then
								vim.cmd("ObsidianNew " .. name)
							end
						end)
					end,
					desc = "Create new Notes with name",
				},
				{
					"<leader>mt",
					function()
						vim.ui.input({ prompt = "Move note to project folder " }, function(name)
							if name ~= nil then
								vim.cmd(
									"!mv "
										.. vim.fn.expand("%:p")
										.. " "
										.. vim.fn.expand("~")
										.. "/Public/NOTES/projects/"
										.. name
								)
								vim.cmd("bd!")
							end
						end)
					end,
					desc = "Move to poject folder",
				},
			},
		},
	})
end
return M
