#!/bin/bash
docker login --username=弈星科技 --password=eStarGo2019 registry.cn-shanghai.aliyuncs.com
docker build -t registry.cn-shanghai.aliyuncs.com/estartgo-dev/nwp-commonweal-class-backend:ai-score-v$1 -f server.Dockerfile .
docker push registry.cn-shanghai.aliyuncs.com/estartgo-dev/nwp-commonweal-class-backend:ai-score-v$1