#!/usr/bin/env bash

IFS=- read SITE TASK UNIT <<< `hostname`

# CHECK FOR ADMINUSER and ADMINPASSWD, FAIL OTHERWISE

echo "$TASK machine number $UNIT at site $SITE"

if [ $TASK == 'lobby' ] && [ $UNIT == '1' ]; then
  echo "PROVISION COUCHBASE SERVER HERE ... "
  cp services/couchbase.service /etc/avahi/services/couchbase.service

fi

# ensure dbus and avahi started
service dbus restart && service avahi-daemon restart

echo "browsing services...."
sleep 10
SERVICES=`avahi-browse -t -p --resolve _couchbase_rest._tcp | grep -ve ';lo;'`
for service in $SERVICES; do
  echo $service | \
    grep -e '^=' | \
    awk -F';' '{ print "cbs REST at " $8 " port " $9 }'
done

while [ 1 ]; do
  echo "waiting for kill ... ";
  sleep 30
done

exit

curl -v -X POST http://localhost:8091/pools/default \
     -d memoryQuota=512 \
     -d indexMemoryQuota=512

curl -v http://localhost:8091/node/controller/setupServices \
     -d services=kv%2cn1ql%2Cindex

curl -v http://localhost:8091/settings/web \
     -d port=8091 \
     -d username=$adminuser \
     -d password=$adminpasswd

curl -v -u $adminuser:$adminpasswd \
     -X POST http://localhost:8091/pools/default/buckets \
     -d name=testbucket \
     -d bucketType=couchbase \
     -d ramQuotaMB=256 \
     -d authType=sasl

curl -v http://localhost:8093/query/service \
     -d 'statement=create primary index on testbucket'
