docker image build . -t my_jenkins -f Jenkins/Dockerfile
minikube image load  --overwrite=true my_jenkins:latest

kubectl apply -f Jenkins/service.yaml && \
kubectl apply -f Jenkins/storage.yaml && \
kubectl apply -f Jenkins/permissions.yaml && \
kubectl apply -f Jenkins/jenkins-deploy.yaml

