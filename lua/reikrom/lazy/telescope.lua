local git_root = function()
  return vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'")
end

-- Patterns to exclude with <leader>sx* commands (find files / live grep)
-- Add new patterns here as needed
local exclude_patterns = {
  -- Tests
  "%.spec%.",
  "%.test%.",
  "__tests__/",
  "__mocks__/",
  "%.stories%.",
  -- Docs
  "%.md$",
  "%.mdx$",
  -- Generated
  "%.d%.ts$",
  "%.snap$",
}

-- Convert Lua patterns to ripgrep glob patterns for live_grep
local function get_rg_exclude_globs()
  local globs = {}
  local pattern_map = {
    ["%.spec%."] = "!*.spec.*",
    ["%.test%."] = "!*.test.*",
    ["__tests__/"] = "!**/__tests__/**",
    ["__mocks__/"] = "!**/__mocks__/**",
    ["%.stories%."] = "!*.stories.*",
    ["%.md$"] = "!*.md",
    ["%.mdx$"] = "!*.mdx",
    ["%.d%.ts$"] = "!*.d.ts",
    ["%.snap$"] = "!*.snap",
  }
  for _, pattern in ipairs(exclude_patterns) do
    if pattern_map[pattern] then
      table.insert(globs, "--glob=" .. pattern_map[pattern])
    end
  end
  return globs
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
            -- send only
            ["<C-q>"] = actions.smart_send_to_qflist,
            -- send + open
            ["<C-S-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          },
          n = {
            ["<C-q>"] = actions.smart_send_to_qflist,
            ['d'] = actions.delete_buffer,
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
          "public/static/libs/pdf",
          "lazy%-lock%.json",
          "package%-lock%.json"
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
    end, { desc = "search for word" })
    vim.keymap.set('n', '<leader>sW', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end, { desc = "search for wHole word" })
    vim.keymap.set('n', '<leader>st', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") ,desc = 'search string'})
    end)
    vim.keymap.set('n', '<leader>q', '<cmd>copen<CR>', { desc = "Open quickfix list" })
    vim.keymap.set('n', '<leader>ls',
      function()
        require('telescope.builtin').buffers({ sort_lastused = true ,desc = 'Last search'})
      end)


    vim.keymap.set('n', '<leader>saf',
      function()
        builtin.find_files({ cwd = git_root(), no_ignore = true, hidden = true, desc = 'search all files' })
      end)

    vim.keymap.set('n', '<leader>sas', function()
      builtin.live_grep({
        hidden = true,
        no_ignore = true,
        additional_args = function(args)
          return vim.list_extend(args, { "--hidden", "--no-ignore" })
        end
      })
    end)

    vim.keymap.set('n', '<leader>ss', builtin.live_grep, { desc = 'Live grep'})

    -- Exclude search: filters out tests, specs, docs, generated files
    vim.keymap.set('n', '<leader>sxf', function()
      builtin.find_files({
        file_ignore_patterns = vim.list_extend(
          vim.deepcopy(require('telescope.config').values.file_ignore_patterns or {}),
          exclude_patterns
        ),
      })
    end, { desc = 'Find files (exclude tests/docs)' })

    vim.keymap.set('n', '<leader>sxs', function()
      builtin.live_grep({
        additional_args = function()
          return get_rg_exclude_globs()
        end
      })
    end, { desc = 'Live grep (exclude tests/docs)' })

    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'search help'})

    -- New keybinding for live_grep within quickfix list files
    vim.keymap.set('n', '<leader>sqs', function()
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

    vim.keymap.set('n', '<leader>sqf', function()
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
        builtin.find_files({
          search_dirs = unique_files
        })
      else
        print("Quickfix list is empty or contains no valid files.")
      end
    end)


    vim.keymap.set('n', '<leader>sef', function()
      local exclude_pattern = vim.fn.input("Exclude pattern > ")
      if exclude_pattern ~= "" then
        local qflist = vim.fn.getqflist({ items = 0, all = 1 })
        local unique_files = {}
        local files_hash = {}

        for _, item in ipairs(qflist.items) do
          if item.bufnr ~= 0 then
            local filename = vim.fn.bufname(item.bufnr)
            if filename ~= "" and not files_hash[filename] then
              -- Check if filename matches the exclude pattern
              if not string.match(filename, exclude_pattern) then
                files_hash[filename] = true
                table.insert(unique_files, filename)
              end
            end
          end
        end

        if #unique_files > 0 then
          builtin.find_files({
            search_dirs = unique_files
          })
        else
          print("No files remaining after exclusion or quickfix list is empty.")
        end
      end
    end)
  end
}
