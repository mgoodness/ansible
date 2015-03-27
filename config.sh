#!/bin/bash

if [ $HOSTNAME == 'mgood-desktop' ]; then
	ansible-playbook ~/configs/ansible/desktop.yml -e @~/configs/ansible/keys.yml --ask-vault-pass --ask-sudo-pass -v
elif [ $HOSTNAME == 'neuromancer' ]; then
	ansible-playbook ~/configs/ansible/laptop.yml -e @~/configs/ansible/keys.yml --ask-vault-pass --ask-sudo-pass -v
fi	

# Sublime Text
mkdir -p ~/.config/sublime-text-3/Local
cp License.sublime_license ~/.config/sublime-text-3/Local/

# SSH
rm -rf ~/.ssh
ln -sf ~/configs/ssh ~/.ssh
