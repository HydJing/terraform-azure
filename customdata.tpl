#!/bin/bash

# Update the package index
sudo apt-get update -y

# Upgrade existing packages (optional, but good practice for fresh installs)
sudo apt-get upgrade -y

# Install prerequisite packages for Docker
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add the Docker APT repository
# This command adds the official Docker repository to your system's sources list.
# 'lsb_release -cs' dynamically gets the codename of your Ubuntu distribution (e.g., 'bionic', 'focal').
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package index again after adding the new Docker repository
sudo apt-get update -y

# Install Docker Engine, CLI, and Containerd
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

# Add the 'ubuntu' user to the 'docker' group
# This allows the 'ubuntu' user to run docker commands without needing 'sudo'.
# The user will need to log out and log back in (or reboot the VM) for this change to take effect.
sudo usermod -aG docker ubuntu