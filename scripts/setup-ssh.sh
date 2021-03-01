#!/usr/bin/env bash
# setup authorized keys

count=0
max=10
while ! [ -d ~guest/.ssh ]; do
  sleep 2
  count=$((count+1))
  if [ $count = $max ]; then
    exit 1
  fi
done

mv /tmp/authorized_keys ~guest/.ssh
chown guest:guest ~guest/.ssh/authorized_keys
