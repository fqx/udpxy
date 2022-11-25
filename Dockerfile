# Alpine v3
FROM alpine:latest as builder
LABEL maintainer "fqx"

# Instalacion dependencias
RUN apk update && apk add make gcc libc-dev

# Compila UDPXY
WORKDIR /tmp
RUN wget -O udpxy-src.tar.gz https://codeload.github.com/haisongliang/udpxy/tar.gz/refs/tags/1.0-25.1 \
    && tar zxf udpxy-src.tar.gz \
    && cd udpxy-* && cd chipmunk && make && make install

# Alpine v3
FROM alpine:latest
LABEL maintainer "Lordpedal"

# Arranque Docker
COPY --from=builder /usr/local/bin/udpxy /usr/local/bin/udpxy
COPY --from=builder /usr/local/bin/udpxrec /usr/local/bin/udpxrec

ENTRYPOINT ["/usr/local/bin/udpxy"]
CMD ["-v", "-M", "55", "-T", "-p", "2112"]
