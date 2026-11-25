local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local spec = {
  { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "plugins" },
}
if vim.g.agentbox_lockfile then
  local lock = vim.json.decode(table.concat(vim.fn.readfile(vim.g.agentbox_lockfile), "\n"))
  for name, entry in pairs(lock) do
    table.insert(spec, { name, optional = true, commit = entry.commit, branch = entry.branch })
  end
end

require("lazy").setup({
  lockfile = vim.g.agentbox_lockfile,
  spec = spec,
  defaults = {
    lazy = false,
    version = false,
  },
  install = { missing = vim.g.agentbox_lockfile == nil, colorscheme = { "tokyonight", "habamax" } },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
