#!/bin/bash

set -e

ORG=metwork-framework
if test "${3:-}" = ""; then
    echo "_force.sh REPO-NAME BRANCH INTEGRATION_LEVEL"
    exit 1
fi

if ! test -d ~/tmp/resources; then
    echo "${HOME}/tmp/resources does not exist"
    exit 1
fi

REPONAME=$1
BRANCH=$2
INTEGRATION_LEVEL=$3
if test "${MFSERV_CURRENT_PLUGIN_NAME:-}" = ""; then
    echo "ERROR: load the plugin environnement before"
    exit 1
fi

cat >~/tmp/force.yaml <<EOF
default_context:
    repo: "${REPONAME}"
    integration_level: "${INTEGRATION_LEVEL}"
EOF

TMPREPO=${TMPDIR:-/tmp}/force_$$

rm -Rf "${TMPREPO}"
mkdir -p "${TMPREPO}"
cd "${TMPREPO}"
git clone "git@github.com:${ORG}/${REPONAME}"

cd "${REPONAME}"
git checkout -b common_files_force --track "origin/${BRANCH}"
REPO_TOPICS=$(metwork_topics.py --json "${ORG}" "${REPONAME}")
export REPO_TOPICS
export REPO_HOME="${TMPREPO}/${REPONAME}"
cookiecutter --no-input --config-file ~/tmp/force.yaml ~/tmp/resources/cookiecutter
shopt -s dotglob
mv _${REPONAME}/* .
shopt -u dotglob
rm -Rf "_${REPONAME}"
git add --all
N=$(git diff --cached |wc -l)
if test "${N}" -gt 0; then
    git commit -m "chore: sync common files from resources repository"
    git-pull-request --title="chore: sync common files from resources repository" --message="sync common files from resources repository" --target-remote=origin
fi

rm -Rf "${TMPREPO}"
echo "DONE"
