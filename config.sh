#!/bin/bash

if [ $HOSTNAME == 'mgood-desktop' ]; then
	ansible-playbook ~/configs/ansible/desktop.yml --ask-sudo-pass -v
elif [ $HOSTNAME == 'wintermute' ]; then
	ansible-playbook ~/configs/ansible/laptop.yml --ask-sudo-pass -v
fi	

# Sublime Text
mkdir -p ~/.config/sublime-text-3/Packages
ln -sf ~/configs/sublime-text-3 ~/.config/sublime-text-3/Packages/User

# SSH
rm -rf ~/.ssh
ln -sf ~/configs/ssh ~/.ssh
