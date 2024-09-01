#!/bin/bash

DOMAIN="msmathguide.education"

sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo service mongod start

sudo apt-get install -y git htop make npm

git clone https://github.com/MiddleSchoolMathGuide/backend
cd backend
git submodule update --init --recursive

sudo npm cache clean -f
sudo npm install -g n
sudo n latest

sudo apt install certbot

sudo ufw allow 443
sudo certbot certonly --standalone -d $DOMAIN

ln -s /etc/letsencrypt/live/$DOMAIN/fullchain.pem cert.pem
ln -s /etc/letsencrypt/live/$DOMAIN/privkey.pem key.pem

make install
