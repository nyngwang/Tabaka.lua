local M = {}
local NAME_PROJECT_FOLDER = '.tabaka'
local NAME_MARKDOWN = 'baka'


function M.create_file(filepath)
    vim.cmd(([[
      !touch %s
    ]]):format(filepath))
end


function M.get_filepath_project_folder_tabaka()
  return ('%s/%s'):format(vim.fn.getcwd(-1,-1), NAME_PROJECT_FOLDER)
end


function M.get_filepath_markdown_tabaka()
  return ('%s/%s.md'):format(M.get_filepath_project_folder_tabaka(), NAME_MARKDOWN)
end


function M.folder_or_file_exist(filepath)
  if not filepath then
    return false
  end
  local did, _, code = os.rename(filepath, filepath)
  return did or (code == 13)
end


function M.get_window_tabaka()
  -- assert: when exist, we can safely assume it's always located in the window of winnr1.
  local winid_winnr1 = vim.fn.win_getid(1)
  local bufnr_winnr1 = vim.api.nvim_win_get_buf(winid_winnr1)

  if -- the bufname of window of winnr1 is NOT tabaka markdown.
    M.get_filepath_markdown_tabaka() ~= vim.api.nvim_buf_get_name(bufnr_winnr1)
    then
    return { false, -1 }
  end

  return { true, winid_winnr1 }
end


function M.create_window_tabaka()
  if not M.folder_or_file_exist(M.get_filepath_project_folder_tabaka()) then
    print(('Tabaka: Failed to find the `%s/` folder.'):format(NAME_PROJECT_FOLDER))
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


function M.get_or_create_buf(filepath)
  local bufs_valid = vim.tbl_filter(function (bufnr)
    return vim.api.nvim_buf_is_valid(bufnr)
  end, vim.api.nvim_list_bufs())

  for _, bufnr in ipairs(bufs_valid) do
    if filepath == vim.api.nvim_buf_get_name(bufnr) then
      return bufnr
    end
  end
  -- have to create the buffer.

  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_buf_set_name(buf, filepath)
  return buf
end


function M.setup_window_tabaka(winid_tabaka)

  if not M.folder_or_file_exist(M.get_filepath_markdown_tabaka())
    then -- create one inside the folder.
    M.create_file(M.get_filepath_markdown_tabaka())
  end
  -- open the file.
  local buf = M.get_or_create_buf(M.get_filepath_markdown_tabaka())
  vim.api.nvim_win_set_buf(winid_tabaka, buf)
end


return M
