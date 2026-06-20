-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.tabstop = 4 -- Breite eines Tab-Zeichens
vim.opt.shiftwidth = 4 -- Einrückungsbreite bei Befehlen wie >>
vim.opt.expandtab = true -- Tabs durch Leerzeichen ersetzen
vim.opt.smarttab = true

-- jk oder kj im Insert Mode drückt Escape
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("i", "kj", "<Esc>", { noremap = true, silent = true })
