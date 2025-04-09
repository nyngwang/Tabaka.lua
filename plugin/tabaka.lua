if vim.version().minor < 7 then
  vim.api.nvim_echo({
    { 'Tabaka.lua: requires nvim 0.7 or higher.' },
  }, true, { err=true })
  return
end

if vim.g.loaded_tabaka ~= nil then
  return
end

require('tabaka')


vim.g.loaded_tabaka = 1
