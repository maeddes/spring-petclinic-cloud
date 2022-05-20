#!/bin/sh
set -eux
NAMESPACE=$(kubectl config view --minify --output 'jsonpath={..namespace}'); echo $NAMESPACE
INGRESS_IP_ISTIO=$(kubectl get service --namespace istio-system istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[].ip}'); echo $INGRESS_IP_ISTIO
openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -keyout istio.key -out istio.crt -subj "/CN=istio.$INGRESS_IP_ISTIO.nip.io"
kubectl create secret generic --namespace istio-system istio.app-tls --from-file=key=istio.key --from-file=cert=istio.crt