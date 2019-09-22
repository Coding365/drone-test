# /bin/bash

DRONE_GITHUB_CLIENT_ID=ce1fa2bc109813e435b0
DRONE_GITHUB_CLIENT_SECRET=d688281318701157a096819dccc66a440f01c2ad
DRONE_RPC_SECRET=ALQU2M0KdptXUdTPKcEw
DRONE_SERVER_HOST=localhost
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
  -e DRONE_GITHUB_SERVER=https://github.com \
  -e DRONE_GITHUB_CLIENT_ID=${DRONE_GITHUB_CLIENT_ID} \
  -e DRONE_GITHUB_CLIENT_SECRET=${DRONE_GITHUB_CLIENT_SECRET} \
  -e DRONE_RPC_SECRET=${DRONE_RPC_SECRET} \
  -e DRONE_SERVER_HOST=${DRONE_SERVER_HOST} \
  -e DRONE_SERVER_PROTO=${DRONE_SERVER_PROTO} \
  -e DRONE_LOGS_DEBUG=true \
  -e DRONE_LOGS_TEXT=true \
  -e DRONE_LOGS_PRETTY=true \
  -e DRONE_LOGS_COLOR=true \
  -p 8080:80 \
  --restart=always \
  --name=drone-server \
  drone/drone:1.0.0-rc.1


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
  --restart always \
  --name ${DRONE_RUNNER_NAME} \
  --link ${DRONE_SERVER_NAME}:${DRONE_SERVER_NAME} \
  drone/agent:1.0.0-rc.1