#!/usr/bin/env bash

echo "restarting dbus/avahi services"

service dbus restart && service avahi-daemon restart

echo "browsing external services...."

while [ 1 ]; do
  echo "services as of `date`:"
  avahi-browse -t -a --resolve | grep -ve "\slo\s" | grep -v `hostname`
  sleep 5
done
