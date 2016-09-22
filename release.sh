#!/usr/bin/env bash

set -x            # print each command before execution
set -o errexit    # always exit on error
set -o pipefail   # don't ignore exit codes when piping output
set -o nounset    # fail on unset variables

# set up the repo
npm run build
npm test

# bail if no changes are present
[[ `git status --porcelain` ]] || exit

git add electron-api.json
git add package.json

version=$(cat package.json | json version)

git commit -m "API docs for Electron $version"
npm version $version -m "API docs for Electron $version"
npm publish
git push origin master --follow-tags
