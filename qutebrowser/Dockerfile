FROM archlinux/base:latest

COPY ./config/mirrorlist /etc/pacman.d/mirrorlist

RUN pacman -Syy && pacman -S --noconfirm qutebrowser

RUN pacman -Syy && pacman -S --noconfirm ttf-bitstream-vera \
    adobe-source-code-pro-fonts \
    adobe-source-han-sans-otc-fonts \
    ttf-dejavu

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENV MY_USERNAME=haoliang
RUN useradd -m -u 1000 -g users $MY_USERNAME

USER $MY_USERNAME
ENTRYPOINT ["docker-entrypoint.sh"]
