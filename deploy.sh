#! /bin/bash 

set -e 

DIRNAME="./kubernetes"
NAMESPACE="myapp"
DOMAIN_NAME="myapp.example.com" 

BLUE="\033[94m"
GREEN="\033[92m"
ENDC="\033[0m"

echo "creating the namespace ...."
kubectl create namespace "$NAMESPACE"
kubens "$NAMESPACE"
sleep 4

echo "Creating the volumes ..."
kubectl apply -f ${DIRNAME}/persistent-volume.yaml
kubectl apply -f ${DIRNAME}/persistent-volume-claim.yaml

sleep 4
echo "creating application credentials ..."
kubectl apply -f ${DIRNAME}/secret.yaml
kubectl apply -f ${DIRNAME}/configmap.yaml

sleep 4
echo "creating mongodb statefullset and service ....."
kubectl apply -f ${DIRNAME}/mongodb-deployment.yaml

sleep 4
echo "creating express deployment and service"
kubectl apply -f ${DIRNAME}/express-deployment.yaml

sleep 4
echo "creating react deployment and service"
kubectl apply -f ${DIRNAME}/react-deployment.yaml

sleep 4
echo "creating mongo-express deployment and service"
kubectl apply -f ${DIRNAME}/mongo-express-deployment.yaml
sleep 4
echo "creating ingress resource"
minikube addons enable ingress
kubectl apply -f ${DIRNAME}/nginx-ingress.yaml

sleep 4
echo "updating the hosts for requests routing ..."
echo "$(minikube ip) $DOMAIN_NAME" | sudo tee -a /etc/hosts

sleep 3
echo -e "\n$BLUE🚀️🚀️🔥️ The application has been fully deployed ...$ENDC"
echo -e "$GREEN Visit the following url: http://$DOMAIN_NAME $ENDC\n"