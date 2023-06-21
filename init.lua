vim.loader.enable()

local function safeRequire(module)
	local success, req = pcall(require, module)
	if success then
		return req
	end
	local msg = "Error loading " .. module
	local notifyInstalled, notify = pcall(require, "notify")
	if notifyInstalled then
		notify(" " .. msg, vim.log.levels.ERROR)
	else
		print(msg)
	end
end

safeRequire("core.options")
safeRequire("core.autocmds")
safeRequire("core.user")
safeRequire("core.lazy")
safeRequire("core.mappings")
