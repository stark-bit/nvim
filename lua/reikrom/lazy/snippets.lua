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
          t("//Parameters: "),
          f(copy, 2),
          t({ "", "function " }),
          i(1),
          t("("),
          i(2, "int foo"),
          t({ ") {", "\t" }),
          i(0),
          t({ "", "}" }),
        }),

        s("rlg", {
          t({ "console.log('rei " }),
          i(1, "some text"),
          t("', "),
          i(2, "variable"),
          t(");"),
          i(0),
        }),
        s("switch", {
          t({ "switch (" }),
          i(1, "expression"),
          t({ ") {", "\tcase " }),
          i(2, "value1"),
          t({ ":", "\t\t" }),
          i(3, "// code"),
          t({ "", "\t\tbreak;", "", "\tcase " }),
          i(4, "value2"),
          t({ ":", "\t\t" }),
          i(5, "// code"),
          t({ "", "\t\tbreak;", "", "\tdefault:", "\t\t" }),
          i(6, "// default code"),
          t({ "", "\t\tbreak;", "}" }),
          i(0),
        }),
        s("useStateSnip", {
          t("const ["),
          i(1, "state"),
          t(", set"),
          f(function(args)
            return args[1][1]:gsub("^%l", string.upper) -- Capitalizes the first letter
          end, { 1 }),
          t("] = useState("),
          i(2, "initialValue"),
          t(");"),
          i(0),
        }),
        s("useEffectSnip", {
          t("useEffect(() => {"),
          t({ "", "\t" }),
          i(1, "// effect code"),
          t({ "", "}, [" }),
          i(2, "// dependencies"),
          t("]);"),
          i(0),
        }),
      })

      ls.add_snippets("go", {
        s("err", {
          t("if err != nil {"),
          t({ "", "\treturn err", "" }),
          t("}"),
          i(0),
        })
      })
    end,
  }
}
