#!/bin/bash
mkdir -p generate
docker build -t ginko-build .
docker run -it --rm \
    --volume $PWD/generate:/generate \
    ginko-build \
    bash -c /catkin_ws/ginko_build_sdf.sh