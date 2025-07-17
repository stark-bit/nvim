local git_root = function()
  return vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'")
end

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
            ['d'] = require('telescope.actions').delete_buffer,
          }
        },
        path_display = { "truncate" },
        dynamic_preview_title = true,
        hidden = true,
        file_ignore_patterns = {
          "node_modules/",
          "dist/",
          "build/",
          "target/",
          ".git/",
          "public/static/libs/pdf",
          "lazy%-lock%.json"
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end
        },
        grep_string = {
          additional_args = function()
            return { "--hidden" }
          end
        },
      },
    })

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>sr', '<Cmd>Telescope resume<CR>')
    vim.keymap.set('n', '<leader>sk', '<Cmd>Telescope keymaps<CR>')
    vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>sw', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>sW', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>st', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end)
    vim.keymap.set('n', '<leader>ls',
      function()
        require('telescope.builtin').buffers({ sort_lastused = true })
      end)


    vim.keymap.set('n', '<leader>sa',
      function()
        builtin.find_files({ cwd = git_root(), no_ignore = true })
      end)

    vim.keymap.set('n', '<leader>ss', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, {})
    -- New keybinding for live_grep within quickfix list files
    vim.keymap.set('n', '<leader>sq', function()
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
