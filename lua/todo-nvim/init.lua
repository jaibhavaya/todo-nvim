local M = {}

M.setup = function()
  require("todo-nvim.highlights").setup()
  require("todo-nvim.commands").setup()
end

return M
