# NOTE

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
--> /codeql-home
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

### Code Locations of Code Snippets in Paper

Below, find the real code locations in the artifact corresponding to code snippets highlighted in the paper.
This subsection is organized according to sections in the paper.
Run the `vim` command in Docker to open the file in an editor at the given line.

#### Motivating Examples

- [lines 279-286] ~ `vim +189 /home/evaluation/case-studies/ui5-builder/lib/lbt/resources/ResourcePool.js`
- [lines 333-339] ~ `vim +83 /home/evaluation/case-studies/appcenter-cli/src/util/misc/promisfied-fs.ts`

#### Case Study

The various case snippets shown in the case study can be found at the following locations:

- [lines 672-678] ~ `vim /home/evaluation/case-studies/openapi-typescript-codegen/src/utils/readSpec.ts`
- [lines 690-692] ~ `vim +159 /home/evaluation/case-studies/eleventy/src/TemplateLayout.js`
- [lines 729-733] ~ `vim +39 /home/evaluation/case-studies/dash.js/src/streaming/utils/CapabilitiesFilter.js`
- [lines 739-742] ~ `vim +467 /home/evaluation/case-studies/eleventy/src/Engines/Nunjucks.js`
- [lines 804-808] ~ `vim +428 /home/evaluation/case-studies/netlify-cms/packages/netlify-cms-core/src/backend.ts`

#### RQ3 Code Snippets

- [lines 892-894] ~ `vim +37 /home/evaluation/case-studies/vuepress/packages/@vuepress/core/lib/node/plugin-api/override/EnhanceAppFilesOption.js`
- [lines 903-908] ~ `vim +198 /home/evaluation/case-studies/strapi/packages/strapi-admin/services/permission/engine.js `

## Running the Evaluation

In this section, we will describe how to run the different components for the evaluation.

Some notes:

1. You are expected to run all scripts from `/home/evaluation/drasync-artifact-scripts`. While not strictly necessary, this is how the scripts were tested.

### Running CodeQL Queries

The paper describes anti-patterns, and we proposed static analyses capable of detecting them.
More specifically, we proposed various CodeQL static analysis queries that can be run over a code repository to flag anti-pattern instances.
In order to run these queries, **CodeQL must first build a _database_ of the project under analysis**.
The docker container is equipped with a script to achieve this.

To run the database build script (there will be a lot of terminal output during this step):
```
cd /home/evaluation/drasync-artifact-scripts
./make-database.sh Boostnote
```

The database is created in `/home/evaluation/QLDBs` (e.g., in this case, `ls /home/evaluation/QLDBs/Boostnote` contains the CodeQL database).
Once created, queries can be run over the database.

To run a query, use this script (the terminal will be pretty quiet executing this script):
```
cd /home/evaluation/drasync-artifact-scripts
./run-query.sh Boostnote 
```

The results are always stored in `/home/evaluation/query-results/<query-name>/<project-name>` (e.g., in this case, `cat /home/evaluation/query-results/findAsyncFunctionNoAwait/Boostnote.csv` will show you the query results).

For this particular combination of query and project, the results of running the aforementioned `cat` command should be:

```
"col0"
"pattern10 492 14 494 7 /home/evaluation/case-studies/Boostnote/lib/main-menu.js"
```

You can ignore the `"col0"` header; the following line can be read as: "pattern10 (aka, the _asyncFunctionNoAwait_ pattern) occurs from lines 492 to 494 and columns 14 to 7 resp. in file `/home/evaluation/case-studies/Boostnote/lib/main-menu.js`.
To view the pattern in the terminal, run `vim +492 /home/evaluation/case-studies/Boostnote/lib/main-menu.js`.

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
