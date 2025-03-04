#!/bin/bash

echo "Installing docker"
sudo apt-get install -y docker.io
sudo systemctl enable --now docker

echo "Pulling ansible"
sudo docker pull ansible/ansible:ubuntu
sudo docker run --rm -i -t ansible/ansible:ubuntu ansible --version
