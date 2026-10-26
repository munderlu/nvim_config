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
        -- Copilot beim Start direkt ausschalten. Einschalten bei Bedarf mit
        -- <leader>at (Leertaste a t) oder :Copilot enable
        config = function(_, opts)
            require("copilot").setup(opts)
            require("copilot.command").disable()
        end,
        keys = {
            {
                "<leader>at",
                function()
                    if require("copilot.client").is_disabled() then
                        require("copilot.command").enable()
                        vim.notify("Copilot an")
                    else
                        require("copilot.command").disable()
                        vim.notify("Copilot aus")
                    end
                end,
                desc = "Copilot an/aus",
            },
        },
    },
}
