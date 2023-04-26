local utils = {}

utils.map = function(mode, lhs, rhs, opts)
	local keys = require("lazy.core.handler").handlers.keys
	if not keys.active[keys.parse({ lhs, mode = mode }).id] then
		opts = opts or {}
		opts.silent = opts.silent ~= false
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

utils.dirname = function(pathname)
	local path_sep = "/"
	local strip_dir_pat = path_sep .. "([^" .. path_sep .. "]+)$"
	local strip_sep_pat = path_sep .. "$"
	if not pathname or #pathname == 0 then
		return
	end
	local result = pathname:gsub(strip_sep_pat, ""):gsub(strip_dir_pat, "")
	if #result == 0 then
		return "/"
	end
	return result
end

utils.root_patterns = { ".git" } --require("lspconfig").util.root_pattern(".git")(fname) or utils.dirname(fname)

utils.has = function(plugin)
	return require("lazy.core.config").plugins[plugin] ~= nil
end

utils.get_root = function()
	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= "" and vim.loop.fs_realpath(path) or nil
	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace
					and vim.tbl_map(function(ws)
						return vim.uri_to_fname(ws.uri)
					end, workspace)
				or client.config.root_dir and { client.config.root_dir }
				or {}
			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p)
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.loop.cwd()
		root = vim.fs.find(utils.root_patterns, { path = path, upward = true })[1]
		root = root and vim.fs.dirname(root) or vim.loop.cwd()
	end
	return root
end

utils.on_very_lazy = function(fn)
	vim.api.nvim_create_autocmd("User", {
		pattern = "VeryLazy",
		callback = function()
			fn()
		end,
	})
end

return utils
