return {
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",

    dependencies = { "rafamadriz/friendly-snippets" },

    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local sn = ls.snippet_node
      local t = ls.text_node
      local i = ls.insert_node
      local f = ls.function_node
      local c = ls.choice_node
      local d = ls.dynamic_node
      local r = ls.restore_node
      local l = require("luasnip.extras").lambda
      local rep = require("luasnip.extras").rep
      local p = require("luasnip.extras").partial
      local m = require("luasnip.extras").match
      local n = require("luasnip.extras").nonempty
      local dl = require("luasnip.extras").dynamic_lambda
      local fmt = require("luasnip.extras.fmt").fmt
      local fmta = require("luasnip.extras.fmt").fmta
      local types = require("luasnip.util.types")
      local conds = require("luasnip.extras.conditions")
      local conds_expand = require("luasnip.extras.conditions.expand")
      local function copy(args)
        return args[1]
      end

       -- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua


      ls.filetype_extend("javascript", { "jsdoc" })

      --- TODO: What is expand?
      vim.keymap.set({ "i" }, "<C-s>e", function() ls.expand() end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-s>;", function() ls.jump(1) end, { silent = true })
      vim.keymap.set({ "i", "s" }, "<C-s>,", function() ls.jump(-1) end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-E>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })

      ls.add_snippets("all", {
        s("fn", {
          -- Simple static text.
          t("//Parameters: "),
          -- function, first parameter is the function, second the Placeholders
          -- whose text it gets as input.
          f(copy, 2),
          t({ "", "function " }),
          -- Placeholder/Insert.
          i(1),
          t("("),
          -- Placeholder with initial text.
          i(2, "int foo"),
          -- Linebreak
          t({ ") {", "\t" }),
          -- Last Placeholder, exit Point of the snippet.
          i(0),
          t({ "", "}" }),
        }),

      })
    end,
  }
}
