return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>ey",
        "<cmd>Yazi<cr>",
        desc = "Yazi öffnen",
      },
      {
        "<leader>eY",
        "<cmd>Yazi toggle<cr>",
        desc = "Yazi im aktuellen Ordner öffnen",
      },
    },
    opts = {
      -- Hier aktivieren wir, dass Yazi uns standardmäßig AUCH versteckte Dateien zeigt!
      show_hidden = true,
    },
  },
}
