FROM ubuntu:18.04

RUN mkdir -p /var/run/dbus && \
  apt-get update && apt-get install -y \
  avahi-daemon \
  avahi-discover \
  avahi-utils \
  libnss-mdns \
  mdns-scan \
  curl
  # \
  # couchbase-server

#
# RUN curl -O https://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-amd64.deb
# RUN dpkg -i ./couchbase-release-1.0-amd64.deb
# install sync gateway (community edition)
# RUN wget http://packages.couchbase.com/releases/couchbase-sync-gateway/2.8.0/couchbase-sync-gateway-community_2.8.0_x86_64.deb
# RUN dpkg -i couchbase-sync-gateway-community_2.8.0_x86_64.deb
# RUN service sync_gateway start

EXPOSE 5353/udp
EXPOSE 8091/tcp

COPY services/couchbase.service services/couchbase.service
COPY scripts/couchbase-provision.sh couchbase-provision.sh
COPY scripts/service-browser.sh service-browser.sh

CMD ["./couchbase-provision.sh"]

# CMD ["./service-browser.sh"]
