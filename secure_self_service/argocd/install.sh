#!/bin/bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
sleep 30
kubectl -n argocd patch deployment argocd-server --type=json  \
    -p='[{"op": "add", "path": "/spec/template/spec/securityContext/fsGroup", "value": 999}]'
kubectl -n argocd patch statefulset argocd-application-controller --type=json \
    -p='[{"op": "add", "path": "/spec/template/spec/securityContext/fsGroup", "value": 999}]'
