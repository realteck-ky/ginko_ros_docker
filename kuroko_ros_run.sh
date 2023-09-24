#!/bin/bash
set -ex

## Set enviroment variables
cd /catkin_ws
source /opt/ros/noetic/setup.bash
source devel/setup.bash

## Run a launch file
roslaunch kuroko_description roboone_large.launch
