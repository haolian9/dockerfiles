prerequisite
---

* xserver
* xhost
* docker

usage
---

* build/clean image
    * `make build/clean`

* player a file
    * `./mplayer.sh <file>`
        * mplayer.sh will use subtitle if subtitle has same filename with media file
            although it did not work yet.


todo
---

* subtitle, it is important

ref
---

* https://github.com/osrf/docker_images/issues/21
* https://github.com/hilbert/hilbert-docker-images/blob/devel/images/play/Makefile
* https://www.linuxquestions.org/questions/fedora-35/fc3-no-video-can%27t-open-x11-display-253005/
* https://github.com/moby/moby/issues/8710
* https://blog.jessfraz.com/post/docker-containers-on-the-desktop/
