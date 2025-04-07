local C = require('tabaka.defaults').constants
local P = require('tabaka.filepath')
local A = require('tabaka.autocmd')
local M = {
  winid_tabaka = {},
  winid_enter = {},
  bufname_last = {}, -- NOTE: a session-restore plugin might set this directly.
}
local opts = require('tabaka.config').get_opts()


function M.get_winid_tabaka()
  local tabid_current = vim.api.nvim_get_current_tabpage()
  local winid_tabaka = M.winid_tabaka[tabid_current]

  if not winid_tabaka then
    return { false, nil }
  end

  return { true, winid_tabaka }
end


function M.close_window_tabaka(winid_tabaka)
  if -- the other program somehow by-pass the `:q`-autocmd.
    not vim.api.nvim_win_is_valid(winid_tabaka) then
    vim.cmd(([[
      doau %s %s
    ]]):format(C.NAME_PROJECT, 'WinClosed'))
    return
  end

  vim.api.nvim_win_close(winid_tabaka, false)

  if -- the window didn't get closed for some reason.
    vim.api.nvim_win_is_valid(winid_tabaka)
    then
    print('Tabaka: Failed to close the tabaka window.')
    return
  end
  -- did close.
  -- NOTE: internals updates are now handled by autocmd.
end


function M.create_window_tabaka(HJKL)
  if -- the project folder does not exist.
    not P.filepath_exist(P.get_filepath_folder_tabaka_project_user())
    then -- stop create the window.
    print(('Tabaka: please create the `%s/` folder in your project root first.'):format(C.NAME_FOLDER_PROJECT))
    return false, nil
  end

  local tabid_current = vim.api.nvim_get_current_tabpage()
  M.winid_enter[tabid_current] = {
    winid = vim.api.nvim_get_current_win(),
    HJKL = HJKL,
  }

  vim.cmd(([[
    rightbelow vsplit
    wincmd %s
  ]]):format(HJKL))

  if -- didn't create for some reason.
    vim.api.nvim_get_current_win() == M.winid_enter[tabid_current].winid
    then
    M.winid_enter[tabid_current] = nil
    print('Tabaka: window splitting command failed.')
    return
  end
  -- did create.

  local winid_tabaka = vim.api.nvim_get_current_win()
  M.winid_tabaka[tabid_current] = winid_tabaka

  -- try restore the last opened buffer.
  if M.bufname_last[tabid_current] and M.bufname_last[tabid_current][HJKL]
    then
    local bufnr_last = vim.fn.bufadd(M.bufname_last[tabid_current][HJKL])
    vim.fn.bufload(bufnr_last)
    vim.api.nvim_win_set_buf(winid_tabaka, bufnr_last)
  end

  -- create an autocmd to detect `:q` without `M.close_window_tabaka`.
  A.detect_colon_q(M)

  -- tabaka window customization.
  opts.callback.on_open.for_all({
    winid = winid_tabaka,
    HJKL = HJKL,
  })

  return true, winid_tabaka
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
