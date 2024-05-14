# shell

<p align="center">
  <kbd>
      <img src="https://img.shields.io/badge/Open%20Source-3DA639?logo=Open%20Source%20Initiative &logoColor=white" />
  </kbd>
</p>
<p align="center">
  <kbd>
      <img src="https://img.shields.io/badge/Git-F05032?logo=Git&logoColor=white" />
      <img src="https://img.shields.io/badge/Python-3776AB?logo=Python&logoColor=white" />
      <img src="https://img.shields.io/badge/Vim-019733?logo=Vim&logoColor=white" />
      <img src="https://img.shields.io/badge/Visual%20Studio%20Code-007ACC?logo=Visual%20Studio%20Code&logoColor=white" />
      <img src="https://img.shields.io/badge/Microsoft%20Terminal-4D4D4D?logo=Windows%20Terminal&logoColor=white" />
  </kbd>
</p>

I started collecting the configuration of my Linux home directory in 2005, before `.dotfiles` became a common term and collected as a repo, so I named mine `shell/` (maybe I'll update it in the future).

I continue to refine both its structure and the files inside, sometimes imperfectly.
* The repo is meant to be checked out in a place that's easily managed (maybe with other repos, or on a network if in a setup where multiple computers might use it).
  * My typical convention is to put it in `Documents/shell/`, but that's just a personal preference.
* Because many files are required to be in the user `${HOME}` directory (`~`), I then create symlinks to point to the repo:
  * `~/.bash_logout`
  * `~/.bash_profile`
  * `~/.gitconfig`
  * `~/.rc` (pointed to from shell's respective run commands file, usually `.bashrc`)
  * `~/.plan` (not really a necessary thing anymore, but I keep out of legacy)
  * `~/.rezconfig.py` (only for places where `rez` is used)
  * `~/.vim/`

On Windows, using Microsoft Terminal, it's also good to create a symlink to its settings file:
* `C:\Users\jason\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState/settings.json -> Microsoft-Terminal--settings.json`
  * TODO: Might need a better name or automate this one.


Some files cannot be symlink'd for them to work properly: (although none of these are really used on Windows)
* `~/.forward`
* `~/.pgpkey`
* `~/.plan` (TODO: why is this duplicated from above?)
* `~/.project`
* `~/.viminfo` (Not currently used)
