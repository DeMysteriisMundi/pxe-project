ARG ALPINE_VERSION=latest
FROM alpine:$ALPINE_VERSION


# Install DHCPD
RUN \
   apk add dhcp

# Copy default config
COPY ./dhcp/ /etc/dhcp/

# Symlink config and create lease database 
RUN \
   ln -sf /etc/dhcp/dhcpd.conf /etc/dhcpd.conf && \
   touch /var/lib/dhcp/dhcpd.leases


# Start DHCPD as a service
ENTRYPOINT ["/usr/sbin/dhcpd"]
CMD ["-d", "--no-pid", "-4", "-f"]

