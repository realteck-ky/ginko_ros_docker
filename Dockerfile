# syntax=docker/dockerfile:1
FROM ros:kinetic
SHELL ["/bin/bash", "-c"]

## Refer to https://answers.ros.org/question/259989/ubuntu-1604-xenial-package-for-gazebo-740/
## Add an apt list from OSRF
RUN apt update && apt install -y wget \
    && echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" \
        > /etc/apt/sources.list.d/gazebo-stable.list \
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
        libgl1-mesa-glx \
        openssh-server \
        python-pydot \
        python-yaml \
    && apt clean \
    && rm -rf /var/lib/apt/lists/

RUN mkdir -p /opt/miniconda3 \
    && wget --progress=bar:force:noscroll \
        https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
        -O /opt/miniconda3/miniconda.sh \
    && bash /opt/miniconda3/miniconda.sh -b -u -p /opt/miniconda3 \
    && rm -rf /opt/miniconda3/miniconda.sh \
    && /opt/miniconda3/bin/conda install -c conda-forge sdformat13-python -yq \
    && /opt/miniconda3/bin/pip install sdformat-mjcf --no-cache-dir \
    && /opt/miniconda3/bin/conda clean -ayq
#   && /opt/miniconda3/bin/conda init bash -q

## Add "ginko_ros", "ginko_ros_pkgs" and some scripts
RUN  mkdir -p          /catkin_ws/src
COPY ginko_ros         /catkin_ws/src/ginko_ros
COPY kuroko_ros        /catkin_ws/src/kuroko_ros
COPY gazebo_ros_pkgs   /catkin_ws/src/gazebo_ros_pkgs
COPY ginko_docker_demo /catkin_ws/src/ginko_docker_demo
COPY decision_making   /catkin_ws/src/decision_making
RUN  chmod -R u+x      /catkin_ws

## Build ginko_ros
RUN rm -rf /catkin_ws/src/ginko_ros/laser_assembler_client \
    && source /opt/ros/kinetic/setup.bash \
    && cd /catkin_ws && catkin_make -DCMAKE_BUILD_TYPE=Release -j$(nproc)

COPY ginko_ros_run.sh ginko_build_sdf.sh /catkin_ws/
RUN  chmod u+x /catkin_ws/*.sh

## Set command to run docker demo launch
WORKDIR /catkin_ws
CMD ["/bin/bash", "-c", "/catkin_ws/ginko_ros_run.sh"]
