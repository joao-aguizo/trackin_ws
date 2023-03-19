#!/bin/bash

SIM_LOCATION=/opt/host

# link bash and zsh rc files
[ ! -e ~/.bashrc ] &&  ln -s $SIM_LOCATION/singularity_bashrc.sh ~/.bashrc
[ ! -e ~/.zshrc ] && ln -s $SIM_LOCATION/singularity_zshrc.sh ~/.zshrc
[ ! -e ~/.profile ] && ln -s $SIM_LOCATION/singularity_profile.sh ~/.profile

# link .tmux.conf
[ ! -e ~/.tmux.conf ] && [ -e $SIM_LOCATION/dottmux.conf ] && ln -s $SIM_LOCATION/dottmux.conf ~/.tmux.conf

# link .ssh key-pair
[ -e $SIM_LOCATION/ssh ] && [ ! -e ~/.ssh ] && ln -s $SIM_LOCATION/ssh ~/.ssh

touch ~/.sudo_as_admin_successful

export PS1="[${SIF_NAME^}] ${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
