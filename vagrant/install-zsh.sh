#!/bin/bash

if [ -f /etc/debian_version ]; then
    echo "Installing zsh.."
    apt-get install zsh -y > /dev/null 2>&1
elif [ -f /etc/redhat-release ]; then
    echo "Installing epel repo.."
    yum install -y epel-release > /dev/null 2>&1
    yum install -y https://centos7.iuscommunity.org/ius-release.rpm > /dev/null 2>&1

    echo "Installing git.."
    yum install -y git2u > /dev/null 2>&1

    echo "Installing zsh.."
    yum install zsh -y > /dev/null 2>&1
else
    echo "Unknown OS, terminating.."
    exit 1
fi

echo "Installing OhMyZSH.."
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh > /dev/null 2>&1 
bash install.sh > /dev/null 2>&1
rm -f install.sh > /dev/null

echo "Changing login shell.."
chsh -s $(which zsh) > /dev/null 2>&1

echo "Clonning plugis.."
git clone git://github.com/zsh-users/zsh-autosuggestions /root/.oh-my-zsh/plugins/zsh-autosuggestions > /dev/null 2>&1
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.oh-my-zsh/plugins/zsh-syntax-highlighting > /dev/null 2>&1

echo "Adding plugis to config.."
echo "source /root/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /root/.zshrc
echo "source /root/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /root/.zshrc
