FROM debian:latest
ARG DEBIAN_FRONTEND=noninteractive

# Fetch prerequisites.
RUN apt-get update \
	&& apt-get -y install --no-install-recommends git unzip vim curl nodejs npm parallel

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

# Create evaluation directory.
RUN mkdir /home/evaluation

# Clone all evaluation projects.
RUN git clone https://github.com/ProfilingPromisesBenchmarks/appcenter-cli.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/Boostnote.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/browsertime.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/CodeceptJS.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/dash.js.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/eleventy.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/erpjs.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/fastify.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/flowcrypt-browser.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/media-stream-library-js.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/mercurius.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/netlify-cms.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/openapi-typescript-codegen.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/rmrk-tools.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/stencil.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/strapi.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/treeherder.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/ui5-builder.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/vscode-js-debug.git
RUN git clone https://github.com/ProfilingPromisesBenchmarks/vuepress.git


# Set working directory above sources and tests.
WORKDIR /home

# Expose port 8080 for the visualization.
EXPOSE 8080

# Misc. setup
RUN git config --global http.sslVerify "false"
RUN npm config set strict-ssl false
