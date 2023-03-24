#!/bin/sh
set -e
cd "$(dirname "$0")"
. ./.env

# Check if host.docker.internal is available
if getent hosts host.docker.internal >/dev/null 2>&1; then
    # Get IP address for host.docker.internal
    IP=$(getent hosts host.docker.internal | awk '{ print $1 }')
else
    # Get IP address for host system using ifconfig command
    IP=$(route -n | grep ^0.0.0.0 | awk '{ print $2 }')
fi

# Create a temporary file for the modified /etc/hosts
TMP_HOSTS=$(mktemp)

# Remove existing entries and add new entries to the temporary file
grep -v "$DOMAIN" /etc/hosts >"$TMP_HOSTS"
grep -v "$PROXY" "$TMP_HOSTS" >"$TMP_HOSTS.2"
mv "$TMP_HOSTS.2" "$TMP_HOSTS"

echo "$IP    $DOMAIN" >>"$TMP_HOSTS"
echo "$IP    $PROXY" >>"$TMP_HOSTS"

# Overwrite /etc/hosts with the modified temporary file
cat "$TMP_HOSTS" >/etc/hosts

# Remove the temporary file
rm "$TMP_HOSTS"
