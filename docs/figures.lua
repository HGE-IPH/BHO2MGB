-- Keep low-resolution screenshots near or above 150 effective DPI in the PDF.
-- Widths apply to both language editions; source images live in docs/assets.
local figure_widths = {
  ["figura-01"] = "6.5cm",
  ["figura-05"] = "6.0cm",
  ["figura-06"] = "14.5cm",
  ["figura-07"] = "7.0cm",
  ["figura-08"] = "7.0cm",
  ["figura-09"] = "5.0cm",
  ["figura-11"] = "5.5cm",
  ["figura-13"] = "15.0cm",
  ["figura-14"] = "15.0cm",
  ["figura-15"] = "14.4cm",
  ["figura-16"] = "13.7cm",
  ["figura-17"] = "15.0cm",
  ["figura-18"] = "12.7cm",
  ["figura-19"] = "12.7cm",
  ["figura-20"] = "10.5cm",
  ["figura-21"] = "6.9cm",
  ["figura-22"] = "6.0cm",
  ["figura-23"] = "13.0cm",
  ["figura-24"] = "13.6cm",
  ["figura-25"] = "6.8cm",
  ["figura-26"] = "12.5cm",
  ["figura-27"] = "15.0cm",
  ["figura-28"] = "15.0cm",
  ["figura-29"] = "11.0cm",
  ["figura-30"] = "14.3cm",
  ["figura-31"] = "13.3cm",
  ["figura-32"] = "15.0cm",
  ["figura-33"] = "12.0cm",
  ["figura-34"] = "10.5cm",
  ["figura-35"] = "15.0cm",
  ["figura-36"] = "15.0cm",
  ["figura-37"] = "15.0cm",
  ["figura-38"] = "15.0cm",
  ["figura-39"] = "15.0cm",
}

local center_image = {
  Image = function(el)
    if FORMAT:match("latex") then
      local filename = el.src:match("([^/]+)$") or el.src
      local figure = filename:match("^(figura%-%d+)")
      local width = figure and figure_widths[figure]
      if width then
        el.attributes.width = width
        return el
      end
    end
  end,
  Para = function(el)
    local text = pandoc.utils.stringify(el.content)
    local table_caption = (text:match("^Tabela %d+%.") or text:match("^Table %d+%.")) and not FORMAT:match("latex")
    if (#el.content == 1 and el.content[1].t == "Image") or
       (text:match("^Figura %d+%.") or text:match("^Figure %d+%.")) or table_caption then
      return pandoc.Div({el}, pandoc.Attr("", {"center-image"}, {}))
    end
  end
}

local render_center = {
  Div = function(el)
    if not el.classes:includes("center-image") then
      return nil
    end
    if FORMAT:match("latex") then
      local blocks = pandoc.Blocks({pandoc.RawBlock("latex", "\\begin{center}")})
      blocks:extend(el.content)
      blocks:insert(pandoc.RawBlock("latex", "\\end{center}"))
      return blocks
    end
    if FORMAT:match("html") then
      el.attributes.align = "center"
      return el
    end
    return el.content
  end
}

return {center_image, render_center}
