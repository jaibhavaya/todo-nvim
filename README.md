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
```
- `:Todo` to open todo list (will create a todo file if one doesn't exist for the day, and will copy over any incomplete tasks from the previous day)
- <leader>ta to add a task
- <leader>tc to toggle a task as complete
- <leader>ti to toggle a task as incomplete
```

