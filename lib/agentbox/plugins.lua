local repo = assert(arg[1], "dotfiles checkout is required")
local lockfile = repo .. "/config/nvim/lazy-lock.json"
local temporary_lock = vim.fn.tempname()

local function read(path)
  local file = assert(io.open(path, "rb"))
  local contents = file:read("*a")
  file:close()
  return contents
end

local function git(arguments)
  local output = vim.fn.system(vim.list_extend({ "git" }, arguments))
  assert(vim.v.shell_error == 0, output)
  return vim.trim(output)
end

local function apply()
  local original = read(lockfile)
  local lock = vim.json.decode(original)
  for name, entry in pairs(lock) do
    assert(type(entry.commit) == "string" and #entry.commit == 40 and entry.commit:match("^%x+$"),
      "Invalid locked commit for " .. name)
    assert(type(entry.branch) == "string" and entry.branch ~= "", "Missing locked branch for " .. name)
  end
  local function write_lock()
    local file = assert(io.open(temporary_lock, "wb"))
    file:write(original)
    file:close()
  end
  write_lock()
  vim.g.agentbox_lockfile = temporary_lock
  local root = vim.fn.stdpath("data") .. "/lazy"

  for name, url in pairs({
    ["lazy.nvim"] = "https://github.com/folke/lazy.nvim.git",
    LazyVim = "https://github.com/LazyVim/LazyVim.git",
  }) do
    local commit = assert(lock[name], "Missing lock entry for " .. name).commit
    local directory = root .. "/" .. name
    if not (vim.uv or vim.loop).fs_stat(directory) then
      git({ "clone", "--filter=blob:none", url, directory })
    end
    assert(git({ "-C", directory, "status", "--porcelain" }) == "", "Local plugin changes in " .. name)
    git({ "-C", directory, "fetch", "origin", commit })
    git({ "-C", directory, "checkout", "--detach", commit })
  end

  vim.opt.rtp:prepend(repo .. "/config/nvim")
  vim.go.loadplugins = true
  require("config.lazy")
  local config = require("lazy.core.config")
  for name in pairs(config.plugins) do
    assert(lock[name], "Missing lock entry for " .. name)
  end
  local function check_errors()
    for name, plugin in pairs(config.plugins) do
      assert(not require("lazy.core.plugin").has_errors(plugin), "Plugin operation failed: " .. name)
    end
  end
  require("lazy").install({ wait = true, lockfile = true, show = false })
  check_errors()
  write_lock()
  require("lazy.manage.lock").lock = vim.deepcopy(lock)
  require("lazy").restore({ wait = true, show = false })
  check_errors()
  for name, entry in pairs(lock) do
    assert(git({ "-C", root .. "/" .. name, "rev-parse", "HEAD" }) == entry.commit,
      "Installed plugin does not match lock: " .. name)
  end
  assert(read(lockfile) == original, "The published plugin lockfile changed")
end

local ok, err = xpcall(apply, debug.traceback)
vim.fn.delete(temporary_lock)
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
