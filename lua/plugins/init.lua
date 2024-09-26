return {
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      -- Copilot setup
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
    end,
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      -- log_level = 'debug',
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
    },
    config = function()
      require("telescope").setup {
        extensions = {
          undo = {
            -- Telescope Undo specific configuration
          },
        },
      }
      require("telescope").load_extension "undo"
      -- Keymap for Telescope Undo
      vim.api.nvim_set_keymap("n", "<Space>u", "<cmd>Telescope undo<cr>", { noremap = true, silent = true })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "json",
        "go",
        "python",
        "rust",
        "yaml",
      },
      lazy = false,
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      shell = "powershell --NoLogo",
      -- Default configuration for all terminals
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      close_on_exit = true,
      float_opts = {
        border = "curved",
        winblend = 0,
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      local Terminal = require("toggleterm.terminal").Terminal

      -- Floating terminal
      local float_term = Terminal:new {
        direction = "float",
        hidden = true,
      }
      function _FLOAT_TERM()
        float_term:toggle()
      end

      -- Horizontal terminal
      local horizontal_term = Terminal:new {
        direction = "horizontal",
        size = 15,
        hidden = true,
      }
      function _HORIZONTAL_TERM()
        horizontal_term:toggle()
      end

      -- Vertical terminal
      local vertical_term = Terminal:new {
        direction = "vertical",
        size = 80,
        hidden = true,
      }
      function _VERTICAL_TERM()
        vertical_term:toggle()
      end

      -- Lazygit
      local lazygit = Terminal:new {
        cmd = "lazygit",
        direction = "float",
        hidden = true,
      }
      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end
    end,
    keys = {
      { "<C-\\>", "<cmd>lua _FLOAT_TERM()<CR>", desc = "ToggleTerm float" },
      { "<leader>ts", "<cmd>lua _HORIZONTAL_TERM()<CR>", desc = "ToggleTerm horizontal split" },
      { "<leader>tv", "<cmd>lua _VERTICAL_TERM()<CR>", desc = "ToggleTerm vertical split" },
      { "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "ToggleTerm lazygit" },
    },
  },
}
