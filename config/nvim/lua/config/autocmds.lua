vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.schedule(function()
      if vim.bo.buftype == "" then
        vim.cmd("checktime")
      end
    end)
  end,
})
