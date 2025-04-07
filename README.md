Tabaka.lua
---
<div align="center">
  <img src="https://github.com/user-attachments/assets/3b812b9b-0ed9-4974-a574-3538cea38e6e" width="400">
  <p><i>Extend Your <b>Tab</b>pages for Notes{🎶,📝} <br>
    and Never Feel Like a Cute <b>Baka</b> Again!</i></p>
  <a href="https://github.com/nyngwang/tabaka.lua/pulse">
    <img alt="Last commit" src="https://img.shields.io/github/last-commit/nyngwang/tabaka.lua?style=for-the-badge&logo=starship&color=8bd5ca&logoColor=D9E0EE&labelColor=302D41"/>
  </a>
  <a href="https://github.com/nyngwang/tabaka.lua/blob/main/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/nyngwang/tabaka.lua?style=for-the-badge&logo=starship&color=ee999f&logoColor=D9E0EE&labelColor=302D41" />
  </a>
  <a href="https://github.com/nyngwang/tabaka.lua/stargazers">
    <img alt="Stars" src="https://img.shields.io/github/stars/nyngwang/tabaka.lua?style=for-the-badge&logo=starship&color=c69ff5&logoColor=D9E0EE&labelColor=302D41" />
  </a>
  <a href="https://github.com/nyngwang/tabaka.lua/issues">
    <img alt="Issues" src="https://img.shields.io/github/issues/nyngwang/tabaka.lua?style=for-the-badge&logo=bilibili&color=F5E0DC&logoColor=D9E0EE&labelColor=302D41" />
  </a>
  <a href="https://github.com/nyngwang/tabaka.lua">
    <img alt="Repo Size" src="https://img.shields.io/github/repo-size/nyngwang/tabaka.lua?color=%23DDB6F2&label=SIZE&logo=codesandbox&style=for-the-badge&logoColor=D9E0EE&labelColor=302D41" />
  </a>
</div>

## 🔭 Preview

<img src="https://github.com/user-attachments/assets/686b6320-4227-4aa8-b9ac-721c23cea846" width="500">


## 🚚 Features

- 💪 Extend every tabpage by allowing you to store a file to each side of your editor screen!
  - 📨 Put it simple, Tabaka.lua provides four drawers for each tabpage.
  - 🧘 For a peaceful mind, Tabaka.lua only shows one drawer at a time.
- 🙆 Ergonomic design
  - 1️⃣ Remember one command is enough, spamming your Tab-key to complete all the remaining parts!
  - 🧭 Straight-forward workflow: Toggle a Side, Set the File, and You're Fine!
  - 🔌 Restoring from a session? Supported!
  - 🔀 Re-ordering tabpages? No problem!
  - 💤 Tired of setting `setup()`? Just `setup()` can still work!
- 🛠️ Customizable
  - Support custom {height,width} of the window on each side.
  - Support custom callbacks (WIP)
- ♾️ Extensible
  - Support custom action commands by the action system (WIP)
  - Support custom file creation command by the template system (WIP)

## ⚡️ Requirements

- Neovim >= **0.7.0**
  - the requiring API is `nvim_get_option_value`.

## 🚀 Getting Started

```lua
{
  'nyngwang/Tabaka.lua',
  config = function ()
    require('tabaka').setup()
  end
}
```
