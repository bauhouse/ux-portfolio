#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5dd98759868ea7001ba27d7b/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5dd98759868ea7001ba27d7b
curl -s -X POST https://api.stackbit.com/project/5dd98759868ea7001ba27d7b/webhook/build/ssgbuild > /dev/null
gatsby build
wait

curl -s -X POST https://api.stackbit.com/project/5dd98759868ea7001ba27d7b/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"
