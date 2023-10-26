#!/bin/bash

sudo apt update
sudo apt install -y default-jre

sudo apt install build-essential 
sudo apt install libmysqlclient-dev -y


curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/auto-terraform.sh
chmod +x auto-terraform.sh
./auto-terraform.sh