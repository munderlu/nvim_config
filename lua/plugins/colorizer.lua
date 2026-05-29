return {
  {
    "NvChad/nvim-colorizer.lua",
    opts = {
      filetypes = { "html", "css", "javascript", "lua" },
      user_default_options = {
        RGB = true,          -- #RGB hex codes
        RRGGBB = true,       -- #RRGGBB hex codes
        names = true,        -- "Blue", "Red" etc. erkennen
        RRGGBBAA = true,     -- #RRGGBBAA hex codes
        rgb_fn = true,       -- CSS rgb() und rgba() Funktionen
        hsl_fn = true,       -- CSS hsl() und hsla() Funktionen
        css = true,          -- Alle CSS-Farben in CSS-Dateien aktivieren
        css_fn = true,       -- Alle CSS-Farb-Funktionen aktivieren
        mode = "background", -- "background" färbt den Text-Hintergrund, "foreground" nur den Text
      },
    },
  },
}
