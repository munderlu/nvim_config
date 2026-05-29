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

      -- 3. Deinen PDF-Viewer einstellen (z.B. "zathura", "skim" oder "okular")
      -- Wir sagen VimTeX, dass wir einen benutzerdefinierten (general) Viewer nutzen
      vim.g.vimtex_view_method = "general"

      -- Hier konfigurieren wir, dass dieses allgemeine Programm Okular ist
      vim.g.vimtex_view_general_viewer = "okular"

      -- Das hier ist die Magie für Forward Search (\lv):
      -- Wir sagen Okular ganz präzise, auf welche Seite und Zeile es springen soll
      vim.g.vimtex_view_general_options = "--unique file:@pdf#src:@line@tex"
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
