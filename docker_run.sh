#!/bin/bash

which socat
which docker

set -e

if [ "$1" == "--self-build" ]; then
  echo "Build in local"
  CONTAINER="ginko_ros_docker"
  docker build -t $CONTAINER .
else
  echo "Get from DockerHub"
  CONTAINER="realteckky/ginko_ros_docker"
fi

## If you want to build at local, you can run 
## "docker build -t ginko_ros_docker ."

## https://qiita.com/UmedaTakefumi/items/fe02d17264de6c78443d
OS="default"
if [ "$(uname)" == "Darwin" ]; then
  OS="MacOS"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  OS="Linux"
fi
echo "OS is $OS"

## https://stackoverflow.com/questions/42438619/run-chromium-inside-container-libgl-error
case $OS in
  "Linux")
    CLIENT_IP=`hostname -I | cut -d' ' -f1`
    ## https://wiki.ros.org/docker/Tutorials/GUI
    if [ "$SSH_CLIENT" != "" ]; then
      echo "Detect value SSH_CLIENT=$SSH_CLIENT"
      CLIENT_IP=`echo $SSH_CLIENT | awk '{ print $1}'`
      export DISPLAY="$CLIENT_IP:0.0"
      export LIBGL_ALWAYS_INDIRECT=1
      export QT_X11_NO_MITSHM=1
    fi
    docker run --rm -it \
      --publish 6000:6000 \
      --env QT_X11_NO_MITSHM=1 \
      --env DISPLAY=$DISPLAY \
      --device=/dev/dri \
      --group-add video \
      --volume /tmp/.X11-unix:/tmp/.X11-unix \
      $CONTAINER
    ;;
  "MacOS")
    IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
    #defaults write org.macosforge.xquartz.X11 enable_iglx -bool true
    socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
    docker run --rm -it --net host -v $HOME/.Xauthority:/root/.Xauthority \
      -e GAZEBO_IP=127.0.0.1 -e DISPLAY=$IP:0 \
      --device=/dev/tty0 --group-add=video \
      $CONTAINER
    ;;
  "default")
    docker run --rm -it --net host \
      -e QT_X11_NO_MITSHM=1 -e GAZEBO_IP=127.0.0.1 -e DISPLAY=$DISPLAY \
      $CONTAINER
    ;;
esac

