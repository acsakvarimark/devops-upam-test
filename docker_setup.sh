#!/bin/bash

echo "Installing docker"
sudo apt-get update && sudo apt-get install -y docker.io
sudo systemctl enable --now docker

echo "Pulling ansible"
sudo docker pull ansible/ansible:latest
sudo docker run --rm -i -t ansible/ansible:latest ansible --version
