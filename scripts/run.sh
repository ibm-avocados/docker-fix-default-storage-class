#!/bin/bash

DEFAULT=$(kubectl get sc | grep "(default)" | awk {'print $1'})

ibmcloud plugin install -f kubernetes-service
sleep 20
ibmcloud login --apikey $1 -r "us-south"
sleep 20
ibmcloud ks cluster config --cluster $2
sleep 20
# add helm charts
helm repo add iks-charts https://icr.io/helm/iks-charts
helm repo update
sleep 3
# install
helm install 1.6.0 iks-charts/ibmcloud-block-storage-plugin -n kube-system
sleep 5
# Make the IBM Cloud Block Storage the default `storageclass`

if [[ ${DEFAULT} != "ibmc-block-gold" ]]; then
  kubectl patch storageclass ibmc-block-gold -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
  sleep 5
  kubectl patch storageclass ${DEFAULT} -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
fi
