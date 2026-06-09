-- Cached: only resolves once per session
local _git_root_cache = nil
local git_root = function()
  if not _git_root_cache then
    _git_root_cache = vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'")
  end
  return _git_root_cache
end

-- Glob patterns for live_grep exclusions (used with telescope's native glob_pattern)
local fast_exclude_globs = {
  "!node_modules/**",
  "!.pnpm/**",
  "!dist/**",
  "!build/**",
  "!out/**",
  "!.next/**",
  "!.vercel/**",
  "!.cache/**",
  "!.turbo/**",
  "!.parcel-cache/**",
  "!.vite/**",
  "!.eslintcache",
  "!coverage/**",
  "!target/**",
  "!storybook-static/**",
  "!public/static/libs/pdf/**",
}

-- Extended globs: fast base + tests/stories/docs/generated
local sxs_exclude_globs = vim.list_extend(vim.deepcopy(fast_exclude_globs), {
  "!*.spec.*",
  "!*.test.*",
  "!**/__tests__/**",
  "!**/__mocks__/**",
  "!*.stories.*",
  "!*.md",
  "!*.mdx",
  "!*.d.ts",
  "!*.snap",
})

-- fd commands: cached at module load, zero overhead per keystroke
local fd_base_command = {
  "fd", "--type", "f", "--hidden", "--color", "never",
  "--exclude", "node_modules",
  "--exclude", ".pnpm",
  "--exclude", "dist",
  "--exclude", "build",
  "--exclude", "out",
  "--exclude", ".next",
  "--exclude", ".vercel",
  "--exclude", ".cache",
  "--exclude", ".turbo",
  "--exclude", ".parcel-cache",
  "--exclude", ".vite",
  "--exclude", "coverage",
  "--exclude", "target",
  "--exclude", "storybook-static",
  "--exclude", ".git",
}

-- fd command for sxf: base + test dirs
local fd_sxf_command = vim.list_extend(vim.deepcopy(fd_base_command), {
  "--exclude", "__tests__",
  "--exclude", "__mocks__",
})

-- Helper: get unique files from quickfix list
local function get_qf_files()
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
  return unique_files
end

-- Helper: filter quickfix list by excluding files containing pattern
local function filter_qf_exclude(exclude_input)
  if exclude_input == "" then return false end

  local qflist = vim.fn.getqflist({ items = 0, all = 1 })
  local filtered_items = {}

  for _, item in ipairs(qflist.items) do
    if item.bufnr ~= 0 then
      local filename = vim.fn.bufname(item.bufnr)
      if not string.find(filename, exclude_input, 1, true) then
        table.insert(filtered_items, item)
      end
    end
  end

  if #filtered_items > 0 then
    vim.fn.setqflist({}, 'r', { items = filtered_items, title = 'Filtered (excl: ' .. exclude_input .. ')' })
    print(string.format("Quickfix: %d -> %d items (excluded '%s')", #qflist.items, #filtered_items, exclude_input))
    return true
  else
    print("No files remaining after exclusion.")
    return false
  end
end

return {
  "nvim-telescope/telescope.nvim",

  branch = "master",

  dependencies = {
    "nvim-lua/plenary.nvim"
  },

  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup({
      defaults = {
        mappings = {
          i = {
            ["<CR>"] = actions.select_default,
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
    vim.keymap.set('n', '<leader>sf', function()
      builtin.find_files({ find_command = fd_base_command })
    end, {})
    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>sw', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word, glob_pattern = fast_exclude_globs })
    end, { desc = "search for word" })
    vim.keymap.set('n', '<leader>sW', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word, glob_pattern = fast_exclude_globs })
    end, { desc = "search for wHole word" })
    vim.keymap.set('n', '<leader>st', function()
      builtin.grep_string({ search = vim.fn.input("Grep > "), glob_pattern = fast_exclude_globs })
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
      })
    end)

    vim.keymap.set('n', '<leader>ss', function()
      builtin.live_grep({ hidden = true, glob_pattern = fast_exclude_globs })
    end, { desc = 'Live grep' })

    -- Raw search for debugging - NO exclusions, NO config
    vim.keymap.set('n', '<leader>sz1', function()
      builtin.live_grep({})
    end, { desc = 'Live grep (raw, no filters)' })

    -- Exclude search: filters out build/cache + tests/stories/docs/generated
    vim.keymap.set('n', '<leader>sxf', function()
      builtin.find_files({
        find_command = fd_sxf_command,
        -- fd --exclude works on dir names; use Lua patterns for file-level filtering
        file_ignore_patterns = { "%.spec%.", "%.test%.", "%.stories%.", "%.d%.ts$", "%.snap$" },
      })
    end, { desc = 'Find files (exclude tests/docs)' })

    vim.keymap.set('n', '<leader>sxs', function()
      builtin.live_grep({ glob_pattern = sxs_exclude_globs })
    end, { desc = 'Live grep (exclude tests/docs)' })

    vim.keymap.set('n', '<leader>sxw', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word, glob_pattern = sxs_exclude_globs })
    end, { desc = 'Search word (exclude tests/docs)' })

    vim.keymap.set('n', '<leader>sxW', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word, glob_pattern = sxs_exclude_globs })
    end, { desc = 'Search WORD (exclude tests/docs)' })

    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'search help'})

    -- Forward declarations for sqs/sqf so they can re-invoke themselves
    local open_sqs, open_sqf

    -- New keybinding for live_grep within quickfix list files
    open_sqs = function()
      local unique_files = get_qf_files()

      if #unique_files > 0 then
        builtin.live_grep({
          search_dirs = unique_files,
          attach_mappings = function(prompt_bufnr, map)
            -- <C-e> to exclude files and refresh
            map({ 'i', 'n' }, '<C-e>', function()
              actions.close(prompt_bufnr)
              vim.ui.input({ prompt = "Exclude files containing > " }, function(input)
                if input and filter_qf_exclude(input) then
                  vim.schedule(open_sqs)
                end
              end)
            end)
            return true -- keep default mappings
          end,
        })
      else
        print("Quickfix list is empty or contains no valid files.")
      end
    end
    vim.keymap.set('n', '<leader>sqs', open_sqs)

    open_sqf = function()
      local unique_files = get_qf_files()

      if #unique_files > 0 then
        builtin.find_files({
          search_dirs = unique_files,
          attach_mappings = function(prompt_bufnr, map)
            -- <C-e> to exclude files and refresh
            map({ 'i', 'n' }, '<C-e>', function()
              actions.close(prompt_bufnr)
              vim.ui.input({ prompt = "Exclude files containing > " }, function(input)
                if input and filter_qf_exclude(input) then
                  vim.schedule(open_sqf)
                end
              end)
            end)
            return true -- keep default mappings
          end,
        })
      else
        print("Quickfix list is empty or contains no valid files.")
      end
    end
    vim.keymap.set('n', '<leader>sqf', open_sqf)
  end
}
