local C = require('tabaka.defaults').constants
local P = require('tabaka.filepath')
local M = {}
M._context = {
  winid_tabaka = -1,
}


function M.get_window_tabaka()
  local winid_tabaka = M._context.winid_tabaka

  if winid_tabaka == -1
    or -- the internals outdated, since the user might `:q` at the tabaka window directly.
    not vim.api.nvim_win_is_valid(winid_tabaka)
    then
    return { false, -1 }
  end

  local bufnr_tabaka = vim.api.nvim_win_get_buf(winid_tabaka)

  if -- the tabaka window contains the other buffer.
    vim.api.nvim_buf_get_name(bufnr_tabaka)
    ~= P.get_filepath_markdown_tabaka_project_user()
    then -- update internals, since we don't treat it as the tabaka window anymore.
    M._context.winid_tabaka = -1
    return { false, -1 }
  end

  return { true, winid_tabaka }
end


function M.create_window_tabaka()
  if -- not exist the project folder (thus the markdown) at all.
    not P.filepath_exist(P.get_filepath_folder_tabaka_project_user())
    then -- stop create the window.
    print(('Tabaka: Failed to find the `%s/` folder.'):format(C.NAME_FOLDER_PROJECT))
    return false, -1
  end

  local winid_save = vim.api.nvim_get_current_win()

  -- TODO: extract to setup opts.
  vim.cmd(([[
    %s
    wincmd %s
  ]]):format('leftabove vsplit', 'H'))

  local winid_tabaka = vim.api.nvim_get_current_win()
  M._context.winid_tabaka = winid_tabaka
  vim.api.nvim_set_current_win(winid_save)

  return true, winid_tabaka
end


function M.close_window_tabaka(winid_tabaka)
  -- assert: `winid_tabaka` is the winid of the tabaka window.
  vim.api.nvim_win_close(winid_tabaka, false)
  if -- didn't close the window for some reason.
    vim.api.nvim_win_is_valid(winid_tabaka)
    then
      print('Tabaka: Failed to close the tabaka window.')
  end
  -- did close, can update internals.
  M._context.winid_tabaka = -1
end


function M.load_markdown_in_window(winid_tabaka)
  if not P.filepath_exist(P.get_filepath_markdown_tabaka_project_user())
    then -- create the markdown inside the folder.
    P.create_file(P.get_filepath_markdown_tabaka_project_user())
  end
  -- open the markdown in the tabaka window.
  local bufnr = vim.fn.bufadd(P.get_filepath_markdown_tabaka_project_user())
  vim.fn.bufload(bufnr)
  vim.api.nvim_win_set_buf(winid_tabaka, bufnr)
end


return M
