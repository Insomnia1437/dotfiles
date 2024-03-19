# tmux

> This is a personnal quick reference for tmux configuration

## Usage

`prefix =`, choose-buffer
- Enter 	Paste selected buffer
- Up 	Select previous buffer
- Down 	Select next buffer
- C-s 	Search by name or content
- n 	Repeat last search
- t 	Toggle if buffer is tagged
- T 	Tag no buffers
- C-t 	Tag all buffers
- p 	Paste selected buffer
- P 	Paste tagged buffers
- d 	Delete selected buffer
- D 	Delete tagged buffers
- e 	Open the buffer in an editor
- f 	Enter a format to filter items
- O 	Change sort field
- r 	Reverse sort order
- v 	Toggle preview
- q 	Exit mode

## tmux option

- `-2`, `-T 256`, assume the terminal supports 256 colours
- `-T  features`, set terminal features
`-S socket-path`

## frequently used options 
- `-t`,  argument is one of target-client, target-session, target-window, or target-pane. e.g., `mysession:mywindow.1`
- `-F`, format
- `-f`, filter is a specifal format. If it evaluates to zero, the item in the list is not shown, otherwise it is shown.
- `-p`, `-w`, `-s`, `-g`: panel, window, server, global
## command types
There are several types of commands/options.
- client and sessions
- windows and panes
- copy mode
- arrangements of pane
- layout of panes
- key bindings
### key table
- prefix (with prefix)
- root (no prefix)
- copy-mode
- copy-mode-vi

### some important commands
#### bind-key
`bind-key [-nr] [-N note] [-T key-table] key command [argument ...]`, alias: `bind`
- `-n`, means `-T root`
- `-r`, use together with `repeat-time ms`, means this command can be repeated without pressing the prefix-key again. Repeat is enabled for the default keys bound to the `resize-pane` command.
- `N`, add notes

#### set-option
`set-option [-aFgopqsuUw] [-t target-pane] option value`, alias: `set`
- `-o`, prevents setting an option that is already set
- `-u`, unsets an option
- `-a`, append

#### show-options
- `-H`, hooks
- `-A`, inherited from a parent set of options
```
# server options
tmux show -s
# pane options
tmux show -p
# window options
tmux show -w
# session options
tmux show
# global session or window options
tmux show -g
```
## format
https://man.archlinux.org/man/tmux.1#FORMATS

- basic format: 
Use `#{` and `}`,  e.g., `#{session_name}`
- conditional: 
`#{?a,b,c}`, e.g., `#{?session_attached,attached,not attached}`
    - nested conditional: 
    `,` and `}` are escaped. e.g., `#{?pane_in_mode,#[fg=white#,bg=red],#[fg=red#,bg=white]}`
- string compare: 
`==`, `!=`, `<`, `>`, `<=` or `>=` and a colon. e.g., `#{==:#{host},myhost}`
- AND and OR:
`&&`, `||` e.g., `#{||:#{pane_in_mode},#{alternate_on}}`
- fnmatch or regex: 
`m`, `/ri` means regex and ignore case, e.g., `#{m:*foo*,#{host}}` or `#{m/ri:^A,MYVAR}`
- content search in a pane: 
`#{C/r:^Start}`
- Numeric operators: 
    - `e`, e.g.,`#{e|*|f|4:5.5,3}` means multiplies 5.5 by 3 for a result with four decimal places
    - `+`, `-`, `*`, `/`, `m` or `%%` (mod), `==`, `!=` ...
    - `a` for ascii. `#{a:98}` gets `b`
    - `c` for six-digit hexadecimal RGB value.
- string length:
    - `=`, `#{=5:pane_title}` gets first five characters. 
    - `#{=-5:pane_title}` is last five
    - `#{=/5/...:pane_title}` gets "...TITLE"
    - `p` pad string. `#{p10:pane_title}`
    - `n`, string length `#{n:window_name}`
    - `t`, timestamp, `#{t:window_activity}`, `f` for custom format. e.g., `#{t/f/%%H#:%%M:window_activity}`
- path:
    - `b:` basename
    - `d:` dirname
- other:
    - `q:` escape
    - `h` escape `#`
    - `E:` expand the format twice
    - `T:` like `E:`, also expands timestamp format
    - `S:`, `W:`, `P:` or `L:`, loop over each session, window, pane or client and insert the format once for each.
    - `N:`, window/session name exist. `N/w:foo` for windows, `N/s:foo` for session
    - `l`, do not expand
    - `#(uptime)`, run shell command
    - `s|foo/|bar/|:`, substitution

## styles
- when used in format, enclosed in `#[` and `]`