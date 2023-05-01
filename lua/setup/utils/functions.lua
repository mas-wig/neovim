local fn = {}
local Util = require("lazy.core.util")
local conceal_ns = vim.api.nvim_create_namespace("class_conceal")

function fn.ChangeFiletype()
	vim.ui.input({ prompt = "Change filetype to: " }, function(new_ft)
		if new_ft ~= nil then
			vim.bo.filetype = new_ft
		end
	end)
end

function fn.toggle(option, silent, values)
	if values then
		if vim.opt_local[option]:get() == values[1] then
			vim.opt_local[option] = values[2]
		else
			vim.opt_local[option] = values[1]
		end
		return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
	end
	vim.opt_local[option] = not vim.opt_local[option]:get()
	if not silent then
		if vim.opt_local[option]:get() then
			Util.info("Enabled " .. option, { title = "Option" })
		else
			Util.warn("Disabled " .. option, { title = "Option" })
		end
	end
end

function fn.float_term(cmd, opts)
	opts = vim.tbl_deep_extend("force", {
		size = { width = 0.9, height = 0.9 },
	}, opts or {})
	require("lazy.util").float_term(cmd, opts)
end

local enabled = true

function fn.toggle_diagnostics()
	enabled = not enabled
	if enabled then
		vim.diagnostic.enable()
		Util.info("Enabled diagnostics", { title = "Diagnostics" })
	else
		vim.diagnostic.disable()
		Util.warn("Disabled diagnostics", { title = "Diagnostics" })
	end
end

function fn.ConcealHTML(bufnr)
	local language_tree = vim.treesitter.get_parser(bufnr, "html")
	local syntax_tree = language_tree:parse()
	local root = syntax_tree[1]:root()

	local query = vim.treesitter.query.parse(
		"html",
		[[
        ((
          attribute
                (attribute_name) @att_name (#eq? @att_name "class")
                (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "📦")
        ))
        ]]
	)
	for _, captures, metadata in query:iter_matches(root, bufnr, root:start(), root:end_()) do
		local start_row, start_col, end_row, end_col = captures[2]:range()
		vim.api.nvim_buf_set_extmark(bufnr, conceal_ns, start_row, start_col, {
			end_line = end_row,
			end_col = end_col,
			conceal = metadata[2].conceal,
		})
	end
end

return fn
