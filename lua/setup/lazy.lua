local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

return require("lazy").setup({
    defaults = { lazy = true, version = false },
    spec = { import = "plugins" },
    install = {
        missing = true,
    },
    change_detection = {
        enabled = true,
        notify = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
    },
})
