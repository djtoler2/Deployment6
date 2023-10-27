#!/bin/bash

cd /home/ubuntu

sudo apt update
sudo apt install build-essential 
sudo apt install libmysqlclient-dev -y

#Download the Python & AWS installation scripts
curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/auto-python.sh
curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/auto-aws_cli.sh

#Make the scripts executable
chmod +x auto-python.sh
chmod +x auto-aws_cli.sh

#Run the Python & AWS installation scripts,,
./auto-python.sh
./auto-aws_cli.sh

#Install & run the application
curl -O https://raw.githubusercontent.com/djtoler/automated_installation_scripts/main/apps/banking-app.sh
chmod +x banking-app.sh
./banking-app.sh