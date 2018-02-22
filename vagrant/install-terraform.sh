#!/bin/bash

wget https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip > /dev/null 2>&1
unzip terraform_0.11.3_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm -f terraform_0.11.3_linux_amd64.zip
