#!/bin/bash
cd /catkin_ws
source /opt/ros/kinetic/setup.bash
source devel/setup.bash

## Install conda
wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh
bash Miniconda3-py38_4.12.0-Linux-x86_64.sh -b -p /catkin_ws/miniconda3
rm Miniconda3-py38_4.12.0-Linux-x86_64.sh
echo ". /catkin_ws/miniconda3/etc/profile.d/conda.sh" >> ~/.bashrc
echo "conda activate base" >> ~/.bashrc

source ~/.bashrc
/catkin_ws/miniconda3/bin/conda install -c conda-forge sdformat13-python -yq
/catkin_ws/miniconda3/bin/pip install sdformat-mjcf

## Make urdf and sdf from xacro
rosrun xacro xacro --inorder -o /generate/ginko.urdf /catkin_ws/src/ginko_description/gazebo/xacro/ginko.xacro
gz sdf -p /generate/ginko.urdf > /generate/ginko.sdf

# TODO: Generate mujoco's xml
sdf2mjcf /generate/ginko.sdf /generate/ginko.xml