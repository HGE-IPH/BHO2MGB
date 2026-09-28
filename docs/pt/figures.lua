-- Larguras arredondadas a 0,1 cm, estimadas pela resolução nativa (ppi)
-- e pelo tamanho de impressão das figuras no PDF original.
local figure_widths = {
  ["figura-01"] = "5.6cm",
  ["figura-02"] = "13.7cm",
  ["figura-03"] = "12.9cm",
  ["figura-04"] = "15.0cm",
  ["figura-05"] = "9.0cm",
  ["figura-06"] = "14.4cm",
  ["figura-07"] = "9.4cm",
  ["figura-08"] = "10.3cm",
  ["figura-09"] = "8.5cm",
  ["figura-10"] = "13.1cm",
  ["figura-11"] = "8.2cm",
  ["figura-12"] = "15.0cm",
  ["figura-13"] = "12.7cm",
  ["figura-14"] = "7.3cm",
  ["figura-15"] = "13.0cm",
  ["figura-16"] = "7.3cm",
  ["figura-17"] = "10.0cm",
  ["figura-18"] = "10.4cm",
  ["figura-19"] = "15.0cm",
  ["figura-20"] = "15.0cm",
  ["figura-21"] = "14.4cm",
  ["figura-22"] = "13.7cm",
  ["figura-23"] = "15.0cm",
  ["figura-24"] = "12.7cm",
  ["figura-25"] = "12.7cm",
  ["figura-26"] = "10.8cm",
  ["figura-27"] = "9.1cm",
  ["figura-28"] = "8.6cm",
  ["figura-29"] = "15.0cm",
  ["figura-30"] = "13.6cm",
  ["figura-31"] = "8.3cm",
  ["figura-32"] = "13.8cm",
  ["figura-33"] = "15.0cm",
  ["figura-34"] = "15.0cm",
  ["figura-35"] = "13.0cm",
  ["figura-36"] = "14.3cm",
  ["figura-37"] = "13.3cm",
  ["figura-38"] = "15.0cm",
  ["figura-39"] = "15.0cm",
  ["figura-40"] = "12.8cm",
  ["figura-41"] = "15.0cm",
  ["figura-42"] = "15.0cm",
  ["figura-43"] = "15.0cm",
  ["figura-44"] = "15.0cm",
  ["figura-45"] = "15.0cm",
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
    if (#el.content == 1 and el.content[1].t == "Image") or
       text:match("^Figura %d+%.") or text:match("^Tabela %d+%.") then
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
