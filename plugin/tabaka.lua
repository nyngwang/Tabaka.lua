if vim.fn.has("nvim-0.11") == 0 then
  return
end

if vim.g.loaded_tabaka ~= nil then
  return
end

require('tabaka')


vim.g.loaded_tabaka = 1
