# dotfiles managed with dotdrop

### System requirement

Not only for dotdrop
#### RHEL
```shell
$ sudo yum install -y vim tar gzip bzip2 unzip perl-core pciutils net-tools lm_sensors telnet bash-completion sysstat python3 tree python3-pip git curl wget nfs-utils perf autofs rpm-build zsh tmux telnet screen
```
#### Debian

```shell
sudo apt install -y build-essential vim git tmux zsh telnet screen curl htop
```

### Installation

```shell
# https://stackoverflow.com/questions/3796927/how-to-git-clone-including-submodules
# for version 2.13 of git and later
$ git clone --recurse-submodules https://github.com/Insomnia1437/dotfiles.git ~/.config/dotfiles
# otherwise
$ git clone --recursive https://github.com/Insomnia1437/dotfiles.git ~/.config/dotfiles
$ cd ~/.config/dotfiles
# ./dotdrop/bootstrap.sh
$ pip3 install --user -r dotdrop/requirements.txt
# For Debian > 12, python modules are managed by apt.
$ sudo apt install dotdrop
# Or
$ sudo apt install python3-docopt python3-distro python3-ruamel.yaml python3-tomli-w python3-requests python3-packaging python3-jinja2 python3-magic
```

### Update dotdrop submodule

```shell
$ git submodule update --init --recursive
$ git submodule update --remote dotdrop

$ git add dotdrop
$ git commit -m 'update dotdrop'
$ git push
# on another machine
$ git submodule update
$ git pull
```

### Use dotdrop

```shell
dotdrop help
dotdrop install -p profle_name
```

### Themes
As I fee discomfort when looking at a dark background, so I decide to gradually migrate to [Catppuccin Latte](https://github.com/catppuccin/catppuccin) theme for all my environments.

### How to know your keymap:

Run cat -v in your favorite terminal emulator to observe key codes.
(NOTE: In some cases, cat -v shows the wrong key codes.
If the key codes shown by cat -v don't work for you,
press `CTRL-V`, then `CTRL-UP` and `CTRL-DOWN` at your ZSH command line prompt for correct key codes.)

`CTRL-V` is actually defined by shell bindings.
check it using
`bindkey | grep quote`

### CSH default bindings vi-mode

[Insert mode bindings](http://www.kitebird.com/csh-tcsh-book/bindings.pdf)

|Command                 |DefaultKeySequence(s)|
| ----                   | ----                |
|backward-char           |CTRL-B  |
|backward-delete-char    |BACKSPACE,DEL  |
|backward-delete-word    |CTRL-W  |
|backward-kill-line      |CTRL-U  |
|beginning-of-line       |CTRL-A  |
|clear-screen            |CTRL-L  |
|complete-word           |TAB  |
|end-of-line             |CTRL-E  |
|kill-line               |CTRL-K  |

### Acknowledgement
- [deadc0de6/dotdrop/](https://github.com/deadc0de6/dotdrop/)
- [tmux-plugins/tpm](https://github.com/tmux-plugins/tpm)
- [catppuccin/catppuccin](https://github.com/catppuccin/catppuccin)
- [gpakosz/.vim](https://github.com/gpakosz/.vim)
- [Bash-it/bash-it](https://github.com/Bash-it/bash-it)
- [alacritty/alacritty-them](https://github.com/alacritty/alacritty-theme)
- [alacritty/alacritty](https://github.com/alacritty/alacritty)
- [robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- [zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-users/zsh-completions](https://github.com/zsh-users/zsh-completions)
- [zsh-users/zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [zsh-users/zsh-history-substring-search](https://github.com/zsh-users/zsh-history-substring-search)
- [pyenv/pyenv](https://github.com/pyenv/pyenv)
- [pyenv/pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv)