# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="ys"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git history systemd sudo z
        gitignore extract safe-paste colored-man-pages
        )

source $ZSH/oh-my-zsh.sh
# User configuration

export TERM="xterm-256color"

# Install Antigen
# Antigen: https://github.com/zsh-users/antigen
ANTIGEN="$HOME/.local/bin/antigen.zsh"

# Install antigen.zsh if not exist
if [ ! -f "$ANTIGEN" ]; then
        echo "Installing antigen ..."
        [ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
        [ ! -d "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin" 2> /dev/null
        URL="http://git.io/antigen"
        TMPFILE="/tmp/antigen.zsh"
        if [ -x "$(which curl)" ]; then
                curl -L "$URL" -o "$TMPFILE"
        elif [ -x "$(which wget)" ]; then
                wget "$URL" -O "$TMPFILE"
        else
                echo "ERROR: please install curl or wget before installation !!"
                exit
        fi
        if [ ! $? -eq 0 ]; then
                echo ""
                echo "ERROR: downloading antigen.zsh ($URL) failed !!"
                exit
        fi;
        echo "move $TMPFILE to $ANTIGEN"
        mv "$TMPFILE" "$ANTIGEN"
fi
# Initialize antigen
source "$ANTIGEN"

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Load the theme.
antigen theme ys
# antigen theme https://github.com/denysdovhan/spaceship-prompt spaceship

# Bundles from the default repo (robbyrussell's oh-my-zsh).
####### antigen bundle Tarrasch/zsh-autoenv # Suppoert for folder specific envirronment settings
# antigen bundle pip # Python package manager autocomplete helper
# antigen bundle common-aliases # Common aliases like ll and la
antigen bundle djui/alias-tips # Alias reminder when launching a command that is aliased
# antigen bundle arialdomartini/oh-my-git #Cool git theme
# antigen bundle ssh-agent # Launch ssh-agent
# antigen bundle lol # Some funny aliases (cf https://gist.github.com/norova/848213)
# antigen bundle tig # Aliases for tig
# antigen bundle autojump
# antigen bundle vi-mode

# antigen bundle git # Lots of git aliases
# antigen bundle sudo # Esc twice to add sudo in fornt of any command
# antigen bundle systemd # Aliases for systemctl functions
# antigen bundle history # aliases for showing and searching history
# antigen bundle command-not-found
# antigen bundle gitignore
# antigen bundle extract
# antigen bundle safe-paste
# antigen bundle colored-man-pages
# antigen bundle z

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-history-substring-search
# require iTerm and of course A MacBook Touch Bar
# antigen bundle zsh-users/zsh-apple-touchbar
antigen bundle zsh-users/zsh-syntax-highlighting

# config zsh-syntax-highlighting
# syntax color definition
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[assign]=none

# config zsh-users/zsh-autosuggestions
# ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"
# ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"

# Tell Antigen that you're done.
antigen apply

# How to know your keymap:
# Run cat -v in your favorite terminal emulator to observe key codes.
# (NOTE: In some cases, cat -v shows the wrong key codes.
# If the key codes shown by cat -v don't work for you,
# press <C-v><UP> and <C-v><DOWN> at your ZSH command line prompt for correct key codes.)

bindkey '^A' autosuggest-accept
bindkey '^Q' autosuggest-clear

# config history search
# Press `^U` to abort the search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
# bindkey -M vicmd 'k' history-substring-search-up
# bindkey -M vicmd 'j' history-substring-search-down


# Home
bindkey '^[[1~' beginning-of-line
bindkey '^[[H' beginning-of-line
# End
bindkey '^[[4~' end-of-line
bindkey '^[[F' end-of-line
# shift + left, right, up, down
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5A' beginning-of-line
bindkey '^[[1;5B' end-of-line

# set zsh options
# reference at http://zsh.sourceforge.net/Doc/Release/Options.html
unsetopt CORRECT_ALL
unsetopt CORRECT
unsetopt SHARE_HISTORY
setopt NO_BEEP
setopt INC_APPEND_HISTORY
setopt AUTO_PUSHD CDABLE_VARS PUSHD_IGNORE_DUPS PUSHD_MINUS PUSHD_SILENT
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# completion detail
zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.pdf|*.exe|*.dll'
zstyle ':completion:*:*sh:*:' tag-order files

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export VISUAL=vim
export EDITOR=vim

# proxy server
PROXY_SERVER=172.19.64.17:8080
# export http_proxy=http://${PROXY_SERVER}
# export https_proxy=https://${PROXY_SERVER}
alias setproxy="export http_proxy=http://${PROXY_SERVER}; export https_proxy=https://${PROXY_SERVER}"
alias unsetproxy="unset http_proxy=http://${PROXY_SERVER}; unset https_proxy=https://${PROXY_SERVER}"

# EPICS
uname=`uname`
arch=`uname -m`
case $uname in
"Linux")
        host_arch="linux-${arch}"
        ;;
"Darwin")
        host_arch="darwin-x86"
        ;;
esac

export  EPICS_BASE='~/epics/R3.14.12.8/base'
export  EPICS_HOST_ARCH=${host_arch}
export  EPICS_EXTENSIONS="$EPICS_BASE/../extensions"
export EPICS_CA_MAX_ARRAY_BYTES=10000000
#export EPICS_CA_AUTO_ADDR_LIST-NO
#export EPICS_CA_ADDR_LIST='172.19.64.78'

export  PATH=$EPICS_BASE/bin/$EPICS_HOST_ARCH:$PATH
export  PATH=${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}:$PATH

alias cdb="cd ${EPICS_BASE}"
alias cde="cd ${EPICS_EXTENSIONS}/bin/${EPICS_HOST_ARCH}"
alias cdi="cd ${EPICS_BASE}/../ioc"
alias cdd="cd ${HOME}/epics/download"
alias cdp="cd ${HOME}/workspace/python"

alias   cd..='cd ..'
alias   cd~='cd ~'
alias   ..='cd ..'
alias   ..2='cd ../..'
alias   ..3='cd ../../..'
alias   lsg='ls -lhFa | grep'
alias   du='du -h --max-depth=1'
alias   df='df -h'
alias   lw='ll `which \!*`'

# set git in linac server
# setenv PATH /usr/new/pkg/git/current/bin:$PATH

# set ssh Server
# alias   vera='ssh -X sdcswd@vera'
# alias   ganeza='ssh -X sdcswd@ganeza'
# alias   ganapati='ssh -X sdcswd@ganapati'
# alias   wang='ssh -X sdcswd@wang'
# alias   abcob06='ssh -X sdcswd@abcob06'

# for pyenv
# Install
# git clone https://github.com/pyenv/pyenv.git ~/.pyenv
# git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi
# eval "$(pyenv virtualenv-init -)"
