function Header(el)
  local first = el.content[1]
  if first and first.t == "Str" and first.text:match("^%d+[%d%.]*%.$") then
    table.remove(el.content, 1)
    if el.content[1] and el.content[1].t == "Space" then
      table.remove(el.content, 1)
    end
    return el
  end
end
