docker build -t afsan007/multi-client:latest -t afsan007/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t afsan007/multi-server:latest -t afsan007/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t afsan007/multi-worker:latest -t afsan007/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push afsan007/multi-client:latest
docker push afsan007/multi-server:latest
docker push afsan007/multi-worker:latest

docker push afsan007/multi-client:$SHA
docker push afsan007/multi-server:$SHA
docker push afsan007/multi-worker:$SHA

docker apply -f k8s/client
docker apply -f k8s/database
docker apply -f k8s/postgres
docker apply -f k8s/redis
docker apply -f k8s/server
docker apply -f k8s/worker

kubectl set image deployments/server-deployment server=afsan007/multi-server:$SHA
kubectl set image deployments/client-deployment client=afsan007/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=afsan007/multi-worker:$SHA