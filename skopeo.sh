#!/bin/bash

set -ex

for IMAGE in $(cat ${IMAGES_LIST_FILE} | sed '/^#/d')
do
	echo "syncing $IMAGE..."
	IMAGE_NAME=$(echo "$IMAGE" | awk -F '/' '{print $NF}' | awk -F ':' '{print $1}')
	IMAGE_TAG=$(echo "$IMAGE" | awk -F '/' '{print $NF}' | awk -F ':' '{print $2}')
	SRC=docker://$IMAGE
	DEST=docker://$REGISTRY/$REPOSITORY/$IMAGE_NAME:$IMAGE_TAG
	echo
	sleep 2
	if skopeo copy --dest-creds $TOKEN --multi-arch all ${SRC} ${DEST}
	then
	  echo "Process: sync $SRC to $DEST successfully"
	else
	  echo "$SRC sync failed"
	  exit 1
	fi
	sleep 1
done