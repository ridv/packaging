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
FROM ubuntu:xenial

WORKDIR /aurora
ENV HOME /aurora
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

RUN apt-get update && \
  apt-get -y install software-properties-common && \
  add-apt-repository ppa:deadsnakes/ppa

# Using gcc-4.8 to ensure ABI for thermos in containers running older distros
RUN apt-get update && apt-get -y install \
  bison \
  debhelper \
  devscripts \
  dh-systemd \
  dpkg-dev \
  curl \
  git \
  gcc-4.8 \
  libapr1-dev \
  libcurl4-openssl-dev \
  libssl-dev \
  libsvn-dev \
  libffi-dev \
  python3.8-dev \
  python3.8-distutils \
  software-properties-common \
  libkrb5-dev

RUN apt-get -y install openjdk-8-jdk \
  && update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# Install gradle.
RUN git clone --depth 1 https://github.com/aurora-scheduler/gradle-packaging \
  && cd gradle-packaging \
  && apt-get -y install ruby ruby-dev unzip wget \
  && gem install fpm && ./gradle-mkdeb.sh 5.6.4 \
  && apt-get -y install gdebi-core \
  && gdebi --non-interactive gradle-5.6.4_5.6.4-2_all.deb \
  && cd .. && rm -rf gradle-packaging

COPY specs/debian /specs/debian

ADD builder/deb/ubuntu-xenial/build.sh /build.sh
