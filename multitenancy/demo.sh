#!/bin/bash

source <(curl -s -L https://raw.githubusercontent.com/paxtonhare/demo-magic/master/demo-magic.sh)

{
    cat *.yaml | kubectl delete --ignore-not-found -f -
    kubectl delete ns test --ignore-not-found
} 1> /dev/null 2>&1


pe "cat rbac/00-generate-rbac.yaml"
pe "kubectl apply -f rbac/00-generate-rbac.yaml"
pe "cat *.yaml | kubectl apply -f -"
pe "cat check-ns-labels.yaml"
pe "kubectl create ns test --as=nancy"
pe "cat resources/sample-ns.yaml"
pe "kubectl create -f resources/sample-ns.yaml --as=nancy"
pe "cat add-access-controls.yaml add-ns-label.yaml"
pe "kubectl get ns test -oyaml --as=nancy"
pe "kubectl get ns test -oyaml --as=ned"
pe "kubectl get rolebindings -n test"
pe "cat add-network-policy.yaml add-limit-range.yaml add-quota.yaml"
pe "kubectl get netpol -n test"
pe "kubectl delete netpol default-deny -n test --as=nancy"
pe "kubectl get netpol -n test"
pe "kubectl delete ns test --as=ned"
pe "kubectl delete ns test --as=nancy"