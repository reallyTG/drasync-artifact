# NOTE

If you're building this locally, make sure to `chmod +x setupCodeQL.sh makeEvaluation.sh` otherwise Docker can't run it.

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
----> /performance-case-studies
--> /codeql-home
```

# Artifact Description and Example Commands

This artifact contains all of the source code for our tool, clones of the projects we used in our evaluation at the specific commits we used to perform the evaluation, and all infrastructure required to run our evaluation.
Running the full evaluation is not recommended, as we ran it on a hefty server and it will comfortably fit on a consumer-grade computer.
Instead, we hope that this description of each of the features of the artifact is satisfactory.
Performing the steps outlined below should yield similar results to those reported in the paper (modulo non-determinism in test suites).

Running the interactive visualization is described separately, after all other steps.

## Mapping the Paper to the Artifact

### Queries

The code corresponding to the anti-patterns described in Fig. 3 of the paper can be found in `/home/drasync/ProfilingPromisesQueries/`.
The files corresponding to each anti-pattern are:
```
<query-name>.ql                 ~ anti-pattern from paper
findAsyncFunctionNoAwait.ql     ~ asyncFunctionNoAwait
findAwaitReturnInAsync.ql       ~ asyncFunctionAwaitedReturn
findAwaitInLoop.ql              ~ loopOverArrayWithAwait
findPromiseResolveThen.ql       ~ promiseResolveThen
findSyncResolve.ql              ~ executorOneArgUsed
findReactionReturningPromise.ql ~ reactionReturnsPromise
findInHousePromisification.ql   ~ customPromisification
findExplicitConstructor.ql      ~ explicitPromiseConstructor
```

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
First, we begin by describing how to run our tool on a particular project.
Later, we describe how the entire evaluation can be reproduced by calling a few scripts. 

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
./run-query.sh Boostnote <query-name-from-above>
```

(Run `./run-all-queries-for-proj.sh Boostnote` to run all available queries for a project. This may take a few minutes.)

The results are always stored in `/home/evaluation/query-results/<query-name>/<project-name>` (e.g., in this case, `cat /home/evaluation/query-results/findAsyncFunctionNoAwait/Boostnote.csv` will show you the query results).

For this particular combination of query and project, the results of running the aforementioned `cat` command should be:

```
"col0"
"asyncFunctionNoAwait 492 14 494 7 /home/evaluation/case-studies/Boostnote/lib/main-menu.js"
```

You can ignore the `"col0"` header; the following line can be read as: the _asyncFunctionNoAwait_ pattern occurs from lines 492 to 494 and columns 14 to 7 resp. in file `/home/evaluation/case-studies/Boostnote/lib/main-menu.js`.
To view the pattern in the terminal, run `vim +492 /home/evaluation/case-studies/Boostnote/lib/main-menu.js`.

### Processing Query Results

Once the queries are done running, the results must be processed.
The script to achieve this can be run by:

```
cd /home/evaluation/drasync-artifact-scripts
./consolidate-query-results.sh Boostnote
```

(The first time you run this for any project, there will be an error in the terminal "rm: cannot remove ..."---this is fine).
(Note: if you ran `run-all-queries-for-proj.sh`, it automatically consolidates the query results.)
You can see the processed results with `cat /home/evaluation/processed-query-results/Boostnote.csv`, the file simply contains the output of running each of the queries that were run.

### Running the Dynamic Analysis

