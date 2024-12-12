local config = require("todo-nvim.config")
local commands = require("todo-nvim.commands")

local M = {}

M.setup = function(user_config)
  -- Pass user configuration to the shared config module
  config.setup(user_config)

  -- Register commands
  commands.register()

  -- Set up autocmds and keybindings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      if vim.fn.expand("%:p"):match("^" .. config.todo_dir .. "todo%d+.md$") then
        vim.api.nvim_set_keymap("n", "<leader>ta", ":TodoAdd<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>tc", ":TodoComplete<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>ti", ":TodoIncomplete<CR>", { noremap = true, silent = true })
      end
    end,
  })
end

return M
