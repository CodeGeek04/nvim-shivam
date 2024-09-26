vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

vim.api.nvim_set_keymap("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

-- Function to handle Ctrl+D behavior
vim.cmd [[
function! SmartCtrlD()
    if expand('<cword>') ==# @/
        return "n"
    else
        return "*N"
    endif
endfunction
]]

-- Keymap for Ctrl+D to select current word and go to next occurrence, or just next occurrence if already selected
vim.api.nvim_set_keymap("n", "<C-d>", [[:execute "normal " . SmartCtrlD()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-d>", [[<Esc>:execute "normal " . SmartCtrlD()<CR>]], { noremap = true, silent = true })

-- Keymap for Copilot
vim.api.nvim_set_keymap("i", "<Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true, script = true })
vim.g.copilot_no_tab_map = true

vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize -2<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize +2<CR>", { noremap = true, silent = true })

vim.wo.relativenumber = true

local function open_nvim_tree()
  -- Simulate pressing Space+e to open NvimTree
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Space>e", true, false, true), "n", false)
end

-- Autocommand to open NvimTree on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.schedule(open_nvim_tree)
  end,
})

vim.keymap.set("n", "<Space>tt", function()
  require("base46").toggle_transparency()
end, { noremap = true, silent = true, desc = "Toggle transparency" })

require("conform").setup {
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    loa = { "stylua" },
  },
  formatters = {
    prettier = {
      command = "D:\\Dev\\nvim-formatters\\prettier.cmd",
    },
    stylua = {
      command = "D:\\Dev\\nvim-formatters\\stylua.cmd",
    },
  },
  log_level = vim.log.levels.DEBUG,
}

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    local conform = require "conform"
    conform.format { bufnr = args.buf }
  end,
})

-- Function to format Go files using gopls
function Format_go()
  -- Get the current buffer's file path
  local file_path = vim.fn.expand "%:p"

  -- Run gopls format command
  local cmd = string.format("gopls format %s", vim.fn.shellescape(file_path))
  local formatted = vim.fn.system(cmd)

  -- Check if formatting was successful
  if vim.v.shell_error == 0 then
    -- Save the cursor position
    local cursor_pos = vim.fn.getcurpos()

    -- Replace buffer contents with formatted text
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.split(formatted, "\n"))

    -- Restore cursor position
    vim.fn.setpos(".", cursor_pos)

    print "Go formatting completed"
  else
    print("Error formatting Go file: " .. formatted)
  end
end

vim.o.scrolloff = 100
vim.g.terminal_emulator = "powershell"

-- Set up the keybinding
vim.api.nvim_set_keymap("n", "<space>fg", ":lua Format_go()<CR>", { noremap = true, silent = true })

require("toggleterm").setup {
  shell = "powershell",
}

require("nvim-treesitter.configs").setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<leader>is",
      node_incremental = "<leader>is",
      scope_incremental = "<leader>ic",
      node_decremental = "<leader>id",
    },
  },
}
