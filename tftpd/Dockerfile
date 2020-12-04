ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION


# Install TFTPD
RUN \
   apk add tftp-hpa

RUN \
   addgroup pxe && \
   adduser pxe -G pxe -H -s /bin/false -D && \
   chown pxe:pxe /var/tftpboot/

WORKDIR /var/tftpboot/


# Get the network access through the 69/udp
EXPOSE 69/udp


# Start TFTPD as a service
ENTRYPOINT ["/usr/sbin/in.tftpd"]
CMD ["-L", "-s", "/var/tftpboot/"]

