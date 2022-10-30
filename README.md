## Outline
This is docker demo scripts for [Ginko ROS](http://www.robo-one.com/rankings/view/1021).\
Ginko is one of the best hobby robot which is under 5kg and 50cm to join ROBO-ONE Auto.

![Ginko ROS](http://www.robo-one.com/upload/robots/1021_ec4b7f6388ebf85fe4a52b86987444c1original.png)

## How to use
If you have linux and installed Docker, you can run it by one-liner.\
``sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/realteck-ky/ginko_ros_docker/master/docker_run.sh)"``

### Linux
You can run demo scripts using following commands.

``` bash
git clone https://github.com/realteck-ky/ginko_ros_docker.git
cd ginko_ros_docker
sudo docker_run.sh
```

If you want to get sdf and urdf files, please enter following commands.

```bash
bash docker_gen_sdf.sh
```

Then, those files are generated to `ginko_ros_docker/generate`.

## Future work
### MacOSX
At MacOSX and docker toolbox, you don't have to add ``sudo``.

``` bash
git clone https://github.com/realteck-ky/ginko_ros_docker.git
cd ginko_ros_docker
docker_run.sh
```

XQuartz has an OpenGL problem in Xwindow over SSH.
When you execute it, you may get following messages.

```
libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast
```

Same errors are reported.

* https://github.com/jessfraz/dockerfiles/issues/253
* https://bbs.archlinux.org/viewtopic.php?id=244575

I searched solution for this problem, and a bug report recommend to downgrade to XQuartz version 2.7.8.\
https://bugs.freedesktop.org/show_bug.cgi?id=96433

### Windows
Not support yet
