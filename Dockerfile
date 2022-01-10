FROM debian:latest
ARG DEBIAN_FRONTEND=noninteractive

# Fetch prerequisites.
RUN apt-get update \
	&& apt-get -y install --no-install-recommends git unzip vim curl nodejs npm

RUN apt update

# Create and move to source code directory.
RUN mkdir -p /home/drasync
WORKDIR /home/drasync/

# Fetch source code for the visualization.
RUN git clone https://github.com/reallyTG/p5-promise-viz.git

# Fetch source code for analysis output processing.
RUN git clone https://github.com/reallyTG/ProfilingPromisesProcessing.git

# Fetch source code for analysis.
RUN git clone https://github.com/reallyTG/ProfilingPromisesAnalysis.git

# Fetch code for anti-pattern detection queries.
RUN git clone https://github.com/reallyTG/ProfilingPromisesQueries.git

# Create directories related to the evaluation.
RUN mkdir /home/evaluation

# TODO: fetch all of the evaluation candidates.

# Set working directory above sources and tests.
WORKDIR /home

# Misc. setup
RUN git config --global http.sslVerify "false"
RUN npm config set strict-ssl false
