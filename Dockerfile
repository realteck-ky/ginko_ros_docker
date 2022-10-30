FROM ros:kinetic

## Refer to https://answers.ros.org/question/259989/ubuntu-1604-xenial-package-for-gazebo-740/
## Add an apt list from OSRF
RUN apt update && apt install wget \
    && echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" \
        >/etc/apt/sources.list.d/gazebo-stable.list \
    && wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - \
    && apt update \
    && apt install -y \
        ros-kinetic-urdf \
        ros-kinetic-xacro \
        ros-kinetic-geometry2 \
        ros-kinetic-gazebo-ros-pkgs \
        ros-kinetic-diagnostics \
        ros-kinetic-random-numbers \
        ros-kinetic-gazebo-ros-control \
        ros-kinetic-ros-controllers \
        ros-kinetic-dynamic-robot-state-publisher \
        ros-kinetic-rqt \
        ros-kinetic-rqt-graph \
        ros-kinetic-rqt-common-plugins \
        libgazebo7-dev \
        python-pydot \
        openssh-server \
        libgl1-mesa-glx \
    && apt clean \
    && rm -rf /var/lib/apt/lists/

## Add "ginko_ros", "ginko_ros_pkgs" and some scripts
RUN  mkdir -p /catkin_ws/src
RUN  git clone --progress --verbose https://github.com/cogniteam/decision_making.git /catkin_ws/src/decision_making
COPY ./ginko_ros/ /catkin_ws/src/
COPY ./gazebo_ros_pkgs /catkin_ws/src/gazebo_ros_pkgs
COPY ./ginko_docker_demo /catkin_ws/src/ginko_docker_demo
COPY ./ginko_ros_run.sh /catkin_ws/ginko_ros_run.sh
COPY ./ginko_build_sdf.sh /catkin_ws/ginko_build_sdf.sh
RUN  chmod -R u+x /catkin_ws

## Build ginko_ros
RUN ["/bin/bash", "-c", \
        "cd /catkin_ws && rm -rf src/laser_assembler_client &&\
        source /opt/ros/kinetic/setup.bash &&\
        catkin_make -DCMAKE_BUILD_TYPE=Release -j1"]

## Set command to run docker demo launch
CMD ["/bin/bash", "-c", "/catkin_ws/ginko_ros_run.sh"]
