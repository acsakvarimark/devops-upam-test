#!/bin/bash

echo "Installing docker"
apt-get update && sudo apt-get install -y docker.io
systemctl enable --now docker

echo "Pulling ansible"
docker pull ansible/ansible:latest
docker run --rm -i -t ansible/ansible:latest ansible --version
