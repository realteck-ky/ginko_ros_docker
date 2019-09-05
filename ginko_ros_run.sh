#!/bin/bash

## Set enviroment variables
cd /catkin_ws
source /opt/ros/kinetic/setup.bash
source devel/setup.bash

## Run a Ginko demonstration launch and enter bash
roslaunch ginko_docker_demo ginko_demo.launch
#/bin/bash
