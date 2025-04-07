local U = require('tabaka.utils')
local P = require('tabaka.filepath')
local C = require('tabaka.defaults').constants
local W = require('tabaka.window')
local M = {}
local augroup_project = vim.api.nvim_create_augroup(C.NAME_PROJECT, { clear = true })


function M.detect_WinClosed_tabaka()
  vim.api.nvim_create_autocmd({ 'WinClosed' }, {
    group = augroup_project,
    callback = function (ev)
      if -- not closing the tabaka window.
        tonumber(ev.match) ~= W.winid_tabaka[vim.api.nvim_get_current_tabpage()]
        then
        return
      end
      -- found it.

      local bufname_last = vim.api.nvim_buf_get_name(ev.buf)
      local tabid_current = vim.api.nvim_get_current_tabpage()

      if not W.bufname_last[tabid_current] then
        W.bufname_last[tabid_current] = {}
      end
      W.bufname_last[tabid_current][W.HJKL_last[tabid_current]] = bufname_last

      if vim.api.nvim_win_is_valid(W.winid_enter[tabid_current]) then
        vim.api.nvim_set_current_win(W.winid_enter[tabid_current])
      end

      W.winid_tabaka[tabid_current] = nil
      W.winid_enter[tabid_current] = nil
    end,
  })
end


function M.restore_sides()
  vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
    group = augroup_project,
    pattern = '*',
    callback = function ()
      if vim.fn.argc() ~= 0 -- git or `nvim ...`.
        or vim.v.dying > 0 then
        return
      end
      local fp = io.open(
        table.concat({
          P.get_filepath_folder_tabaka_project_user(),
          'storage.json'
        }, P.sep),
        'w+'
      )
      if not fp then return end

      local storage = {}
      for tabnr, tabid in ipairs(vim.api.nvim_list_tabpages()) do
        storage[tostring(tabnr)] = W.bufname_last[tabid]
      end
      fp:write(U.prettify_table(vim.json.encode(storage)))
      fp:close()
    end
  })
  vim.api.nvim_create_autocmd({ 'VimEnter' }, {
    group = augroup_project,
    pattern = '*',
    callback = function ()
      if -- git or `nvim ...`.
        vim.fn.argc() ~= 0 then
        return
      end
      local fp = io.open(
        table.concat({
          P.get_filepath_folder_tabaka_project_user(),
          'storage.json'
        }, P.sep),
        'r'
      )
      if not fp then return end

      local data = vim.json.decode(fp:read('*a'))
      fp:close()
      local storage = {}
      for str_tabnr, v in pairs(data) do
        storage[tonumber(str_tabnr)] = v
      end
      W.bufname_last = storage
    end
  })
end


function M.create_user_autocmds()
  M.detect_WinClosed_tabaka()
  M.restore_sides()
end


return M
