# dotfiles managed with dotdrop

### Installation

```shell
# https://stackoverflow.com/questions/3796927/how-to-git-clone-including-submodules
# for version 2.13 of git and later
git clone --recurse-submodules https://github.com/Insomnia1437/dotfiles.git ~/.config/dotfiles
# otherwise
git clone --recursive https://github.com/Insomnia1437/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
pip3 install -r requirements.txt --user
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
dotdrop install -p profle_name
```

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
