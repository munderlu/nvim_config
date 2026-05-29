return {
  "brianhuster/live-preview.nvim",
  ft = { "html", "css", "javascript" }, -- Lädt das Plugin nur bei Web-Dateien
  config = function()
    require("live-preview").setup({
      -- Hier kannst du bei Bedarf Einstellungen anpassen
    })
  end,
}
