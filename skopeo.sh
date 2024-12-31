#!/bin/bash

CR_LIST=(
	swr.cn-east-5.myhuaweicloud.com/tsiongchi/
	szdk.geovisearth.com/library/
	quay.io/taolu/
	ghcr.io/athlonreg/
	docker.io/canvas1996/
	registry.cn-hangzhou.aliyuncs.com/tlhub/
)

skopeo login -u $(echo ${HUAWEI_TOKEN} | awk -F ':' '{print $1}') -p $(echo ${HUAWEI_TOKEN} | awk -F ':' '{print $2}') swr.cn-east-5.myhuaweicloud.com
skopeo login -u $(echo ${ALIYUN_TOKEN} | awk -F ':' '{print $1}') -p $(echo ${ALIYUN_TOKEN} | awk -F ':' '{print $2}') registry.cn-hangzhou.aliyuncs.com
skopeo login -u $(echo ${QUAYIO_TOKEN} | awk -F ':' '{print $1}') -p $(echo ${QUAYIO_TOKEN} | awk -F ':' '{print $2}') quay.io
skopeo login -u $(echo ${GHCR_TOKEN} | awk -F ':' '{print $1}') -p $(echo ${GHCR_TOKEN} | awk -F ':' '{print $2}') ghcr.io
skopeo login -u $(echo ${DOCKER_TOKEN} | awk -F ':' '{print $1}') -p $(echo ${DOCKER_TOKEN} | awk -F ':' '{print $2}') docker.io
skopeo login -u $(echo ${EARTH_TOKEN} | awk -F ':' '{print $1}') -p $(echo ${EARTH_TOKEN} | awk -F ':' '{print $2}') szdk.geovisearth.com

for CR in ${CR_LIST[*]}
do
	echo "syncing to ${CR}"
	skopeo sync --all --retry-times=3 --keep-going --insecure-policy --src-no-creds --src-tls-verify=false --dest-tls-verify=false --src yaml --dest docker ${IMAGES_LIST_FILE} ${CR}
done