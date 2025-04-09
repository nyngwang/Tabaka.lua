Tabaka.lua
---
<div align="center">
  <img src="https://github.com/user-attachments/assets/3b812b9b-0ed9-4974-a574-3538cea38e6e" width="400">
  <p><i>Extend Your <b>Tab</b>pages for Notes{🎶,📝} <br>
    and Never Feel Like an Absentminded <b>Baka</b> Again!</i></p>
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
  - 🗄️ Put it simple, Tabaka.lua provides four drawers for each tabpage.
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

## 🚀 Getting Started

```lua
{
  'nyngwang/Tabaka.lua',
  config = function ()
    require('tabaka').setup()
  end
}
```

## 🏹 Todos


<details>

- tabaka can provide the following functionalities:
  - [x] for each tabpage, a user can `{toggle}` the tabaka window on the `{top,bottom,left,right}`-side
    - [x] a user can only toggle `{one}` tabaka window at a time for each tabpage
    - [x] open the tabaka window send the cursor into it
    - [x] close the tabaka window put the cursor back to where it was
  - [x] for each tabpage, a user can `{link}` `{one}` file to each of the `{top,bottom,left,right}`-side
    - [x] to `{link}` a file to one of the sides, open the file in the tabaka window on that side
    - [x] the linked file will be shown when the tabaka window is toggled on that side
  - [x] for each tabpage, only necessary commands will be available
    - [x] the `{common}` commands are available regardless of a `{filetype}` file being shown or not
      - [x] the `{toggle}` command is available anywhere, anytime
    - [x] the `{filetype}` commands are available when the tabaka window shows a `{filetype}` file
    - [x] the `{filetype::create}` command is available when the tabaka window is shown
      - [ ] it can create a file from `{bundled}` templates
      - [ ] it can create a file from `{user}` templates
  - [x] for each tabpage, everything should works regardless of `{tabpage-reordering,restoring-session}`
  - [x] close a tabpage will not delete those linked files
    - [ ] how to restore the state of a closed tabpage?
- tabaka should follow these invariants:
  - [ ] it should not create/delete any markdown file implicitly
- tabaka can be customized by the following properties:
  - [x] a user can define the width/height of the tabaka window on each side of a tabpage

</details>









