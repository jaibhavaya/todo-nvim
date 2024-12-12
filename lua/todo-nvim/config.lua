local M = {
  todo_dir = vim.fn.expand("~/.todo/"), -- Default directory
}

function M.setup(user_config)
  if user_config then
    M = vim.tbl_deep_extend("force", M, user_config)
  end
end

return M
