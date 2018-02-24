#!/bin/bash

curl -O https://bootstrap.pypa.io/get-pip.py > /dev/null 2>&1
python get-pip.py > /dev/null 2>&1
rm -f get-pip.py
pip install awscli > /dev/null 2>&1
