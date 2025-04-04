local C = require('tabaka.defaults').constants
local M = {}
local augroup_project = vim.api.nvim_create_augroup(C.NAME_PROJECT, { clear = true })


function M.detect_colon_q(mod_win)
  vim.api.nvim_create_autocmd({ 'WinClosed' }, {
    group = augroup_project,
    callback = function (ev)
      if -- not closing the current window.
        vim.api.nvim_get_current_buf() ~= ev.buf
        or -- not the tabaka window.
        vim.api.nvim_get_current_win() ~= mod_win.winid_tabaka[vim.api.nvim_get_current_tabpage()]
        then
        return
      end
      -- found it.

      local bufname_last = vim.api.nvim_buf_get_name(ev.buf)
      local tabid_current = vim.api.nvim_get_current_tabpage()
      mod_win.winid_tabaka[tabid_current] = nil

      if not mod_win.bufname_last[tabid_current] then
        mod_win.bufname_last[tabid_current] = {}
      end
      mod_win.bufname_last[tabid_current][mod_win.winid_enter[tabid_current].HJKL] = bufname_last

      vim.api.nvim_create_autocmd({ 'WinEnter' }, {
        group = augroup_project,
        once = true,
        callback = function ()
          if mod_win.winid_enter[tabid_current].winid
            and vim.api.nvim_win_is_valid(mod_win.winid_enter[tabid_current].winid)
            then
            vim.api.nvim_set_current_win(mod_win.winid_enter[tabid_current].winid)
            mod_win.winid_enter[tabid_current] = nil
          end
        end
      })
    end,
  })
end


return M
