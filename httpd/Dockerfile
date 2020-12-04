ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION


# Install LIGHTTPD
RUN \
   apk add lighttpd \
   php \
   php-cgi

RUN \
   addgroup pxe && \
   adduser pxe -G pxe -H -s /bin/false -D && \
   chown pxe:pxe /var/www/ && \
   chown pxe:pxe /var/log/lighttpd/

# Copy ISO and config files
COPY ./lighttpd/ /etc/lighttpd/


# Get the network access through the 80/tcp and 80/udp
EXPOSE 80/tcp
EXPOSE 80/udp

# Start LIGHTTPD as a service
ENTRYPOINT ["/usr/sbin/lighttpd"]
CMD ["-D", "-f", "/etc/lighttpd/lighttpd.conf"]
