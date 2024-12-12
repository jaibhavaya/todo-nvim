local config = require("todo-nvim.config")

local M = {}

function M.register()
  vim.api.nvim_create_user_command("Todo", function()
    local todo_dir = config.todo_dir
    local today = os.date("%Y%m%d")
    local today_file = "todo" .. today .. ".md"
    local today_path = todo_dir .. today_file

    -- Ensure the todo directory exists
    if vim.fn.isdirectory(todo_dir) == 0 then
      vim.fn.mkdir(todo_dir, "p")
    end

    -- Function to find the most recent file
    local function get_last_todo_file()
      local files = vim.fn.glob(todo_dir .. "todo*.md", 0, 1)
      if #files > 0 then
        table.sort(files)
        return files[#files]
      end
      return nil
    end

    -- Create today's file if it doesn't exist
    if vim.fn.filereadable(today_path) == 0 then
      local last_file = get_last_todo_file()
      local file = io.open(today_path, "w")
      file:write("# To-Do List for " .. os.date("%Y-%m-%d") .. "\n\n")
      file:close()

      -- Append incomplete tasks from the last file
      if last_file then
        local last_file_lines = {}
        for line in io.lines(last_file) do
          table.insert(last_file_lines, line)
        end

        local incomplete_tasks = {}
        for _, line in ipairs(last_file_lines) do
          if line:match("^%[ %]") then
            table.insert(incomplete_tasks, line)
          end
        end

        if #incomplete_tasks > 0 then
          local today_file_handle = io.open(today_path, "a")
          today_file_handle:write("## Incomplete Tasks from " .. last_file:match("todo(%d+).md") .. "\n")
          for _, task in ipairs(incomplete_tasks) do
            today_file_handle:write(task .. "\n")
          end
          today_file_handle:close()
        end
      end
    end

    vim.cmd("edit " .. today_path)
  end, {})

  vim.api.nvim_create_user_command("TodoAdd", function()
    local task_description = vim.fn.input("Task description: ")
    if task_description and task_description ~= "" then
      local buf = vim.api.nvim_get_current_buf()
      local last_line = vim.api.nvim_buf_line_count(buf)
      vim.api.nvim_buf_set_lines(buf, last_line, last_line, false, { "", "[ ] " .. task_description })
    end
  end, {})

  vim.api.nvim_create_user_command("TodoComplete", function()
    local line = vim.fn.getline(".")
    if line:match("^%[ %]") then
      vim.fn.setline(".", (line:gsub("^%[ %]", "[X]")))
    end
  end, {})

  vim.api.nvim_create_user_command("TodoIncomplete", function()
    local line = vim.fn.getline(".")
    if line:match("^%[X%]") then
      vim.fn.setline(".", (line:gsub("^%[X%]", "[ ]")))
    end
  end, {})
end

return M
