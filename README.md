## Packaging for Aurora Scheduler

This repository maintains configuration and tooling for building binary
distributions of [Aurora Scheduler](https://aurora-scheduler.github.io/).

### Building a binary

Binaries are built within Docker containers that provide the appropriate build
environment for the target platform.  You will need to have a working Docker
installation before proceeding.


#### Building a binary from a tarball


1. Create a new directory called tarball:
     `git archive -o aurora-scheduler.tar.gz HEAD`

2. In a directory outside of the repository, create a directory called `tarball` and a directory called `dist`
    `mkdir tarball dist`

3. Copy the tarball into the tarball directory
      `cp aurora-scheduler.tar.gz /tmp/aurora-build/tarball`

4. Change directories to the parent directory of the `tarball` and `dist` directories and run the builder image
     `docker run -v $(pwd)/tarball:/tarball -v $(pwd)/dist:/dist aurorascheduler/packaging-scheduler:0.24.1 /build.sh`

When this completes, debs will be placed in the `dist` folder.


#### Building a released version

1. Follow steps 2 and 3 in the building a binary from a tarball section.

2. Run the builder image with the git tag of the release as an argument to the builder:
     `docker run -v $(pwd)/tarball:/tarball -v $(pwd)/dist:/dist aurorascheduler/packaging-scheduler:0.24.1 /build.sh <git tag>`

#### Building a new builder image

* For Ubuntu Xenial

From the root directory of this repo run:
`docker build . -t aurorascheduler/packaging-scheduler:<version> -f builder/deb/ubuntu-xenial/Dockerfile`

Where `<version` is the version being built.

#### Cut a branch for a specific version

The example below is for the 0.23.0 release where upstream is https://github.com/aurora-scheduler/packaging
    `git checkout -b 0.23.x upstream/master`