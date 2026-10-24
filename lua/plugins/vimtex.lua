return {
  {
    "lervag/vimtex",
    lazy = false, -- Wichtig, damit VimTeX sofort beim Öffnen von .tex-Dateien aktiv wird
    init = function()
      -- 1. LaTeXmk als Standard-Compiler nutzen
      vim.g.vimtex_compiler_method = "latexmk"

      -- 2. Hilfsdateien in den versteckten Ordner '.build' umleiten
      -- Die Option '-pdf' sorgt dafür, dass das finale PDF im Hauptordner landet!
      vim.g.vimtex_compiler_latexmk = {
        build_dir = ".build",
        options = {
          "-pdf",
          "-shell-escape",
          "-verbose",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-outdir=.build",
        },
      }

      -- 3. PDF-Viewer: GNOME "Dokumentenbetrachter"
      -- Neuere GNOME-Versionen liefern "Papers" aus, ältere "Evince" – wir nehmen, was da ist.
      -- Beide laden das PDF nach jedem Kompilieren automatisch neu.
      -- Hinweis: Forward Search (\lv springt zur Cursor-Zeile im PDF) können beide
      -- nicht über die Kommandozeile – \lv öffnet hier nur das PDF.
      -- Wer das braucht: Zathura installieren und vim.g.vimtex_view_method = "zathura" setzen
      -- (dann die beiden Zeilen darunter entfernen).
      vim.g.vimtex_view_method = "general"
      vim.g.vimtex_view_general_viewer = vim.fn.executable("papers") == 1 and "papers" or "evince"
      vim.g.vimtex_view_general_options = "@pdf"
      vim.g.vimtex_quickfix_open_on_warning = 0 -- Verhindert das automatische Öffnen des Quickfix-Fensters bei Warnungen
      -- Ein Autocommand, das nach erfolgreichem Kompilieren das PDF nach vorne kopiert
      vim.api.nvim_create_autocmd("User", {
        pattern = "VimtexEventCompileSuccess",
        callback = function(args)
          -- Wir holen uns die VimTeX-Daten direkt aus dem aktuellen Buffer (args.buf)
          local tex_data = vim.b[args.buf].vimtex
          if not tex_data then
            return
          end

          local main_tex = tex_data.tex
          local root_dir = tex_data.root
          if not main_tex or not root_dir then
            return
          end

          -- Extrahiert den Namen (z.B. "main")
          local base = vim.fn.fnamemodify(main_tex, ":t:r")

          -- Absolute Pfade bauen!
          local source_pdf = root_dir .. "/.build/" .. base .. ".pdf"
          local target_pdf = root_dir .. "/" .. base .. ".pdf"

          if vim.fn.has("win32") == 1 then
            -- Windows-Anpassung
            source_pdf = source_pdf:gsub("/", "\\")
            target_pdf = target_pdf:gsub("/", "\\")
            os.execute('copy /Y "' .. source_pdf .. '" "' .. target_pdf .. '" >nul')
          else
            -- Linux / Mac
            os.execute("cp " .. vim.fn.shellescape(source_pdf) .. " " .. vim.fn.shellescape(target_pdf))
          end
        end,
      })
    end,
  },
}
