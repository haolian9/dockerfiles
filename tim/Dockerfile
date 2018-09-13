# see https://www.lulinux.com/archives/1319

FROM archlinux/base:latest

COPY pacman.conf.patch /tmp/

RUN cat /tmp/pacman.conf.patch >> /etc/pacman.conf

RUN pacman -Syy --noconfirm && pacman -S --noconfirm deepin.com.qq.office \
python2 grep awk procps-ng
