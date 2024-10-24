Prerequisite: install [ripgrep](https://github.com/BurntSushi/ripgrep).

Forked from:
[The full video of me setting up this repo](https://www.youtube.com/watch?v=w7i4amO_zaE)


in case packer installs extensions with the wrong line ending, run this command
```
find /home/rei/.local/share/nvim/site/pack/packer/start/ -type f -name "*.vim" -exec vim -c ':w ++ff=unix' -c ':q' {} \;
```
[install packer](https://github.com/wbthomason/packer.nvim)
`brew install lua`
`brew install fzf`
`brew install ripgrep`


