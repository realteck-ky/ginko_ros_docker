#!/bin/bash
set -ex

cd /catkin_ws
source /opt/ros/kinetic/setup.bash
source devel/setup.bash

## Make urdf and sdf from xacro
rosrun xacro xacro --inorder -o /generate/ginko_rs406.urdf /catkin_ws/src/ginko_ros/ginko_description/xacro/ginko_rs406/ginko.xacro
gz sdf -p /generate/ginko_rs406.urdf > /generate/ginko_rs406.sdf

rosrun xacro xacro --inorder -o /generate/ginko_xm540.urdf /catkin_ws/src/ginko_ros/ginko_description/xacro/ginko_xm540/ginko.xacro
gz sdf -p /generate/ginko_xm540.urdf > /generate/ginko_xm540.sdf

rosrun xacro xacro --inorder -o /generate/kuroko.urdf /catkin_ws/src/kuroko_ros/kuroko_description/xacro/kuroko/kuroko.xacro
gz sdf -p /generate/kuroko.urdf > /generate/kuroko.sdf

# TODO: Generate mujoco's xml
export PATH=/opt/miniconda3/bin:$PATH
activate base
sdf2mjcf /generate/ginko_rs406.sdf /generate/ginko_rs406.xml
sdf2mjcf /generate/ginko_xm540.sdf /generate/ginko_xm540.xml
sdf2mjcf /generate/kuroko.sdf /generate/kuroko.xml