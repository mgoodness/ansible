#!/bin/bash

for v in /home/vagrant/*; do
	[ -d $v ] && cd "$v" && vagrant halt
done
