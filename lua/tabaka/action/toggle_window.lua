local W = require('tabaka.window')


return {
  function (args)
    -- TODO: check creation done.

    if -- already presented in the current tabpage.
      W.get_window_tabaka()[1]
      then -- try close it.
      W.close_window_tabaka(W.get_window_tabaka()[2])
      return
    end
    -- otherwise, we try to open the tabaka window.
    local ok, winid_tabaka = W.create_window_tabaka()
    if not ok then return end
    W.load_markdown_in_window(winid_tabaka)
  end,
  function ()
    return { 'H', 'J', 'K', 'L' }
  end,
}
