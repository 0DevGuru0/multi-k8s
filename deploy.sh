docker build -t afsan007/multi-client:latest -t afsan007/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t afsan007/multi-server:latest -t afsan007/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t afsan007/multi-worker:latest -t afsan007/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push afsan007/multi-client:latest
docker push afsan007/multi-server:latest
docker push afsan007/multi-worker:latest

docker push afsan007/multi-client:$SHA
docker push afsan007/multi-server:$SHA
docker push afsan007/multi-worker:$SHA

kubectl apply -f k8s/client
kubectl apply -f k8s/database
kubectl apply -f k8s/postgres
kubectl apply -f k8s/redis
kubectl apply -f k8s/server
kubectl apply -f k8s/worker

kubectl set image deployments/server-deployment server=afsan007/multi-server:$SHA
kubectl set image deployments/client-deployment client=afsan007/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=afsan007/multi-worker:$SHA