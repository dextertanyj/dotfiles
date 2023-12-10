#!/usr/bin/env bash

BASEDIR=$PWD

if ! zsh --version &> /dev/null; then
    echo "Please install ZSH."
    exit 1
fi

if [ "$(uname -s)" == "Darwin" ]; then
    mkdir -p $HOME/Library/Fonts
    cp $BASEDIR/fonts/*.ttf $HOME/Library/Fonts/
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    mkdir -p $HOME/.local/share/fonts
    cp $BASEDIR/fonts/*.ttf $HOME/.local/share/fonts/
    if type fc-cache &> /dev/null; then
        fc-cache -f
    fi
else
    echo "Unsupported platform."
    exit 1
fi

if (test $? -ne 0) then
    echo "Error installing fonts."
    exit 1
fi

git submodule --quiet init
if (test $? -ne 0) then
    echo "Error initializing submodules."
    exit 1
fi

git submodule --quiet update
if (test $? -ne 0) then
    echo "Error updating submodules."
    exit 1
fi

git clone --quiet https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
if (test $? -ne 0) then
    echo "Error cloning Oh My Zsh."
    exit 1
fi

for file in .*
do
    if [ "$file" == "." ] || [ "$file" == ".." ] || [ "$file" == ".DS_Store" ]; then
        continue
    elif [ "$file" == ".git" ] || [ "$file" == ".gitmodules" ] || [ "$file" == ".gitignore" ]; then
        continue
    fi
    ln -s "$BASEDIR/$file" "$HOME/$file"
done
