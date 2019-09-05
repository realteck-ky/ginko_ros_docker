## Outline
This is docker demo scripts for [Ginko ROS](http://www.robo-one.com/rankings/view/1021).\
Ginko is one of the best hobby robot which is under 5kg and 50cm to join ROBO-ONE Auto.

![Ginko ROS](http://www.robo-one.com/upload/robots/1021_ec4b7f6388ebf85fe4a52b86987444c1original.png)

## How to use
### Linux
You can run demo scripts using following commands.

``` sh
git clone https://github.com/realteck-ky/ginko_ros_docker.git
cd ginko_ros_docker
sudo docker_run.sh
```

## Future work
### MacOSX
XQuartz has an OpenGL problem in Xwindow over SSH.
When you try to execute, you could get following messages.

```
libGL error: No matching fbConfigs or visuals found
libGL error: failed to load driver: swrast
```
Same errors are reported there.
* https://github.com/jessfraz/dockerfiles/issues/253
* https://bbs.archlinux.org/viewtopic.php?id=244575

I searched solution for this problem, and a bug report recommend to downgrade to XQuartz version 2.7.8.\
https://bugs.freedesktop.org/show_bug.cgi?id=96433

### Windows
Not support yet