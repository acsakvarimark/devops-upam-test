#!/bin/bash

echo "Installing docker"
sudo apt-get update && sudo apt-get install -y docker.io
sudo systemctl enable --now docker

echo "Pulling ansible"
sudo docker pull ansible/ansible:stable
sudo docker run --rm -it --user $(id -u $NEW_USER):$(id -g $NEW_USER) ansible/ansible:latest /bin/bash
