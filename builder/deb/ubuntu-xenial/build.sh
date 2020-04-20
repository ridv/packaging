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

mkdir /scratch
cd /scratch

git clone -b "$GIT_TAG" --single-branch --depth 1 https://github.com/aurora-scheduler/aurora.git /scratch

cp -R /specs/debian .

# Xenial tries to convert init and upstart scripts before using systemd units.
# Avoid conflict by not including them for now.
rm ./debian/*.upstart ./debian/*.init

# Remove executor and tools. Only build scheduler and docs.
rm ./debian/aurora-executor.* ./debian/aurora-pants* ./debian/aurora-tools.*

export DEBFULLNAME='Aurora Scheduler'
export DEBEMAIL='dev@aurora-scheduler.github.io'

dch \
  --newversion "$GIT_TAG" \
  --package aurora-scheduler \
  --urgency medium \
  "Aurora Scheduler package builder <dev@aurora-scheduer.github.io> $(date -R)"
dch --release ''

dpkg-buildpackage -uc -b -tc

mkdir /dist
mv ../*.deb /dist
