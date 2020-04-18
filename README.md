# myhomedot

some configuration of my home dot files

current include:
- bash
- tcsh
- zsh
- vim
- pyenv
- tmux
- screen
- git


## For tcsh
 use this project https://github.com/simos/tcshrc.git

> original installation method
```shell
TCSHRC=$HOME"/.tcshrc"
git clone https://github.com/simos/tcshrc.git ${TCSHRC}
cd ${TCSHRC}
make backup
make install
```

## sh快捷键

```
**⌃ + u：清空当前行**
**⌃ + a：移动到行首**
**⌃ + e：移动到行尾**
⌃ + p：上一条命令
⌃ + n：下一条命令
⌃ + r：搜索历史命令
⌃ + y：召回最近用命令删除的文字
**⌃ + h：删除光标之前的字符**
**⌃ + d：删除光标所指的字符**
**⌃ + w：删除光标之前的单词**
**⌃ + k：删除从光标到行尾的内容**
⌃ + t：交换光标和之前的字符
```

## screen 快捷键

```
C-a ? -> 显示所有键绑定信息
C-a A -> 重命名
C-a c -> 创建一个新的运行shell的窗口并切换到该窗口
C-a n -> Next，切换到下一个 window
C-a p -> Previous，切换到前一个 window
C-a 0..9 -> 切换到第 0..9 个 window
C-a C-a -> 在两个最近使用的 window 间切换
C-a i -> info
C-a S -> 将显示器水平分割
C-a | -> 将显示器垂直分割
C-a <tab> -> 切换block
C-a X -> 关闭当前block
C-a Q -> 关闭其他block
C-a d -> detach
C-a z -> 把当前session放到后台执行，用 shell 的 fg 命令则可回去。
C-a w -> 显示所有窗口列表
C-a t -> Time，显示当前时间，和系统的 load
C-a k -> kill window，强行关闭当前的 window
```

## tmux 快捷键

**默认prefix command key是ctrl b，改成ctrl a，和`screen`一致**

```
prefix $: rename session
prefix [: enter copy mode, use `q` to quit
prefix ]: exit copy mode
prefix s: show session list
prefix :: enter shell

prefix c: create new window
prefix 0-9: select window
prefix p: pre window
prefix n: next window
prefix w: show window list
prefix ,: rename window
prefix .: change window number
prefix f: find window

prefix |(%)：horizontal pane。  # bind new key
prefix -(")：vertical pane。    # bind new key
prefix <arrow key>：switch pane
prefix ;：last used pane
prefix o：next pane
prefix {：pane left。
prefix }：pane right。
prefix Ctrl+o：rotate pane
prefix x：close pane
prefix !：change pane to window
prefix z：zoom up pane
prefix Ctrl+<arrow key>：change pane size
prefix q：show pane number, use number to choose
```