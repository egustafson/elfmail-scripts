#!/bin/bash
#
# Usage:  rsync_host_domain.sh <hosted-domain>
#
# SSH key - ensure that the aws_ericg key is loaded in your ssh-agent.
# This key is used to connect to the 'admin' account on the
# destination which enables passwordless sudo access -- needed to
# write out folders for each user.

SRC_DIR=/srv/mail

DEST_USER=admin
DEST_HOST=elfmail.elfwerks.org
DEST_DIR=/srv/mail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <hosted-domain>"
    exit 1
fi

HOST_DOMAIN=$1  # elfwerks.io.foo

if [ ! -d "${SRC_DIR}/${HOST_DOMAIN}" ]; then
   echo "Hosted domain '${HOST_DOMAIN}' is not present in ${SRC_DIR}"
   exit 1
fi

# sudo -E        -->  keep environment vars (SSH_AUTH_SOCK)
# --bwlimit=100  -->  limit to 100 KBps = 1 Mbps

sudo -E \
     rsync -avz \
     --bwlimit=100 \
     ${SRC_DIR}/${HOST_DOMAIN}/ \
     ${DEST_USER}@${DEST_HOST}:${DEST_DIR}/${HOST_DOMAIN}/ \
     --delete \
     --rsync-path="sudo rsync"
