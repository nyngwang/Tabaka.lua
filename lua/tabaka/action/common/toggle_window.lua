local W = require('tabaka.window')


return {
  function (args)
    local HJKL = args[1]
    if -- already presented in the current tabpage.
      W.get_winid_tabaka()[1]
      then -- try close it.
      W.close_window_tabaka(W.get_winid_tabaka()[2])
      return
    end
    -- otherwise, we try to open the tabaka window.
    local ok, winid_tabaka = W.create_window_tabaka(HJKL)
    if not ok then return end
  end,
  function ()
    return { 'H', 'J', 'K', 'L' }
  end,
}
