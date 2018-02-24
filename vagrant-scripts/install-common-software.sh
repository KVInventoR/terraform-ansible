#!/bin/bash

if [ -f /etc/debian_version ]; then
    echo "Installing software.."
    apt-get install jq tree unzip -y > /dev/null 2>&1
elif [ -f /etc/redhat-release ]; then
    echo "Installing software.."
    yum install jq tree unzip -y > /dev/null 2>&1
else
    echo "Unknown OS, terminating.."
    exit 1
fi
