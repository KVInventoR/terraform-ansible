#!/bin/bash

cp /vagrant/terraform-plugins/terraform-provider-ansible_v0.0.1 /usr/local/bin

cat >> "/root/.terraformrc" << EOF
providers {
    ansible = "/usr/local/bin/terraform-provider-ansible_v0.0.1"
}
EOF