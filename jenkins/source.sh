#!/bin/bash -e
#
# This script prepares the source for a branch
#
export TERM=xterm-256color
source "$HOME/.rvm/scripts/rvm"
rvm use ruby-1.9.2@docs

if [ -z "${1}" ]
then
  echo "Usage: ${0} <branch>"
  exit 1
fi

BRANCH="${1}"
echo "##### ${BRANCH} #####"
BRANCH=$(echo ${BRANCH} | sed -s 's,origin/,,')
if [ "${BRANCH}" == "HEAD" ]
then
  BRANCH="master"
fi
if [ "${BRANCH}" == "master" ]
then
  echo "No update for ${BRANCH}"
  exit 0
fi

SERVERS_DIR=$(pwd)/servers
mkdir -p ${SERVERS_DIR} 2>/dev/null || true

cd ${SERVERS_DIR}
DIR=${SERVERS_DIR}/$(echo ${BRANCH} | sed -e 's,/,_,g')
echo "###### ${DIR} docs.hpcloud.com repo ######"
if [ ! -d ${DIR} ]
then
  rm -rf docs.hpcloud.com
  git clone git@git.hpcloud.net:DevExDocs/docs.hpcloud.com.git
  mv docs.hpcloud.com "${DIR}"
  cd "${DIR}"
  git checkout master
  git pull origin master
  mkdir -p content
  cd content
  rm -rf documentation
  echo "###### ${DIR} documenation repo ######"
  git clone git@git.hpcloud.net:DevExDocs/documentation.git
  cd documentation
  git checkout "${BRANCH}"
  git pull origin "${BRANCH}"
else
  cd "${DIR}"
  git checkout master >/dev/null 2>/dev/null
  git pull origin master >/dev/null
  cd content/documentation
  echo "###### ${DIR} documenation repo ######"
  git checkout "${BRANCH}" >/dev/null 2>/dev/null
  git pull origin "${BRANCH}" >/dev/null
  cd "${DIR}"
  if [ ! -d content/apihome ]
  then
    cd content
    git clone git://git.hpcloud.net/DevExDocs/apihome.git
    cd apihome
    git checkout develop
    git pull origin develop
  else
    cd content/apihome
    git checkout develop
    git pull origin develop
  fi
fi
cd "${DIR}"
sed -i -e "s,Sign Up Now,${BRANCH}," _layouts/default.html
sed -i -e "s,Sign Up Now,${BRANCH}," _layouts/page.html
./jenkins/build.sh
git checkout _layouts/default.html
git checkout _layouts/page.html
touch "${DIR}/active"

exit 0
