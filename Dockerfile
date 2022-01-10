FROM debian:latest
ARG DEBIAN_FRONTEND=noninteractive

# Fetch prerequisites.
RUN apt-get update \
	&& apt-get -y install --no-install-recommends git unzip vim curl nodejs npm

RUN apt update

# Create directories to store source code.
RUN mkdir -p /home/drasync/analysis
RUN mkdir -p /home/drasync/vis

# Create directories related to the evaluation.
RUN mkdir -p /home/evaluation

# COPY . /home/npm-filter

# Set working directory above sources and tests.
WORKDIR /home

# Misc. setup
RUN git config --global http.sslVerify "false"
RUN npm config set strict-ssl false
