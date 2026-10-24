return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = {
                enabled = false,
                auto_trigger = true,
                debounce = 75,
                keymap = {
                    accept = "<M-l>",      -- Alt + l (alles annehmen)
                    accept_word = "<M-w>", -- Alt + w (nur nächstes WORT)
                    accept_line = "<M-f>", -- Alt + f (nur nächste ZEILE)
                    next = "<M-]>",        -- Alt + ] (nächster Vorschlag)
                    prev = "<M-[>",        -- Alt + [ (vorheriger Vorschlag)
                    dismiss = "<C-]>",     -- Strg + ] (Vorschlag ausblenden)
                },
            },
        },
    },
}
