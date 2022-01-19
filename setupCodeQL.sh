#!/bin/bash

# Make the directory.
mkdir /home/codeql_home

# Go to it.
cd /home/codeql_home

# Download and unzip CodeQL source.
curl -L -o codeql-linux64.zip https://github.com/github/codeql-cli-binaries/releases/download/v2.3.4/codeql-linux64.zip
unzip codeql-linux64.zip 

# Clone stable version of CodeQL.
git clone https://github.com/github/codeql.git --branch v1.26.0 codeql-repo

# Set up the path.
echo "export PATH=/home/codeql_home/codeql:$PATH" >> /root/.bashrc

# Remove this.
cd /home
rm setupCodeQL.sh

# Done!
