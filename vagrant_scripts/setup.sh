#!/usr/bin/env bash

# Bring up servers on Vagrant for Ansible deploy
# IP Addresses are passed as arguments

# Only run this once
if [ ! -f /tmp/setuprun ]; then
	touch /tmp/setuprun
else
	echo "Initial setup has already been run...skipping"
	exit
fi

# Checks return codes
function checkstatus {
	if [ $1 -ne 0 ]; then
	  echo "Something went wrong with update"
	  exit 1
	fi
}

## NO NEED, HOSTNAME IS SET BY VAGRANT, KEEPING IT JIC
# Set the hostname on Ubuntu

# if [ ! -z $1 ]; then
# 	echo -e "127.0.0.1\t$1" | sudo tee -a /etc/hosts
# 	sudo hostnamectl set-hostname $1
# fi

# echo "Installing Python for Ansible"
# sudo apt update > /dev/null 2>&1
# checkstatus $?
# sudo apt install -y python > /dev/null 2>&1
# checkstatus $?

echo "Add Vagrant IP's to etc hosts for name resolution"
# IP addresses are passed to this script via provisioner
for var in "$@"; do
    echo "$var" | sudo tee -a /etc/hosts > /dev/null 2>&1
done