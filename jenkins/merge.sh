#!/bin/bash -x
#
# This script merges master to all the branches
#
git branch -r | grep -v origin/HEAD | grep -v origin/develop | grep -v origin/master | grep Deni |
while read BRANCH ROL
do
  BRANCH=$(echo ${BRANCH} | sed -s 's,origin/,,')
  echo "##### ${BRANCH} #####"
  git checkout -b "${BRANCH}" || git checkout -f "${BRANCH}"
  git reset HEAD || true
  git pull origin "${BRANCH}"
  git rebase master
done
exit 0
