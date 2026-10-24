-- LaTeX-Snippets nach Gilles Castel (castel.dev), übersetzt von UltiSnips nach LuaSnip.
-- Erste Tabelle: normale Snippets (Tab), zweite Tabelle: Autosnippets.
local ls = require("luasnip")
local s, t, i, f = ls.snippet, ls.text_node, ls.insert_node, ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local postfix = require("luasnip.extras.postfix").postfix
local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- Kontext-Erkennung über vimtex (funktioniert nur mit vimtex-Syntax, s. lang.tex-Extra)
local function math()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end
local function text()
  return not math()
end

-- Kurzform für Snippets, die nur im Mathemodus auslösen
local function ms(trig, nodes, opts)
  opts = opts or {}
  local spec = vim.tbl_extend("force", { trig = trig, snippetType = "autosnippet", wordTrig = false }, opts)
  return s(spec, nodes, { condition = math })
end
local function cap(n)
  return f(function(_, snip)
    return snip.captures[n]
  end)
end

local normal = {
  s(
    { trig = "fig", dscr = "figure-Umgebung mit Inkscape-Figur" },
    fmta(
      [[
\begin{figure}[ht]
	\centering
	\incfig{<>}
	\caption{<>}
	\label{fig:<>}
\end{figure}
]],
      { i(1), i(2), rep(1) }
    ),
    { condition = line_begin }
  ),
}

local auto = {
  -- Umgebungen & Mathemodus ---------------------------------------------
  s(
    { trig = "beg", snippetType = "autosnippet" },
    fmta(
      [[
\begin{<>}
	<>
\end{<>}
]],
      { i(1), i(0), rep(1) }
    ),
    { condition = line_begin }
  ),
  s({ trig = "mk", snippetType = "autosnippet" }, fmta("$<>$", { i(1) }), { condition = text }),
  s(
    { trig = "dm", snippetType = "autosnippet" },
    fmta(
      [[
\[
	<>
\]
]],
      { i(1) }
    ),
    { condition = text }
  ),

  -- Brüche -----------------------------------------------------------------
  ms("//", fmta("\\frac{<>}{<>}", { i(1), i(2) })),
  -- 3/ -> \frac{3}{}, \pi/ -> \frac{\pi}{}
  ms("(\\?[%w]+)/", fmta("\\frac{<>}{<>}", { cap(1), i(1) }), { trigEngine = "pattern" }),

  -- Indizes & Exponenten ---------------------------------------------------
  ms("(%a)(%d)", { cap(1), t("_"), cap(2) }, { trigEngine = "pattern" }), -- a1 -> a_1
  ms("(%a)_(%d%d)", fmta("<>_{<>}", { cap(1), cap(2) }), { trigEngine = "pattern" }), -- a_12 -> a_{12}
  ms("__", fmta("_{<>}", { i(1) })),
  ms("td", fmta("^{<>}", { i(1) })),
  ms("sr", t("^2")),
  ms("cb", t("^3")),
  ms("compl", t("^{c}")),

  -- Häufige Symbole -----------------------------------------------------------
  ms("...", t("\\ldots ")),
  ms("=>", t("\\implies ")),
  ms("<=", t("\\le ")),
  ms(">=", t("\\ge ")),
  ms("!=", t("\\neq ")),
  ms("ooo", t("\\infty ")),
  ms("->", t("\\to ")),
  ms("xx", t("\\times ")),
  ms("**", t("\\cdot ")),
  ms("sum", fmta("\\sum_{<>}^{<>}", { i(1, "n=1"), i(2, "\\infty") })),
  ms("lim", fmta("\\lim_{<> \\to <>}", { i(1, "n"), i(2, "\\infty") })),

  -- Postfix: erst den Buchstaben, dann den Akzent tippen (xhat -> \hat{x}) ------
  postfix({ trig = "hat", snippetType = "autosnippet", match_pattern = "[%w\\]+$" }, {
    f(function(_, parent)
      return "\\hat{" .. parent.snippet.env.POSTFIX_MATCH .. "}"
    end),
  }, { condition = math }),
  postfix({ trig = "bar", snippetType = "autosnippet", match_pattern = "[%w\\]+$" }, {
    f(function(_, parent)
      return "\\overline{" .. parent.snippet.env.POSTFIX_MATCH .. "}"
    end),
  }, { condition = math }),
  postfix({ trig = ",.", snippetType = "autosnippet", match_pattern = "[%w\\]+$" }, {
    f(function(_, parent)
      return "\\vec{" .. parent.snippet.env.POSTFIX_MATCH .. "}"
    end),
  }, { condition = math }),
}

return normal, auto
