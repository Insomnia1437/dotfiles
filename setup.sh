#!/bin/bash
PROJ_PATH=`pwd`
OH_MY_ZSH=$HOME"/.oh-my-zsh"
VUNDLE=$HOME"/.vim/bundle/Vundle.vim"
PYENV_ROOT=$HOME"/.pyenv"

IS_VIM=0
IS_GIT=0
IS_BASH=0
IS_ZSH=0
IS_TCSH=0
IS_TMUX=0
IS_SCREEN=0

# read -p "CHOOSE SHELL (bash , zsh or tcsh)? " _shell
# echo $choose_shell


# if [ "$_shell" = "bash" ]; then
#     unset IS_ZSH
#     unset IS_TCSH
# elif [ "$_shell" = "zsh" ]; then
#     unset IS_BASH
#     unset IS_TCSH
# elif [ "$_shell" = "tcsh" ]; then
#     unset IS_BASH
#     unset IS_ZSH
# else
#     echo "Invalid shell type, exit."
#     exit 1
# fi

# Pre check
check_installed() {
    softwares=("vim" "git" "tmux" "screen" "bash" "tcsh" "zsh")
    # bash >= 4.2
    # if [ -v IS_TCSH ]; then
    #     softwares+=( "tcsh" )
    # elif [ -v IS_ZSH ]; then
    #     softwares+=( "zsh" )
    # else
    #     softwares+=( "bash" )
    # fi
    for sw in "${softwares[@]}"
    do
        flag="IS_${sw^^}"  # bash >= 4.0
        # Notice the semicolon
        # Dynamic naming:
        # - https://stackoverflow.com/a/13717788/1276501
        # - https://stackoverflow.com/a/18124325/1276501
        type ${sw} > /dev/null 2>&1 &&
            { printf -v "${flag}" 1; } ||
            { echo >&2 "[WARN] \`${sw}' is not installed, ignore it."; }
    done
}

