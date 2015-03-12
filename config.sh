#!/bin/bash

if [ $HOSTNAME == 'mgood-desktop' ]; then
	ansible-playbook ~/configs/ansible/desktop.yml --ask-sudo-pass -v
elif [ $HOSTNAME == 'wintermute' ]; then
	ansible-playbook ~/configs/ansible/laptop.yml --ask-sudo-pass -v
fi	

# Git
ln -sf ~/configs/gitconfig ~/.gitconfig
ln -sf ~/configs/gitignore_global ~/.gitignore_global

# Zsh
curl -L http://install.ohmyz.sh | sh
ln -sf ~/configs/zshrc ~/.zshrc
chsh -s /usr/bin/zsh

# Sublime Text
mkdir -p ~/.config/sublime-text-3/Packages
ln -sf ~/configs/sublime-text-3 ~/.config/sublime-text-3/Packages/User

# SSH
rm -rf ~/.ssh
ln -sf ~/configs/ssh ~/.ssh

