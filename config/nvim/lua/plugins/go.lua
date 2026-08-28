return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          mason = false,
        },
      },
    },
  },
}
