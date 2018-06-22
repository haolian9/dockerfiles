FROM haoliang/archlinux:latest

USER root

RUN pacman -Syy && pacman -S --noconfirm qutebrowser

# todo more font
RUN pacman -Syy && pacman -S --noconfirm ttf-bitstream-vera \
    adobe-source-code-pro-fonts \
    adobe-source-han-sans-otc-fonts \
    ttf-dejavu

COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

USER 1000
ENTRYPOINT ["docker-entrypoint.sh"]
