#!/bin/bash

echo "Installing docker"
sudo apt-get install -y docker.io
sudo systemctl enable --now docker

echo "Pulling ansible"
sudo docker pull ansible/ansible:ubuntu1604
sudo docker run --rm -t ansible/ansible:ubuntu1604
