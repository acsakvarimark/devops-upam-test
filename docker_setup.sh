#!/bin/bash

echo "Installing docker"
sudo apt-get update && sudo apt-get install -y docker.io
sudo systemctl enable --now docker

"Pulling ansible image"
sudo docker pull ansible/ansible:latest
sudo docker run --rm -it --user $(id -u $NEW_USER):$(id -g $NEW_USER) ansible/ansible:latest /bin/bash