An important part of our tool is a dynamic analysis that tracks the lifetimes of promsise objects, written using the [`async_hooks` API](https://nodejs.org/api/async_hooks.html). 

To run the analysis, the `asyncHooks_require.js` file needs to be required by the code wanting to be analyzed. 
This can be achieved by `require('./asyncHooks_require.js')` at the top of a JS file (after having moved the analysis over to the directory!), or by invoking node with `--require /home/drasync/ProfilingPromisesAnalysis/asyncHooks_require.js`. 
For simplicity, we configured the test runners for each of the projects to require our analysis using a variety of configuration options, usually in the `package.json` of the projects.
For this reason, we ask that you use the `dr-async-artifact` branch of the repos (the repositories in the Docker image should be on the correct branch, but take note nonetheless). 

To run the test suites of each of the projects, simply run the following commands, after installing and building the project:

- appcenter-cli: test: `npm run test`
- Boostnote: (build: `yarn install`) test: `npm run test`
- browsertime: test: `npm run test:unit`
- CodeceptJS: test: `npm run test`
- dash.js: test: `npm run test`
- eleventy: (build: `npm i`) test: `npm run test`
- erpjs: test: `npm run test`
- fastify: test: `npm run unit`
- flowcrypt-browser: test: `npm run test_buf`, `npm run test_async_stack`, `npm run test_patterns`
- media-stream-library-js: test: `npm run test`
- mercurius: test: `npm run unit`
- netlify-cms: test: `npm run test:unit`
- openapi-typescript-codegen: test: `npm run test`
- rmrk-tools: test: `npm run test`
- stencil: test: `npm run test`
- strapi: (build: `yarn install`) test: `npm run test:unit`
- treeherder: test: `npm run test`
- ui5-builder: test: `npm run unit`
- vscode-js-debug: test: `npm run test:unit`
- vuepress: (build: `yarn install`, `yarn build`) test: `yarn test`

If build instructions are not listed, probably either `npm i` or `yarn install` will work.
If the package.json includes a reference to a build command, run that too.
Some packages have (very few) failing tests, and that's OK. (E.g., Boostnote has one failing test.)

The result of running the test suites is a **set of results-XYZ.json** files, which are collections of promise objects seen; each corresponds to an independent invocation of `node`, and many files simply means that many separate node instances were invoked, e.g., if the test suite is parallelized.

As an example, to run the Boostnote test suite:

```
cd /home/evaluation/case-studies/Boostnote
(if you haven't installed the project yet:)
yarn install
npm run test
```

This should yield multiple results-XYZ.json files (you can `ls` in `/home/evaluation/case-studies/Boostnote` to see them).
Note that Boostnote has one failing test.

### Processing Dynamic Analysis Results

Once the results-XYZ.json files have been generated, they must be processed together with the _processed query results_, so make sure you have run that step first.
The command to process the results of the dynamic analysis is, e.g., for Boostnote:

```
cd /home/evaluation/drasync-artifact-scripts
./process-results-incl-tally.sh Boostnote
```

You will see an rm-related error the first time you run this; this is fine.
There should be terminal output (many "Processing: /path/to/file"), followed by a quiet bit where dynamic invocations of anti-patterns are tallied (which has no terminal output).
New files, ending in `.dynInv`, are generated inside the project directory, containing records of dynamic invocations of the anti-patterns.
The anti-patterns are listed as 'patternX', an internal format recognized by our tool (we did not use verbose names here).

### Counting Occurrences (part of reproducing Table 3)

For some project (e.g., Boostnote), to count all static occurrences of anti-patterns, i.e., all occurrences of anti-patterns in source code, run:

```
cd /home/evaluation/drasync-artifact-scripts
./count-all-static-occurrences-for-proj.sh Boostnote
```

Before counting dynamic occurrences, some files need to be combined and moved around, and before that each anti-pattern should be tallied from the processed results.
This is achieved by executing:

```
cd /home/evaluation/drasync-artifact-scripts
./consolidate-dyn-inv-for-proj.sh Boostnote
./mv-all-antipattern-tallies-for-proj.sh Boostnote
```

Finally, to count dynamic occurrences, i.e., how many runtime promises were genererated by anti-pattern code, please run:

```
cd /home/evaluation/drasync-artifact-scripts
./count-all-dynamic-occurrences-for-proj.sh Boostnote
```

You may not see the exact same numbers as the paper, but things should be reasonably close.
When preparing the artifact, we obtained this output:

```
cd /home/evaluation/drasync-artifact-scripts
./count-all-dynamic-occurrences-for-proj.sh Boostnote
Boostnote AsyncFunctionNoAwait 0 
Boostnote AwaitInLoop 0 
Boostnote AwaitedReturnInAsyncFun 0 
Boostnote ExplicitPromiseConstructor 7 14
Boostnote InHousePromisification 11 18
Boostnote PromiseResolveThen 2 7
Boostnote ReactionReturnsPromise 0 
Boostnote PromiseConstructorSyncResolve 4 4
```

You may not get the exact same output, due to some nondeterminism in the test suite.
E.g., line `Boostnote ExplicitPromiseConstructor 7 14` reads: in Boostnote, 7 static instances of the ExplicitPromiseConstructor anti-pattern had dynamic promises originating from them, and there were a total of 14 runtime promises associated with the anti-pattern.
I.e., 7 code locations contributed 14 runtime promises.

### Observing the Performance Benefits of Selected Refatorings

This is aimed at reproducing our case study for RQ3.

#### appcenter-cli/cpDir

In this experiment, we show one instance of refactoring the await-in-a-loop(-over-an-array) anti-pattern to a loop that collects promises and ends on a Promise.all; this refactoring improves performance.
In the paper, we preformed the experiment on a very large directory (in terms of GB), and here we will instead minimize the experiment so that it is more manageable.
To perform this experiment, simply do the following:

```
cd /home/evaluation/performance-case-studies/AwaitInLoopPerformanceBenchmark
./setupExperiment.sh (this populates the tstCpDir directory with 50 empty files to copy)
./runExperiment-awaitInLoop.sh
./runExperiment-refactored.sh
```

The experiment scripts run 50 times, with a 2s sleep between runs. 
We took an average over the 50 runs to report in the paper, along with the standard deviation.

#### vuepress/apply

In this experiment, we conduct a focused experiment to determine the performance benefit of a refactoring in vuepress' apply method.
To conduct this experiment, we ran the test suite of vuepress 50 times before and after the refactoring, and collected performance numbers. 
The version of vuepress in `/home/evaluation/performance-case-studies/vuepress` should already be on our `drasync-apply-experiment` branch, which has convenience scripts to run the experiments. 

First, setup the project:

```
cd /home/evaluation/performance-case-studies/vuepress
yarn install
yarn build
```

This branch has the refactored version of the file available by default.
This, to run the experiment:

```
./run_experiment_after.sh
```

You should see some test output, and the timings are redirected to `vuepress_apply_after.log`.
To get the times, run `ag 'loop in apply' vuepress_apply_after.log` (we did this and moved the timings to a spreadsheet to average + compute standard deviation).

Then, swap to the original version, and run the tests again:

```
./swapToOrig.sh
./run_experiment_before.sh
```

(Note: if you get a permission error running `swapToOrig.sh` or `swapToRefactor.sh`, simply run `chmod +x <either-one-of-them>`.)

Times can be seen via `ag 'loop in apply' vuepress_apply_before.log`.

#### strapi/evaluate

The process is similar to the above.
First, build the project:

```
cd /home/evaluation/performance-case-studies/strapi
yarn install
```

(This installation takes a while.)

As with the previous example, the branch of strapi in this directory is our experiment branch.
The code snippet in question has already been refactored, and the profiling calls have been inserted, so you should only have to run the test suite to see timing information.
For convenience, please used the experiment runner script as before:

```
./run_experiment_after.sh
```

Feel free to Ctrl-C and kill the experiment early (it is configured to run 50 times), every full test execution should call the refactored code a few times. 
The times will be available in `strapi_after.log`, i.e., run `ag 'chained call time' strapi_after.log`.

To change to the original code, comment line 206 and uncomment lines 201-205 in `file`.
For convenience, run this in docker (JavaScript supports block comments with `/* this is a (multiline, if you want) comment */`, and single-line comments with `// this is a comment`):

```
vim +200 packages/strapi-admin/services/permission/engine.js
```

Then, run the experiment for the original code (hence, 'before', as in 'before refactoring') with:

```
./run_experiment_before.sh
```

As before, times can be obtained with `ag 'chained call time' strapi_before.log`.

#### Full Test Suite Refactorings

We refactored all anti-pattern instances in two projects (eleventy and vuepress) and timed their test suites.
In either case, the process for running this experiment is the same, and an example with eleventy is given:

```
cd /home/evaluation/case-studies/eleventy
git checkout drasync-all-refactor
./run_experiment.sh
```

This should yield test suite run times on the command line.
To run the experiment with no refactorings:

```
git checkout dr-async-no-refactor
./run_experiment.sh
```

No meaningful differences in test suite execution times are expected.

## Running the Visualization

This artifact also contains a visualization tool for depicting the results of our asynchronous profiling.
The visualization displays the results of the `processed-results-XXXXXXXXXXXXX.json` files; for the purpose of the docker image, we ask that you copy and rename the result file you are interested in visualizing with a command like the following:

```
cp /home/evaluation/case-studies/Boostnote/processed-results-XXXXXXXXXXXXX.json /home/drasync/p5-promise-viz/processed-result-to-visualize.json
```

Then, you can run the vis in the container with `cd /drasync/p5-promise-vis; python3 -m http.server 8080`.
You should be able to navigate to `localhost:8080` in your browser of choice (on your own local machine) to view the vis!
(Note: of course, that is unless you had to specify different ports earlier when running the docker image.)

 
