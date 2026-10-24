-- Wird automatisch für jede .tex-Datei geladen (nach vimtex und LazyVim).
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = desc })
end

-- Rechtschreibfehler im Insert-Mode korrigieren (Castels <C-l>):
-- springt zum letzten Fehler, nimmt den 1. Vorschlag, springt zurück.
vim.opt_local.spell = true
map("i", "<C-l>", "<C-g>u<Esc>[s1z=`]a<C-g>u", "Letzten Tippfehler korrigieren")

-- Inkscape-Figures (pipx install inkscape-figures, `inkscape-figures watch` muss laufen)
-- Der Watcher exportiert beim Speichern in Inkscape automatisch PDF + .pdf_tex.
local function figures_dir()
  local root = vim.b.vimtex and vim.b.vimtex.root or vim.fn.expand("%:p:h")
  return root .. "/figures/"
end

local function require_exe(exe, hint)
  if vim.fn.executable(exe) == 1 then
    return true
  end
  vim.notify(exe .. " nicht gefunden (" .. hint .. ")", vim.log.levels.ERROR)
  return false
end

local function open_in_inkscape(svg)
  if require_exe("inkscape", "sudo pacman -S inkscape") then
    vim.fn.jobstart({ "inkscape", svg }, { detach = true })
  end
end

-- Insert: Titel in die Zeile schreiben, <C-f> -> figure-Block einfügen + Inkscape öffnen
map("i", "<C-f>", function()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^%s*")
  local title = vim.trim(line)
  if title == "" then
    vim.notify("Erst einen Titel in die Zeile schreiben", vim.log.levels.WARN)
    return
  end
  -- Gleiche Namensregel wie inkscape-figures: Leerzeichen -> "-", klein geschrieben
  local name = title:gsub(" ", "-"):lower()
  local svg = figures_dir() .. name .. ".svg"

  vim.api.nvim_buf_set_lines(0, row - 1, row, false, {
    indent .. "\\begin{figure}[ht]",
    indent .. "\t\\centering",
    indent .. "\t\\incfig{" .. name .. "}",
    indent .. "\t\\caption{" .. title .. "}",
    indent .. "\t\\label{fig:" .. name .. "}",
    indent .. "\\end{figure}",
  })
  vim.cmd("stopinsert")
  vim.cmd("silent write")

  -- Gibt es die Figur schon, einfach öffnen (inkscape-figures würde sonst
  -- stillschweigend "<name>2.svg" anlegen, das nicht zu \incfig passt)
  if vim.fn.filereadable(svg) == 1 then
    open_in_inkscape(svg)
    return
  end
  if not require_exe("inkscape-figures", "pipx install inkscape-figures") then
    return
  end
  -- Neu anlegen: Vorlage kopieren, Ordner beim Watcher registrieren, Inkscape starten.
  -- Läuft im Hintergrund, damit Inkscapes Ausgabe nicht im Text landet.
  vim.fn.jobstart({ "inkscape-figures", "create", title, figures_dir() }, {
    detach = true,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify("inkscape-figures create ist fehlgeschlagen (Code " .. code .. ")", vim.log.levels.ERROR)
        end)
      end
    end,
  })
end, "Neue Inkscape-Figur")

-- Normal: Figur bearbeiten. Steht der Cursor auf einer \incfig{...}-Zeile, wird genau die
-- geöffnet, sonst kommt eine Auswahlliste (LazyVim-Picker statt rofi).
map("n", "<localleader>f", function()
  local dir = figures_dir()
  local under_cursor = vim.api.nvim_get_current_line():match("\\incfig{([^}]+)}")
  if under_cursor and vim.fn.filereadable(dir .. under_cursor .. ".svg") == 1 then
    open_in_inkscape(dir .. under_cursor .. ".svg")
    return
  end

  local files = vim.fn.globpath(dir, "*.svg", false, true)
  if #files == 0 then
    vim.notify("Keine Figuren in " .. dir, vim.log.levels.WARN)
    return
  end
  table.sort(files, function(a, b)
    return vim.fn.getftime(a) > vim.fn.getftime(b) -- zuletzt bearbeitete zuerst
  end)
  vim.ui.select(files, {
    prompt = "Figur bearbeiten",
    format_item = function(f)
      return vim.fn.fnamemodify(f, ":t:r")
    end,
  }, function(choice)
    if choice then
      open_in_inkscape(choice)
    end
  end)
end, "Inkscape-Figur bearbeiten")
