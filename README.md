# NOTE

Update `git clone ...` in Dockerfile when submitting to reflect the exact commit to grab.

# drasync-artifact

Artifact for DrAsync, a tool to detect and visualize anti-patterns related to programming with JavaScript's async features.

# Building the Image Locally

```
git clone <this repo>
cd drasync-artifact
docker build -t drasync .
```

# Running the Image

The following command will launch the DrAsync Docker container, and give you a bash CLI.

```
docker run -t -i -p 8080:8080 drasync
```

# Artifact Directory Structure

```
/home
--> /drasync
----> /ProfilingPromisesAnalysis
----> /ProfilingPromisesProcessing
----> /ProfilingPromisesQueries
----> /p5-promise-vis
--> /evaluation
----> /drasync-artifact-scripts
----> /case-studies
------> /<one-dir-for-each-project-in-evaluation>
----> /query-results
----> /processed-query-results
----> /collected-anti-patterns
----> /collected-results
----> /QLDBs
----> /processed-results
----> /proj-stats
```

# Instructions

1. Build image.
2. Run image: `docker run -t -i -p 8080:8080 drasync`
3. Run the vis in the container: `ls /drasync/p5-promise-vis; python3 -m http.server 8080`
4. Access vis: navigate to localhost:8080 on your machine!

# TODO

- figure out, in docker run step, which port is on the local machine. Specify that users can map to that port.
  
- install CodeQL on the image.
  
- make sure stats query is where it needs to be.
  
- add directory structure to Dockerfile.
