local M = {}


M.ft_to_ext = {
  markdown = 'md',
}


function M.escape_pattern(str_with_pattern)
  return str_with_pattern:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])', '%%%1')
end


function M.prettify_table(str)
  local level = 0
  local out = ''
  local dquote = 0

  for c in str:gmatch'.' do
    if c == '{' or c == '[' then
      out = out .. c .. '\n'
      level = level+1
      out = out .. ('  '):rep(level)
    elseif c == '}' or c == ']' then
      level = level-1
      out = out .. '\n'
      out = out .. ('  '):rep(level)
      out = out .. c
    elseif c == ',' then
      out = out .. c .. '\n'
      out = out .. ('  '):rep(level)
    elseif c == ':' then
      if dquote%2 == 1 -- between quotes.
      then out = out .. ':'
      else out = out .. ': ' end
    elseif c == '"' then
      dquote = dquote+1
      out = out .. '"'
    else
      out = out .. c
    end
  end

  return out
end


return M
