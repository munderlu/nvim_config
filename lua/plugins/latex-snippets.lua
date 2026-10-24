-- Castel-Workflow: LuaSnip mit Autosnippets für LaTeX
-- Voraussetzung in lazyvim.json:
--   "lazyvim.plugins.extras.coding.luasnip"  (blink.cmp nutzt dann LuaSnip)
--   "lazyvim.plugins.extras.lang.tex"        (texlab + vimtex-Syntax statt Treesitter,
--                                             nötig für die Mathe-Erkennung)
-- Tastenbelegungen für .tex-Dateien: after/ftplugin/tex.lua
return {
  {
    "L3MON4D3/LuaSnip",
    -- Die Einstellungen gehören in opts: LazyVim ruft damit require("luasnip").setup(opts) auf.
    -- (Ein eigenes set_config() vorher würde dabei wieder überschrieben.)
    opts = {
      enable_autosnippets = true, -- Snippets ohne Tab (Castels "A"-Flag)
      store_selection_keys = "<Tab>", -- Visual-Auswahl für ${VISUAL}
      update_events = "TextChanged,TextChangedI", -- rep() live aktualisieren
    },
    config = function(_, opts)
      require("luasnip").setup(opts)
      -- Eigene Snippets aus ~/.config/nvim/LuaSnip/<filetype>.lua laden
      require("luasnip.loaders.from_lua").lazy_load({
        paths = { vim.fn.stdpath("config") .. "/LuaSnip" },
      })
    end,
  },
}
