#!/bin/bash
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -ex

GIT_TAG=$1

mkdir -p /scratch
cd /scratch

git clone -b "$GIT_TAG" --single-branch --depth 1 https://github.com/aurora-scheduler/aurora.git /scratch

cp -R /specs/debian .

# Xenial tries to convert init and upstart scripts before using systemd units.
# Avoid conflict by not including them for now.
rm ./debian/*.upstart ./debian/*.init

DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs | tr '[:upper:]' '[:lower:]')
THIRD_PARTY_REPO="https://dl.bintray.com/aurora-scheduler/python-eggs/"
THIRD_PARTY_REPO+="${DISTRO}/${CODENAME}64/"

# Place the link to the correct python egg into aurora-pants.ini
echo "[python-repos]" >> ./debian/aurora-pants.ini
echo "repos: ['third_party/', '${THIRD_PARTY_REPO}']" >> ./debian/aurora-pants.ini

export DEBFULLNAME='Aurora Scheduler'
export DEBEMAIL='dev@aurora-scheduler.github.io'

dch \
  --newversion "$GIT_TAG" \
  --package aurora-scheduler \
  --urgency medium \
  "Aurora Scheduler package builder <dev@aurora-scheduler.github.io> $(date -R)"
dch --release ''

dpkg-buildpackage -uc -b -tc

mkdir /dist
mv ../*.deb /dist