create_symlinks() {
    # dotfile_src format such as zsh/zshrc or vim/vimrc
    dotfile_src=$1
    dotfile_dst=$2
    if [[ "$dotfile_dst" != /*  ]]; then
        # relative path
        dotfile_dst=$HOME/$dotfile_dst
    fi
    if [ -e $dotfile_dst ]; then
        if [ -h $dotfile_dst ]; then
            /bin/ln -nsf ${PROJ_PATH}/$dotfile_src $dotfile_dst
            echo "Update existed symlink $dotfile_dst"
        else
            echo "[WARN] Ignore due to $dotfile_dst exists and is not a symlink"
        fi
    else
        /bin/ln -nsf ${PROJ_PATH}/$dotfile_src $dotfile_dst
        echo "Create symlink $dotfile_dst"
    fi
}

#
# tcsh
#

config_tcsh(){
    create_symlinks "tcsh/tcshrc" ".tcshrc"
    create_symlinks "tcsh/tcshrc.alias" ".tcshrc.alias"
    create_symlinks "tcsh/tcshrc.bindkey" ".tcshrc.bindkey"
    create_symlinks "tcsh/tcshrc.complete" ".tcshrc.complete"
    create_symlinks "tcsh/tcshrc.hosts" ".tcshrc.hosts"
    create_symlinks "tcsh/tcshrc.set" ".tcshrc.set"
    create_symlinks "tcsh/tcshrc.local" ".tcshrc.local"
}

#
# VIM
#
_install_vundle(){
    if [ -d "${VUNDLE}" ]; then
        cd "${VUNDLE}"
        echo "Change directory to `pwd`"
        echo "${VUNDLE} exists. Git pull to update..."
        git pull
        cd ${PROJ_PATH} > /dev/null 2>&1
        echo "Change directory back to `pwd`"
    else
        echo "${VUNDLE} not exists. Git clone to create..."
        git clone https://github.com/gmarik/Vundle.vim.git ${VUNDLE}
        vim +PluginInstall +qall
    fi
}

config_vim() {
    # _install_vundle
    create_symlinks "vim/vimrc" ".vimrc"
}


#
# GIT
#
config_git() {
    create_symlinks "git/gitconfig" ".gitconfig"
    # create_symlinks "git/tigrc" ".tigrc"
}


_config_shell() {
    create_symlinks "custom" ".custom"
}

_config_shell

#
# BASH
#
config_bash() {
    create_symlinks "bash/bashrc" ".bashrc"
}


#
# ZSH
#
_install_oh_my_zsh() {
    if [ -d "${OH_MY_ZSH}"  ]; then
        cd "${OH_MY_ZSH}"
        echo "Change directory to `pwd`"
        echo "${OH_MY_ZSH} exists. Git pull to update..."
        git pull

        if [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"  ]; then
            echo "zsh-autosuggestions exists, update..."
            cd "${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
            git pull
            cd ${PROJ_PATH} > /dev/null 2>&1
        else
            git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        fi

        if [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-completions"  ]; then
            echo "zsh-completions exists, update..."
            cd "${HOME}/.oh-my-zsh/custom/plugins/zsh-completions"
            git pull
            cd ${PROJ_PATH} > /dev/null 2>&1
        else
            git clone https://github.com/zsh-users/zsh-completions ${HOME}/.oh-my-zsh/custom/plugins/zsh-completions
        fi

        if [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"  ]; then
            echo "zsh-syntax-highlighting exists, update..."
            cd "${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
            git pull
            cd ${PROJ_PATH} > /dev/null 2>&1
        else
            git clone https://github.com/zsh-users/zsh-syntax-highlighting ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        fi

        if [ -d "${HOME}/.oh-my-zsh/custom/plugins/zsh-history-substring-search"  ]; then
            echo "zsh-history-substring-search exists, update..."
            cd "${HOME}/.oh-my-zsh/custom/plugins/zsh-history-substring-search"
            git pull
            cd ${PROJ_PATH} > /dev/null 2>&1
        else
            git clone https://github.com/zsh-users/zsh-syntax-highlighting ${HOME}/.oh-my-zsh/custom/plugins/zsh-history-substring-search
        fi

        cd ${PROJ_PATH} > /dev/null 2>&1
        echo "Change directory back to `pwd`"
    else
        echo "${OH_MY_ZSH} not exists. Install..."
        #git clone git@github.com:robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
        #wget --no-check-certificate http://install.ohmyz.sh -O - | sh
        git clone https://github.com/robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
        # install auto-suggestions
        git clone https://github.com/zsh-users/zsh-autosuggestions ${HOME}/.oh-my-zsh/custom/plugins/zsh-autosuggestions
        # install zsh-completions
        git clone https://github.com/zsh-users/zsh-completions ${HOME}/.oh-my-zsh/custom/plugins/zsh-completions
        # install syntax-highlighting
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
        # install zsh-history-substring-search
        git clone https://github.com/zsh-users/zsh-history-substring-search ${HOME}/.oh-my-zsh/custom/plugins/zsh-history-substring-search
        echo "Install oh-my-zsh success..."
    fi
}

config_zsh() {
    _install_oh_my_zsh
    create_symlinks "zsh/zshrc" ".zshrc"
    echo "[INFO] Change your shell manually"
}


#
# TMUX
#
config_tmux(){
    create_symlinks "tmux/tmux.conf" ".tmux.conf"
    # create_symlinks "tmux/tmux.sh" ".tmux.sh"
}



#
# SCREEN
#
config_screen() {
    create_symlinks "screen/screenrc" ".screenrc"
}

#
# pyenv
#
_install_pyenv() {
    # for pyenv and pyenv-virtualenv
    # Install
    if [ -d "${PYENV_ROOT}"  ]; then
        cd "${PYENV_ROOT}"
        echo "Change directory to `pwd`"
        echo "${PYENV_ROOT} exists. Git pull to update..."
        git pull
        cd ${PROJ_PATH} > /dev/null 2>&1
        echo "Change directory back to `pwd`"
    else
        echo "${PYENV_ROOT} not exists. Install..."
        #git clone git@github.com:robbyrussell/oh-my-zsh.git ${HOME}/.oh-my-zsh
        #wget --no-check-certificate http://install.ohmyz.sh -O - | sh
        git clone https://github.com/pyenv/pyenv.git ${PYENV_ROOT}
        git clone https://github.com/pyenv/pyenv-virtualenv.git ${PYENV_ROOT}/plugins/pyenv-virtualenv
    fi
}

config_pyenv() {
    _install_pyenv
}


check_installed
[ "$IS_BASH" -eq 1 ] && config_bash
[ "$IS_TCSH" -eq 1 ] && config_tcsh
[ "$IS_ZSH" -eq 1 ] && config_zsh
[ $IS_GIT -eq 1 ] && config_git
[ $IS_VIM -eq 1 ] && [ $IS_GIT -eq 1 ] && config_vim
[ $IS_GIT -eq 1 ] && config_pyenv
[ $IS_SCREEN -eq 1 ] && config_screen
[ $IS_TMUX -eq 1 ] && config_tmux

echo "[SETUP OK]"