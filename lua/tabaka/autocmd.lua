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
      W.bufname_last[tabid_current][W.winid_enter[tabid_current].HJKL] = bufname_last

      if vim.api.nvim_win_is_valid(W.winid_enter[tabid_current].winid) then
        vim.api.nvim_set_current_win(W.winid_enter[tabid_current].winid)
      end

      W.winid_tabaka[tabid_current] = nil
      W.winid_enter[tabid_current] = nil
    end,
  })
end


function M.create_user_autocmds()
  M.detect_WinClosed_tabaka()
end


return M
