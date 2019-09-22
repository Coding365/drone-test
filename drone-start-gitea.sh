# /bin/bash

DRONE_GITEA_CLIENT_ID=55fd1b4b-cede-4f46-97e6-7e1de072e36f
DRONE_GITEA_CLIENT_SECRET=K0TgvBit7FWFGGWpNK_i_YbLyAcz5S9U9lzL7q_ZCQw=
DRONE_RPC_SECRET=ALQU2M0KdptXUdTPKcEw
DRONE_SERVER_HOST=localhost:8080
DRONE_SERVER_PROTO=http
HOSTNAME=drone-runner
DRONE_SERVER_NAME=drone-server
DRONE_RUNNER_NAME=drone-runner


docker stop ${DRONE_SERVER_NAME}
docker rm ${DRONE_SERVER_NAME}
docker stop ${DRONE_RUNNER_NAME}
docker rm ${DRONE_RUNNER_NAME}


docker run  -d \
  -v /Users/Wuyx/Documents/k8s/drone/drone-test/drone:/var/lib/drone \
  -e DRONE_AGENTS_ENABLED=true \
  -e DRONE_GITEA_SERVER=http://localhost:3000 \
  -e DRONE_GITEA_CLIENT_ID=${DRONE_GITEA_CLIENT_ID} \
  -e DRONE_GITEA_CLIENT_SECRET=${DRONE_GITEA_CLIENT_SECRET} \
  -e DRONE_RPC_SECRET=${DRONE_RPC_SECRET} \
  -e DRONE_SERVER_HOST=${DRONE_SERVER_HOST} \
  -e DRONE_SERVER_PROTO=${DRONE_SERVER_PROTO} \
  -e DRONE_LOGS_DEBUG=true \
  -e DRONE_LOGS_TEXT=true \
  -e DRONE_LOGS_PRETTY=true \
  -e DRONE_LOGS_COLOR=true \
  -e TZ=Asia/Shanghai \
  -p 8080:80 \
  --restart=always \
  --name=drone-server \
  drone/drone:1.4.0



docker run -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e DRONE_RPC_PROTO=http \
  -e DRONE_RPC_HOST=${DRONE_SERVER_NAME} \
  -e DRONE_RPC_SECRET=${DRONE_RPC_SECRET} \
  -e DRONE_RPC_SERVER=http://${DRONE_SERVER_NAME} \
  -e DRONE_RUNNER_CAPACITY=2 \
  -e DRONE_RUNNER_NAME=${DRONE_RUNNER_NAME} \
  -e DRONE_LOGS_DEBUG=true \
  -e DRONE_LOGS_TEXT=true \
  -e DRONE_LOGS_PRETTY=true \
  -e DRONE_LOGS_COLOR=true \
  -e TZ=Asia/Shanghai \
  --restart always \
  --name ${DRONE_RUNNER_NAME} \
  --link ${DRONE_SERVER_NAME}:${DRONE_SERVER_NAME} \
  drone/agent:1.4.0

 