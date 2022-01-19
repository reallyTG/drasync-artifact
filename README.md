# NOTE

Update `git clone ...` in Dockerfile when submitting to reflect the exact commit to grab.

If you're building this locally, make sure to `chmod 777 setupCodeQL.sh` otherwise Docker can't run it.

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

**NOTE**: in case port 8080 is taken on your local machine, the anatomy of the command is `docker run -t -i -p <port on machine>:<port in docker> drasync`.
When running the visualization from inside docker, you should use `python3 -m http.server <port in docker>`, and you can then access the visualization at `localhost:<port on machine>`. 


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

# Kick-the-Tires, or How to Make Sure the Artifact is Up and Running

# Correspondence Between Paper and Artifact

This artifact contains all of the source code for our tool, clones of the projects we used in our evaluation at the specific commits we used to perform the evaluation, and all infrastructure required to run our evaluation.
We will first spell out explicit correspondence between relevant figures and snippets in the paper to their equivalents in the artifact, and then we will describe how to run our evaluation in full.

## Mapping the Paper to the Artifact


### Queries

The code corresponding to the anti-patterns described in Fig. 3 of the paper can be found in `/home/drasync/ProfilingPromisesQueries/`.
The files corresponding to each anti-pattern are:
```
findAsyncFunctionNoAwait.ql     ~ asyncFunctionNoAwait
findAwaitReturnInAsync.ql       ~ asyncFunctionAwaitedReturn
findAwaitInLoop.ql              ~ loopOverArrayWithAwait
findPromiseResolveThen.ql       ~ promiseResolveThen
findSyncResolve.ql              ~ executorOneArgUsed
findReactionReturningPromise.ql ~ reactionReturnsPromise
findInHousePromisification.ql   ~ customPromisification
findExplicitConstructor.ql      ~ explicitPromiseConstructor
```

### Interactive Visualization

The visualization can be run with the following command:

```
cd /home/drasync/p5-promise-vis
python3 -m http.server 8080
```

TODO: The vis needs to be more usable. Unclear how we get it to load a file ATM.

### Case Study

The various case snippets shown in the case study can be found at the following locations:



## Running the Evaluation

TODO

# More Instructions?

1. Build image.
2. Run image: `docker run -t -i -p 8080:8080 drasync`
3. Run the vis in the container: `cd /drasync/p5-promise-vis; python3 -m http.server 8080`
4. Access vis: navigate to localhost:8080 on your machine!

# TODO

- figure out, in docker run step, which port is on the local machine. Specify that users can map to that port.
  
- install CodeQL on the image.
  
- make sure stats query is where it needs to be.
  
- add directory structure to Dockerfile.
