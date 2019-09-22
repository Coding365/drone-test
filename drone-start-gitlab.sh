# /bin/bash

DRONE_GITLAB_CLIENT_ID=312f6355db2569c4d0e7798b5853e206f0d170ae41185c24671dacd7f790762d
DRONE_GITLAB_CLIENT_SECRET=bfeead3e7a9bc846edd6c1e9486c7ea99387395d374f0494dec27533db166d7c
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
  -e DRONE_GITLAB_SERVER=http://localhost:8081 \
  -e DRONE_GITLAB_CLIENT_ID=${DRONE_GITLAB_CLIENT_ID} \
  -e DRONE_GITLAB_CLIENT_SECRET=${DRONE_GITLAB_CLIENT_SECRET} \
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

 