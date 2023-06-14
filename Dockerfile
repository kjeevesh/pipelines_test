FROM ubuntu:22.04

# Update and install required dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg 

# Import MongoDB public GPG key
RUN curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | gpg --dearmor --output /etc/apt/trusted.gpg.d/mongodb.gpg

# Add MongoDB repository
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

# Update and install MongoDB shell
RUN apt-get update && \
    apt-get install -y mongodb-mongosh

# Download and extract MongoDB binaries
RUN mkdir /mongodb && \
    cd /mongodb && \
    curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.7.tgz && \
    tar xvf mongodb-linux-x86_64-3.4.7.tgz && \
    mv mongodb-linux-x86_64-3.4.7 mongodb

# Add MongoDB bin directory to PATH variable
ENV PATH="/mongodb/mongodb/bin:${PATH}"

# Create a directory for MongoDB files
RUN mkdir /data

# Start MongoDB and add user
RUN mongod --dbpath /data --fork --logpath /var/log/mongodb.log && \
    echo 'use admin' >> /tmp/add_user.js && \
    echo 'db.createUser({user: "SAPITSM", pwd: "Azureuser@123", roles: [{role: "root", db: "admin"}]})' >> /tmp/add_user.js && \
    mongo < /tmp/add_user.js && \
    mongod --dbpath /data --shutdown



RUN apt-get install -y python3 python3-pip

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Install Elasticsearch
RUN curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -


RUN echo "deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list

RUN apt-get update && apt-get install -y elasticsearch-oss



RUN apt-get install -y kibana-oss



RUN apt-get install -y nginx

# Install additional Node.js packages
RUN npm install -g axios swagger-ui-express express

RUN pip3 install flask

EXPOSE 27017 9200 5000

# Start MongoDB
# CMD mongod --dbpath /data && service elasticsearch start && service kibana start && tail -f /dev/null
CMD ["/bin/bash", "-c","mongod --dbpath /data &&  service elasticsearch start && service kibana start && tail -f /dev/null"]
