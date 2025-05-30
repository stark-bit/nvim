return {
  "nvim-telescope/telescope.nvim",

  tag = "0.1.5",

  dependencies = {
    "nvim-lua/plenary.nvim"
  },

  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          },
          n = {
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          }
        },
        path_display = { "truncate" },
        dynamic_preview_title = true,
        file_ignore_patterns = {
          "node_modules/",
          "dist/",
          "build/",
          "target/",
          ".git/",
          "public/static/libs/pdf"
        },
      },
    })

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>pws', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>pWs', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)
    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

    vim.keymap.set('n', '<leader>prs', builtin.live_grep, {})
    -- New keybinding for live_grep within quickfix list files
    vim.keymap.set('n', '<leader>prq', function()
      -- Get the list of files from the quickfix list
      local qflist = vim.fn.getqflist({ items = 0, all = 1 })
      local unique_files = {}
      local files_hash = {}

      for _, item in ipairs(qflist.items) do
        if item.bufnr ~= 0 then
          local filename = vim.fn.bufname(item.bufnr)
          if filename ~= "" and not files_hash[filename] then
            files_hash[filename] = true
            table.insert(unique_files, filename)
          end
        end
      end

      if #unique_files > 0 then
        builtin.live_grep({
          search_dirs = unique_files
        })
      else
        print("Quickfix list is empty or contains no valid files.")
      end
    end)
  end
}
