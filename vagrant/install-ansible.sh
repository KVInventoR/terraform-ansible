#!/bin/bash

if [ -f /etc/debian_version ]; then
    sudo apt-get update -y > /dev/null 2>&1
    sudo apt-get install software-properties-common -y > /dev/null 2>&1
    sudo apt-add-repository ppa:ansible/ansible -y > /dev/null 2>&1
    sudo apt-get update -y > /dev/null 2>&1
    sudo apt-get install ansible -y > /dev/null 2>&1
elif [ -f /etc/redhat-release ]; then
    git clone https://github.com/ansible/ansible.git
    cd ./ansible
    make rpm
    sudo rpm -Uvh ./rpm-build/ansible-*.noarch.rpm
else
    echo "Unknown OS, terminating.."
    exit 1
fi