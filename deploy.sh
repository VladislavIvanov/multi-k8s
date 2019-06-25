#!/usr/bin/env bash
docker build -t dockerlime/multi-client:latest -t dockerlime/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t dockerlime/multi-server:latest -t dockerlime/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t dockerlime/multi-worker:latest -t dockerlime/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push dockerlime/multi-client:latest
docker push dockerlime/multi-server:latest
docker push dockerlime/multi-worker:latest

docker push dockerlime/multi-client:$SHA
docker push dockerlime/multi-server:$SHA
docker push dockerlime/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=dockerlime/multi-server:$SHA
kubectl set image deployments/client-deployment client=dockerlime/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=dockerlime/multi-worker:$SHA