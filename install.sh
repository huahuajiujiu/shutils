#!/bin/sh

set -e

if [ -d $HOME/.shutils ]; then
    echo "error: shutils already installed" >&2
    exit 1
fi

repo_url=https://github.com/huahuajiujiu/shutils.git
repo_dir=$HOME/.shutils

setup_bash() {
    local ostype=`uname -o 2> /dev/null || uname -s`
    case $ostype in
        Darwin)
            echo "source $HOME/.shutils/conf/shell/profile" >> $HOME/.bash_profile
            echo "source $HOME/.shutils/conf/shell/bashrc" >> $HOME/.bash_profile
            ;;
        Cygwin|GNU/Linux)
            echo "source $HOME/.shutils/conf/shell/profile" >> $HOME/.bashrc
            echo "source $HOME/.shutils/conf/shell/bashrc" >> $HOME/.bashrc
            ;;
    esac
}

setup_zsh() {
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "source $HOME/.shutils/conf/shell/profile" >> $HOME/.zshrc
}

setup_git() {
    sed "s#\$HOME#$HOME#g" $repo_dir/conf/git/gitconfig > $repo_dir/conf/git/gitconfig.new
    mv -f $repo_dir/conf/git/gitconfig.new $repo_dir/conf/git/gitconfig
    ln -sf $repo_dir/conf/git/gitconfig $HOME/.gitconfig
}

setup_vim() {
    ln -sf $repo_dir/conf/vim/vim $HOME/.vim
    ln -sf $repo_dir/conf/vim/vimrc $HOME/.vimrc
}

setup_tools() {
    cd $HOME/.shutils
    git submodule init
    git submodule update
}

git clone $repo_url $repo_dir

shell=$(expr "$SHELL" : '.*/\(.*\)')

if [ "$shell" = "bash" ]; then
    setup_bash
elif [ "$shell" = "zsh" ]; then
    setup_zsh
fi

setup_git
setup_vim
setup_tools
