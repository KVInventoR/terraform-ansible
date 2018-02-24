#!/bin/bash

if [ -f /etc/debian_version ]; then
    sudo apt-get update -y > /dev/null 2>&1
elif [ -f /etc/redhat-release ]; then
    sudo yum update -y > /dev/null 2>&1
else
    echo "Unknown OS, terminating.."
    exit 1
fi
