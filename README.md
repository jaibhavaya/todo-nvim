# todo-nvim
a very simple todo list plugin for neovim

# Install via packer:
```
use {
    "jaibhavaya/todo-nvim",
    config = function()
        require("todo-nvim").setup()
end
```

# Usage:
- `:Todo` to open todo list (will create a todo file if one doesn't exist for the day, and will copy over any incomplete tasks from the previous day)
- `:TodoAdd` to add a task (default <leader>ta)
- `:TodoComplete` to toggle a task as complete (default <leader>tc)
- `:TodoIncomplete` to toggle a task as incomplete (default <leader>ti)

