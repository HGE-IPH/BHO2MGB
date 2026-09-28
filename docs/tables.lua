-- Proporções por tabela, na ordem em que aparecem em index.md.
-- Cada legenda e tabela vira um único bloco LaTeX, para que nunca se divida entre páginas.
local widths = {
  {0.13, 0.24, 0.27, 0.36},
  {0.20, 0.18, 0.08, 0.19, 0.17, 0.18},
  {0.16, 0.84},
  {0.13, 0.12, 0.16, 0.32, 0.27},
  {0.17, 0.15, 0.07, 0.12, 0.12, 0.12, 0.12, 0.13},
}

local alignments = {
  {"left", "left", "left", "left"},
  {"left", "left", "right", "left", "left", "left"},
  {"left", "left"},
  {"left", "right", "right", "right", "right"},
  {"left", "right", "right", "right", "right", "right", "right", "right"},
}

local function column_spec(table_number, original)
  local proportions = widths[table_number]
  local aligns = alignments[table_number]
  if not proportions then
    return original
  end

  local columns = {"@{}"}
  local inset_count = 2 * #proportions - 2
  for i, proportion in ipairs(proportions) do
    local alignment = aligns[i] == "right" and "raggedleft" or "raggedright"
    columns[#columns + 1] = string.format(
      ">{\\%s\\arraybackslash}p{(\\linewidth - %d\\tabcolsep) * \\real{%.4f}}",
      alignment,
      inset_count,
      proportion
    )
  end
  columns[#columns + 1] = "@{}"
  return table.concat(columns, "\n")
end

local function serialize_table(table_block, table_number)
  local tex = pandoc.write(pandoc.Pandoc({table_block}), "latex")
  local marker = "\\begin{longtable}[]"
  local begin_at = tex:find(marker, 1, true)
  if not begin_at then
    error("Expected Pandoc to serialize a table using longtable")
  end

  local spec_open = begin_at + #marker
  if tex:sub(spec_open, spec_open) ~= "{" then
    error("Could not locate the longtable column specification")
  end

  local depth = 0
  local spec_close
  for i = spec_open, #tex do
    local char = tex:sub(i, i)
    if char == "{" then
      depth = depth + 1
    elseif char == "}" then
      depth = depth - 1
      if depth == 0 then
        spec_close = i
        break
      end
    end
  end
  if not spec_close then
    error("Unclosed longtable column specification")
  end

  local original_spec = tex:sub(spec_open + 1, spec_close - 1)
  local spec = column_spec(table_number, original_spec)
  local prefix = tex:sub(1, begin_at - 1)
  local body = tex:sub(spec_close + 1)
  body = body:gsub("\\endhead%s*", "")
  body = body:gsub("\\bottomrule\\noalign{}%s*\\endlastfoot", "")
  body = body:gsub("\\end{longtable}", "\\bottomrule\n\\end{tabular}", 1)

  return prefix .. "\\begin{tabular}{" .. spec .. "}" .. body
end

function Pandoc(doc)
  if not FORMAT:match("latex") then
    return nil
  end

  local output = pandoc.List()
  local table_number = 0
  for _, block in ipairs(doc.blocks) do
    if block.t == "Table" then
      table_number = table_number + 1
      local previous = output[#output]
      if not previous or previous.t ~= "Para" or
         not (pandoc.utils.stringify(previous.content):match("^Tabela %d+%.") or
              pandoc.utils.stringify(previous.content):match("^Table %d+%.")) then
        error("Expected a Markdown paragraph caption before table " .. table_number)
      end
      table.remove(output, #output)
      local caption = pandoc.write(pandoc.Pandoc({previous}), "latex")
      caption = caption:gsub("^%s+", ""):gsub("%s+$", "")
      local table_tex = serialize_table(block, table_number)
      local rendered = table.concat({
        "\\noindent\\begin{minipage}{\\linewidth}",
        "\\centering",
        caption,
        "\\par\\medskip",
        "{\\small",
        "\\setlength{\\tabcolsep}{4pt}",
        "\\renewcommand{\\arraystretch}{1.08}",
        table_tex,
        "}",
        "\\end{minipage}\\par",
      }, "\n")
      output:insert(pandoc.RawBlock("latex", rendered))
    else
      output:insert(block)
    end
  end
  doc.blocks = output
  return doc
end
