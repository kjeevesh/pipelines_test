#!/bin/bash

set -e

# Update and install required dependencies
apt-get update
apt-get install -y wget curl gnupg2 software-properties-common apt-transport-https ca-certificates lsb-release

# Import MongoDB GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/mongodb-6.gpg

# Add MongoDB repository
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Update and install MongoDB
apt-get update
apt-get install -y mongodb-org

# Enable and start MongoDB service
systemctl enable --now mongod

# Check MongoDB service status
systemctl status mongod

# Print MongoDB version
mongod --version

# Enter the MongoDB shell and create a user
mongosh <<EOF
use admin
db.createUser({user: "SAPITSM", pwd: "Azureuser@123", roles: [{role: "root", db: "admin"}]})
EOF

# Start MongoDB with specified options
mongod --bind_ip 0.0.0.0