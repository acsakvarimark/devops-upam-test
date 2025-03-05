#!/bin/bash

echo "Installing docker"
sudo apt-get install -y docker.io
sudo systemctl enable --now docker


echo "Installing ansible"
sudo apt-get install -y ansible
ansible --version

