#!/bin/bash

mkdir -p /home/evaluation/case-studies
cd /home/evaluation
git clone https://github.com/reallyTG/drasync-artifact-scripts.git
mkdir /home/evaluation/query-results
mkdir /home/evaluation/processed-query-results
mkdir /home/evaluation/collected-anti-patterns
mkdir /home/evaluation/collected-anti-patterns/AsyncFunctionNoAwait
mkdir /home/evaluation/collected-anti-patterns/AwaitedReturnInAsyncFun
mkdir /home/evaluation/collected-anti-patterns/InHousePromisification
mkdir /home/evaluation/collected-anti-patterns/PromiseResolveThen
mkdir /home/evaluation/collected-anti-patterns/AwaitInLoop
mkdir /home/evaluation/collected-anti-patterns/ExplicitPromiseConstructor
mkdir /home/evaluation/collected-anti-patterns/PromiseConstructorSyncResolve
mkdir /home/evaluation/collected-anti-patterns/ReactionReturnsPromise
mkdir /home/evaluation/collected-results
mkdir /home/evaluation/QLDBs
mkdir /home/evaluation/processed-results
mkdir /home/evaluation/proj-stats

# Set up performance case studies.
mkdir /home/evaluation/performance-case-studies
cd /home/evaluation/performance-case-studies

# Grab the cpDir experiment
git clone https://github.com/reallyTG/AwaitInLoopPerformanceBenchmark.git
cd /home/evaluation/performance-case-studies/AwaitInLoopPerformanceBenchmark
npm i

cd /home/evaluation/performance-case-studies
git clone https://github.com/ProfilingPromisesBenchmarks/strapi.git
cd /home/evaluation/performance-case-studies/strapi
git checkout drasync-evaluate-experiment

cd /home/evaluation/performance-case-studies
git clone https://github.com/ProfilingPromisesBenchmarks/vuepress.git
cd /home/evaluation/performance-case-studies/vuepress
git checkout drasync-apply-experiment

# Clone all evaluation projects.
# Also, make sure they are on the `dr-async-artifact` branch.
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/appcenter-cli.git
cd /home/evaluation/case-studies/appcenter-cli
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/Boostnote.git
cd /home/evaluation/case-studies/Boostnote
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/browsertime.git
cd /home/evaluation/case-studies/browsertime
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/CodeceptJS.git
cd /home/evaluation/case-studies/CodeceptJS
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/dash.js.git
cd /home/evaluation/case-studies/dash.js
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/eleventy.git
cd /home/evaluation/case-studies/eleventy
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/erpjs.git
cd /home/evaluation/case-studies/erpjs
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/fastify.git
cd /home/evaluation/case-studies/fastify
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/flowcrypt-browser.git
cd /home/evaluation/case-studies/flowcrypt-browser
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/media-stream-library-js.git
cd /home/evaluation/case-studies/media-stream-library-js
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/mercurius.git
cd /home/evaluation/case-studies/mercurius
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/netlify-cms.git
cd /home/evaluation/case-studies/netlify-cms
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/openapi-typescript-codegen.git
cd /home/evaluation/case-studies/openapi-typescript-codegen
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/rmrk-tools.git
cd /home/evaluation/case-studies/rmrk-tools
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/stencil.git
cd /home/evaluation/case-studies/stencil
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/strapi.git
cd /home/evaluation/case-studies/strapi
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/treeherder.git
cd /home/evaluation/case-studies/treeherder
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/ui5-builder.git
cd /home/evaluation/case-studies/ui5-builder
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/vscode-js-debug.git
cd /home/evaluation/case-studies/vscode-js-debug
git checkout dr-async-artifact
cd /home/evaluation/case-studies

git clone https://github.com/ProfilingPromisesBenchmarks/vuepress.git
cd /home/evaluation/case-studies/vuepress
git checkout dr-async-artifact
cd /home/evaluation/case-studies
