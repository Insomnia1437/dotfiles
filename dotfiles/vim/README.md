# VIM 

leader key: `,`

- `<leader>ev` edits .vimrc
- `<leader>sv` sources .vimrc
- `w!!` sudo write
- `<leader>l` display of unprintable characters
- `<leader>cd` cd to the directory of the current buffer
- `<leader><Tab>` switch between tabs
- `<leader>t` new tab
- `<leader>w` write
- `<Space>` toggle fold
- `<leader>\|` vertical split
- `<leader>-` horizontal split
- `<leader>pp` toggle paste mode
- `<leader>s` remove trailing spaces
- `<leader>$` fixes mixed EOLs
- `<leader>rt` retab (tab -> space, space -> tab)
- yank/paste to/from the OS clipboard
    - `noremap <silent> <leader>y "+y`
    - `noremap <silent> <leader>Y "+Y`
    - `noremap <silent> <leader>p "+p`
    - `noremap <silent> <leader>P "+P`
- window navigation
    - `<C-h> <C-w>h`
    - `<C-j> <C-w>j`
    - `<C-k> <C-w>k`
    - `<C-l> <C-w>l`
    - `<Tab><Tab> <C-w>w`
- `<C-n>` next buffer
    - `nnoremap <silent> <C-n> :bnext<CR>`
- `<C-p>` previous buffer
    - `nnoremap <silent> <C-p> :bprev<CR>`
- exit from insert mode without cursor movement
    - `inoremap jk <ESC>`^`
- `<leader><Space>` disable highlight
- `<leader>h1` h1 h2 h3 to highlight different color
- `<leader>; :%s/\<<C-r><C-w>\>//<Left>` replace current word