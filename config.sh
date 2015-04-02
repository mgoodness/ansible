#!/bin/bash

KEYFILE="@$HOME/configs/ansible/keys.yml"

ansible-playbook ~/configs/ansible/$HOSTNAME.yml -e $KEYFILE --ask-vault-pass --ask-sudo-pass -v

# SSH
#rm -rf ~/.ssh
#ln -sf ~/configs/ssh ~/.ssh
