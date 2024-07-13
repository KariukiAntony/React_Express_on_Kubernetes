#! /bin/bash

set -e

DIRNAME="./kubernetes"
NAMESPACE="myapp"

BLUE="\033[94m"
RED="\033[91m"
ENDC="\033[0m"

function delete_resources() {
    kubens $NAMESPACE

    sleep 3
    echo "deleting mongo-express deployment and service"
    kubectl delete -f ${DIRNAME}/mongo-express-deployment.yaml
    
    sleep 3
    echo "deleting react deployment and service"
    kubectl delete -f ${DIRNAME}/react-deployment.yaml
    
    sleep 3
    echo "deleting express deployment and service"
    kubectl delete -f ${DIRNAME}/express-deployment.yaml

    sleep 3
    echo "deleting mongodb statefullset and service ....."
    kubectl delete -f ${DIRNAME}/mongodb-deployment.yaml

    sleep 3
    echo "deleting application credentials ..."
    kubectl delete -f ${DIRNAME}/secret.yaml
    kubectl delete -f ${DIRNAME}/configmap.yaml

    sleep 3
    echo "deleting the volumes ..."
    kubectl delete -f ${DIRNAME}/persistent-volume.yaml
    kubectl delete -f ${DIRNAME}/persistent-volume-claim.yaml
    
    sleep 3
    echo "deleting the namespace"
    kubectl delete namespace $NAMESPACE

    sleep 3
    echo "updating the hosts"
    sudo sed -i "/$DOMAIN_NAME/d" /etc/hosts
}

echo -e "\n$RED You are about to delete your resources !!! $ENDC"
read -rp "Do you want to destroy all the resources (yes/no): " input
input=${input,,}

if [[ "yes" == "$input"* ]]; then
    delete_resources

elif [[ "no" == "$input"* ]]; then
    echo -e "$BLUE Your resources remains intact. $ENDC"

else
    echo -e "$RED Invalid input. Exiting ....$ENDC\n"
    exit 1
fi