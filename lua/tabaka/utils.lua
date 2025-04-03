local M = {}


M.ft_to_ext = {
  markdown = 'md',
}


function M.escape_pattern(str_with_pattern)
  return str_with_pattern:gsub('([%^%$%(%)%%%.%[%]%*%+%-%?])', '%%%1')
end


return M
