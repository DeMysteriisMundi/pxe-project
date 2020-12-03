ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION


# Install LIGHTTPD
RUN \
   apk add lighttpd

# Copy ISO and config files
COPY ./lighttpd/ /etc/lighttpd/


# Get the network access through the 80/tcp and 80/udp
EXPOSE 80/tcp
EXPOSE 80/udp

# Start LIGHTTPD as a service
ENTRYPOINT ["/usr/sbin/lighttpd"]
CMD ["-D", "-f", "/etc/lighttpd/lighttpd.conf"]
