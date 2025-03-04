#!/bin/bash

echo "Installing docker"
sudo apt-get install -y docker.io
sudo systemctl enable --now docker

echo "Pulling ansible"
sudo docker pull ansible/ansible:ubuntu1404
sudo docker run --rm -T ansible/ansible:ubuntu1404 ansible --version
