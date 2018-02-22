FROM busybox:latest

ENV SS_TAR=https://github.com/shadowsocks/shadowsocks-go/releases/download/1.2.1/shadowsocks-server.tar.gz

RUN cd /tmp && wget $SS_TAR -O- | tar xzf - && mv shadowsocks-server /bin/

ENTRYPOINT ["shadowsocks-server"]
