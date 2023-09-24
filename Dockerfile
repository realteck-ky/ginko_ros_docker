# syntax=docker/dockerfile:1
FROM ros:noetic
SHELL ["/bin/bash", "-c"]

## Refer to https://answers.ros.org/question/259989/ubuntu-1604-xenial-package-for-gazebo-740/
## Add an apt list from OSRF
RUN apt update && apt install -y wget git \
    && echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" \
        > /etc/apt/sources.list.d/gazebo-stable.list \
    && wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - \
    && apt update \
    && apt install -y \
        python3-catkin-tools python3-vcstool \
    && apt clean \
    && rm -rf /var/lib/apt/lists/

## Add "kuroko_ros" and some scripts
COPY kuroko_ros /catkin_ws/src/kuroko_ros
COPY gazebo_dc_motor /catkin_ws/src/gazebo_dc_motor
RUN ls /catkin_ws/src && chmod -R u+x /catkin_ws && cd /catkin_ws && catkin init

## Build ginko_ros
WORKDIR /catkin_ws
RUN apt update \
    && rosdep update \
    && rosdep install --from-paths . --ignore-src -r -y \
    && apt clean \
    && rm -rf /var/lib/apt/lists/
RUN source /opt/ros/noetic/setup.bash && catkin build

COPY *.sh /catkin_ws/
RUN chmod u+x /catkin_ws/*.sh

## Set command to run docker demo launch
CMD ["/bin/bash", "-c", "/catkin_ws/kuroko_ros_run.sh"]
