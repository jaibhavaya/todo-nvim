local M = {}

local function open_or_create_todo()
  local todo_dir = vim.fn.expand("~/.todo/")
  local today = os.date("%Y%m%d")
  local today_file = "todo" .. today .. ".md"
  local today_path = todo_dir .. today_file

  -- Ensure the ~/.todo directory exists
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

    -- Find the last to-do file
		print(last_file)
    if last_file then
      local last_file_lines = {}
      -- Read lines from the last file
      for line in io.lines(last_file) do
        table.insert(last_file_lines, line)
      end

      -- Extract incomplete tasks
      local incomplete_tasks = {}
      for _, line in ipairs(last_file_lines) do
				print(line)
        if line:match("^%[ %]") then
          table.insert(incomplete_tasks, line)
        end
      end

      -- Append incomplete tasks to today's file
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

  -- Open today's file
  vim.cmd("edit " .. today_path)
end

-- Create the :Todo command
vim.api.nvim_create_user_command("Todo", open_or_create_todo, {})

local function add_task()
  local task_description = vim.fn.input("Task description: ")
  if task_description and task_description ~= "" then
    local buf = vim.api.nvim_get_current_buf()
    local last_line = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_buf_set_lines(buf, last_line, last_line, false, { "", "[ ] " .. task_description })
  end
end

local function toggle_complete()
  local line = vim.fn.getline(".")
  if line:match("^%[ %]") then
    vim.fn.setline(".", (line:gsub("^%[ %]", "[X]")))
  end
end

local function toggle_incomplete()
  local line = vim.fn.getline(".")
  if line:match("^%[X%]") then
    vim.fn.setline(".", (line:gsub("^%[X%]", "[ ]")))
  end
end

M.setup = function()
  -- Keybindings
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      if vim.fn.expand("%:p"):match("^/Users/.*/.todo/todo%d+.md$") then
        vim.api.nvim_set_keymap("n", "<leader>ta", ":lua require('my_plugin.commands').add_task()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>tc", ":lua require('my_plugin.commands').toggle_complete()<CR>", { noremap = true, silent = true })
        vim.api.nvim_set_keymap("n", "<leader>ti", ":lua require('my_plugin.commands').toggle_incomplete()<CR>", { noremap = true, silent = true })
      end
    end,
  })
end

M.add_task = add_task
M.toggle_complete = toggle_complete
M.toggle_incomplete = toggle_incomplete

return M
