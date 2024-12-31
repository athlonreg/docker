#!/bin/bash

CR_LIST=(
	swr.cn-east-5.myhuaweicloud.com/tsiongchi/
	szdk.geovisearth.com/library/
	quay.io/taolu/
	ghcr.io/athlonreg/
	docker.io/canvas1996/
	registry.cn-hangzhou.aliyuncs.com/tlhub/
)

skopeo login -u cn-east-5@0HCRVNHPPP6VDOFKP9TX -p $(echo ${HUAWEI_TOKEN} | awk -F ':' '{print $2}') swr.cn-east-5.myhuaweicloud.com
skopeo login -u 15563836030 -p $(echo ${ALIYUN_TOKEN} | awk -F ':' '{print $2}') registry.cn-hangzhou.aliyuncs.com
skopeo login -u taolu -p $(echo ${QUAYIO_TOKEN} | awk -F ':' '{print $2}') quay.io
skopeo login -u canvas1996 -p $(echo ${GHCR_TOKEN} | awk -F ':' '{print $2}') ghcr.io
skopeo login -u canvas1996 -p $(echo ${DOCKER_TOKEN} | awk -F ':' '{print $2}') docker.io
skopeo login -u canvas1996 -p $(echo ${DOCKER_TOKEN} | awk -F ':' '{print $2}') szdk.geovisearth.com

for CR in ${CR_LIST[*]}
do
	echo "syncing to ${CR}"
	skopeo sync --all --retry-times=3 --keep-going --insecure-policy --src-tls-verify=false --dest-tls-verify=false --src yaml --dest docker ${IMAGES_LIST_FILE} ${CR}
done