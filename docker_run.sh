#!/bin/bash

set -eu
which socat
which docker

## If you want to build at local, you can run 
## "docker build -t ginko_ros_docker ."

## https://qiita.com/UmedaTakefumi/items/fe02d17264de6c78443d
OS="default"
if [ "$(uname)" == "Darwin" ]; then
  OS="MacOS"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  OS="Linux"
fi

## https://stackoverflow.com/questions/42438619/run-chromium-inside-container-libgl-error
case $OS in
  "Linux")
    ## https://wiki.ros.org/docker/Tutorials/GUI
    xhost +local:root
    sudo docker run --rm -it --net host --device=/dev/dri:/dev/dri \
      -e QT_X11_NO_MITSHM=1 -e GAZEBO_IP=127.0.0.1 -e DISPLAY=$DISPLAY \
      realteckky/ginko_ros_docker
    xhost -local:root;;
  "MacOS")
    IP=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
    #defaults write org.macosforge.xquartz.X11 enable_iglx -bool true
    socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
    docker run --rm -it --net host -v $HOME/.Xauthority:/root/.Xauthority \
      -e QT_X11_NO_MITSHM=1 -e GAZEBO_IP=127.0.0.1 -e DISPLAY=$IP:0 \
      --device=/dev/tty0 --group-add=video \
      realteckky/ginko_ros_docker ;;
  "default")
    docker run --rm -it --net host \
      -e QT_X11_NO_MITSHM=1 -e GAZEBO_IP=127.0.0.1 -e DISPLAY=$DISPLAY \
      realteckky/ginko_ros_docker ;;
esac

