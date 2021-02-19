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

FILE=/tarball/aurora-scheduler.tar.gz

if [ -f "$FILE" ]; then
  tar -C /scratch  -xf "$FILE"
else
  git clone -b "$GIT_TAG" --single-branch --depth 1 https://github.com/aurora-scheduler/aurora.git /scratch
fi

cp -R /specs/debian .

# Xenial tries to convert init and upstart scripts before using systemd units.
# Avoid conflict by not including them for now.
rm ./debian/*.upstart ./debian/*.init

export DEBFULLNAME='Aurora Scheduler'
export DEBEMAIL='dev@aurora-scheduler.github.io'

VERSION=$(</scratch/.auroraversion)

dch \
  --newversion "$VERSION" \
  --package aurora-scheduler \
  --urgency medium \
  "Aurora Scheduler package builder <dev@aurora-scheduler.github.io> $(date -R)"
dch --release ''

dpkg-buildpackage -uc -b -tc

mkdir -p /dist
mv ../*.deb /dist
