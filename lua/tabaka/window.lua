local C = require('tabaka.defaults').constants
local P = require('tabaka.filepath')
local M = {}


function M.get_window_tabaka()
  -- assert: when exist, we can safely assume it's always located in the window of winnr1.
  local winid_winnr1 = vim.fn.win_getid(1)
  local bufnr_winnr1 = vim.api.nvim_win_get_buf(winid_winnr1)

  if -- the bufname of window of winnr1 is NOT tabaka markdown.
    P.get_filepath_markdown_tabaka() ~= vim.api.nvim_buf_get_name(bufnr_winnr1)
    then
    return { false, -1 }
  end

  return { true, winid_winnr1 }
end


function M.create_window_tabaka()
  if not P.folder_or_file_exist(P.get_filepath_project_folder_tabaka()) then
    print(('Tabaka: Failed to find the `%s/` folder.'):format(C.NAME_PROJECT_FOLDER))
    return false, -1
  end

  local winid_save = vim.api.nvim_get_current_win()

  vim.cmd([[
    leftabove vsplit
    wincmd H
  ]])

  local winid_tabaka = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(winid_save)

  return true, winid_tabaka
end


function M.setup_window_tabaka(winid_tabaka)
  if not P.folder_or_file_exist(P.get_filepath_markdown_tabaka())
    then -- create the markdown inside the folder.
    P.create_file(P.get_filepath_markdown_tabaka())
  end
  -- open the markdown in the tabaka window.
  local bufnr = vim.fn.bufadd(P.get_filepath_markdown_tabaka())
  vim.fn.bufload(bufnr)
  vim.api.nvim_win_set_buf(winid_tabaka, bufnr)
end


return M
