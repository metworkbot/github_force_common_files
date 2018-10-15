#!/bin/bash

ORG=metwork-framework

echo "Cloning resources repository..."
rm -Rf ~/tmp/resources
cd ~/tmp
git clone "git@github.com:${ORG}/resources"

for I in 1 2 3 4 5; do
  echo "**********************************"
  echo "***** INTEGRATION LEVEL ${I} *****"
  echo "**********************************"
  echo
  REPOS=$(metwork_repos.py --minimal-level ${I} --exact-level)
  for REPO in ${REPOS}; do
      echo "=> Working on repo: ${REPO}..."
      if test $I -ge 4; then
        _force.sh "${REPO}" integration "${I}"
      else
        _force.sh "${REPO}" master "${I}"
      fi
  done
done

rm -Rf ~/tmp/resources
