FROM alpine:edge

### Environment Variables
ENV TINC_VERSION=1.1pre18

### Dependencies Installation       
RUN set -x && \
         echo 'http://dl-4.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
         apk update && \
         apk upgrade && \
         \
         apk add -t .tinc-build-deps \
                                                        autoconf \
                                                        automake \
                                                        build-base \
                                                        curl \
                                                        g++ \
                                                        gcc \
                                                        libc-utils \
                                                        libpcap-dev \
                                                        libressl \
                                                        linux-headers \
                                                        lzo-dev \
                                                        make \
                                                        ncurses-dev \
                                                        openssl-dev \
                                                        readline-dev \
                                                        tar \
                                                        texinfo \
                                                        zlib-dev \
                                                        && \
         \
         apk add -t .tinc-run-deps \
                                                        ca-certificates \
                                                        git \
                                                        iptables \
                                                        iptables-legacy \
                                                        libcrypto3 \
                                                        libpcap \
                                                        lzo \
                                                        openssl \
                                                        readline \
                                                        zlib && \
         \
         mkdir -p /usr/src/tinc && \
         curl -L https://github.com/gsliepen/tinc/archive/refs/tags/release-${TINC_VERSION}.tar.gz | tar xzvf - --strip 1 -C /usr/src/tinc && \
         cd /usr/src/tinc && \
         autoreconf -i && \
         ./configure --prefix=/usr --enable-jumbograms --enable-tunemu --sysconfdir=/etc --localstatedir=/var && \
         make && make install src && \
         apk del --no-cache --purge .tinc-build-deps && \
         mkdir /var/log/tinc && \
         rm -rf /usr/src/tinc && \
         rm -rf /var/cache/apk/* && \
         \
         rm -f /usr/sbin/iptables && \
         ln -s /usr/sbin/xtables-legacy-multi /usr/sbin/iptables

### Networking Configuration
EXPOSE 655/tcp 655/udp

CMD ["tinc", "start", "-D"]
