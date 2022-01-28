FROM debian:latest
ARG DEBIAN_FRONTEND=noninteractive

# Fetch prerequisites.
RUN apt-get update \
	&& apt-get -y install --no-install-recommends git unzip vim curl nodejs npm parallel silversearcher-ag

RUN apt update

RUN npm i --g yarn

# Create and move to source code directory.
RUN mkdir -p /home/drasync
WORKDIR /home/drasync/

# Fetch source code for the visualization.
RUN git clone https://github.com/reallyTG/p5-promise-viz.git

# Fetch source code for analysis output processing.
RUN git clone https://github.com/reallyTG/ProfilingPromisesProcessing.git
WORKDIR /home/drasync/ProfilingPromisesProcessing
RUN npm i
WORKDIR /home/drasync

# Fetch source code for analysis.
RUN git clone https://github.com/reallyTG/ProfilingPromisesAnalysis.git

# Fetch code for anti-pattern detection queries.
RUN git clone https://github.com/reallyTG/ProfilingPromisesQueries.git

# The above results in the following hierarchy:
# /home
# --> /drasync
# ----> /p5-promise-viz
# ----> /ProfilingPromisesProcessing
# ----> /ProfilingPromisesAnalysis
# ----> /ProfilingPromisesQueries

# Now, create directory hierarchy for the evaluation.
# /home
# --> /evaluation
# ----> /case-studies
# ------> /<one-dir-for-each-project-in-evaluation>
# ----> /drasync-artifact-scripts
# ----> /query-results
# ----> /processed-query-results
# ----> /collected-anti-patterns
# ----> /collected-results
# ----> /QLDBs
# ----> /processed-results
# ----> /proj-stats
# ----> /performance-case-studies

# Set working directory above sources and tests.
WORKDIR /home

# Make the evaluation
COPY makeEvaluation.sh /home
RUN ./makeEvaluation.sh

# Make sure we're still home.
WORKDIR /home

# Expose port 8080 for the visualization.
# I don't think we need this if we run docker as it says to run it in the readme.
# EXPOSE 8080

# Misc. setup
RUN git config --global http.sslVerify "false"
RUN npm config set strict-ssl false

# Run the script to download and build CodeQL.
COPY setupCodeQL.sh /home
RUN ./setupCodeQL.sh
