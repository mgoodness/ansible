#!/bin/bash

KEYFILE="@$HOME/configs/ansible/keys.yml"

sudo yum install -y ansible

ansible-playbook ~/configs/ansible/$HOSTNAME.yml --ask-sudo-pass -v -e $KEYFILE --ask-vault-pass 

# SSH
#rm -rf ~/.ssh
#ln -sf ~/configs/ssh ~/.ssh
