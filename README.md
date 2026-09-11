# dotfiles managed with dotdrop

### Installation

Clone the repository first. The package manifests below are intended to bootstrap a
new machine; remove desktop-only packages if the target is a headless server.

```shell
git clone --recurse-submodules https://github.com/Insomnia1437/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
```

#### macOS

```shell
brew bundle --file packages/Brewfile
```

#### Debian 13

```shell
sudo apt-get update
xargs -a packages/debian.txt sudo apt-get install -y
```

The dotdrop install action clones fzf into `~/.fzf`; the shell configuration
always uses that copy and its built-in walker. `bat`/`batcat` is optional for
file previews, with an automatic fallback to `cat`.

fzf is pinned to version `0.65.2` for cross-platform compatibility. Change the
`FZF_VERSION` variable in `config.yaml` to select another release (with or
without the leading `v`), then run the normal install command:

```shell
dotdrop install -p profile_name
```

#### Arch Linux / Manjaro

```shell
sudo pacman -Syu --needed - < packages/arch.txt
```

#### RHEL-compatible distributions (EL 9/10)

```shell
sudo dnf makecache
xargs -a packages/rhel.txt sudo dnf install -y
```

After enabling EPEL (and any required CRB repository) using the instructions for
the specific distribution, install the optional modern CLI tools:

```shell
xargs -a packages/rhel-epel.txt sudo dnf --enablerepo=epel,crb install -y
```

For the Fedora Sway target, install its desktop packages as well:

```shell
xargs -a packages/fedora-sway.txt sudo dnf install -y
```

The macOS and Debian manifests install Dotdrop from the system package manager.
On systems without a packaged Dotdrop, use the embedded submodule:

```shell
python3 -m venv ~/.local/share/dotdrop-venv
~/.local/share/dotdrop-venv/bin/pip install -r dotdrop/requirements.txt
ENV_DIR=~/.local/share/dotdrop-venv ./dotdrop.sh install -p target-default-cli
```

### Update dotdrop submodule

```shell
# init submodule
$ git submodule update --init --recursive
# reset submodule to parent"s version
$ git submodule update --checkout dotdrop
# update submodule to upstream's latest version
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
dotdrop install -p profile_name
```

### Profiles

Install a `target-*` profile directly. The other profile prefixes are reusable
layers:

- `bundle-*`: a collection of baseline dotfiles
- `feature-*`: optional tools or capabilities
- `platform-*`: operating-system environments
- `desktop-*`: desktop environments
- `site-*`: site-specific settings such as the Linac environment
- `target-*`: final deployment targets

Current targets:

```text
target-default-cli
target-vps
target-wsl
target-raspi
target-linac
target-debian13-xfce
target-manjaro-kde
target-fedora-sway
target-macos
```

For example:

```shell
dotdrop install -p target-vps
dotdrop install -p target-debian13-xfce
dotdrop install -p target-fedora-sway
dotdrop install -p target-linac
```

### Package manifests

Package lists used when bootstrapping a new machine are stored under
`packages/`:

```text
packages/Brewfile
packages/debian.txt
packages/arch.txt
packages/fedora-sway.txt
packages/rhel.txt
packages/rhel-epel.txt
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
