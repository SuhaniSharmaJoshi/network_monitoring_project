#!/bin/bash
# Update the system
dnf update -y
# Install Docker
dnf install -y docker
# Start Docker Service
service docker start
# Enable Docker to start on boot
systemctl enable docker
# Add ec2-user to docker group to run commands without sudo
usermod -a -G docker ec2-user
#install git
dnf install -y git
