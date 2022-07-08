#!/bin/bash

source <(curl -s -L https://raw.githubusercontent.com/paxtonhare/demo-magic/master/demo-magic.sh)

{
    cat *.yaml | kubectl delete --ignore-not-found -f -
    kubectl delete ns demo --ignore-not-found
    kubectl create ns demo
} 1> /dev/null 2>&1

TYPE_SPEED=35

pe "cat block_root_user.yaml"
pe "kubectl apply -f block_root_user.yaml"
pe "kubectl create deployment root-user --image=busybox -n demo --dry-run=server"
pe "kubectl create deployment non-root-user --image=ghcr.io/kyverno/kyverno -n demo --dry-run=server"
pe "kubectl delete -f block_root_user.yaml"
pe "kubectl create deployment root-user --image=busybox -n demo --dry-run=server"
pe "cat block_stale_images.yaml"
pe "kubectl apply -f block_stale_images.yaml"
pe "kubectl create deployment old-image --image=ubuntu:18.10 -n demo --dry-run=server"
pe "kubectl create deployment new-image --image=ubuntu:22.04 -n demo --dry-run=server"
kubectl delete -f block_stale_images.yaml 1> /dev/null 2>&1
pe "cat mutate_tag_to_digest.yaml"
pe "kubectl create deployment mutate-example --image=ghcr.io/kyverno/kyverno -n demo --dry-run=server -oyaml"
pe "kubectl apply -f mutate_tag_to_digest.yaml"
pe "kubectl create deployment mutate-example --image=ghcr.io/kyverno/kyverno -n demo --dry-run=server -oyaml"
kubectl delete -f mutate_tag_to_digest.yaml 1> /dev/null 2>&1
pe "cat check_signatures.yaml"
pe "kubectl apply -f check_signatures.yaml"
pe "kubectl create deployment unsigned-example --image=ghcr.io/jimbugwadia/pause-unsigned -n demo --dry-run=server -oyaml"
pe "export COSIGN_EXPERIMENTAL=1"
pe "cosign verify ghcr.io/jimbugwadia/pause-unsigned"
pe "kubectl create deployment unsigned-example --image=ghcr.io/jimbugwadia/demo-java-tomcat -n demo --dry-run=server -oyaml"
pe "cosign verify ghcr.io/jimbugwadia/demo-java-tomcat"
kubectl delete -f check_signatures.yaml 1> /dev/null 2>&1
pe "cat check_attestations.yaml"
pe "kubectl apply -f check_attestations.yaml"
pe "kubectl create deployment attest-example --image=ghcr.io/jimbugwadia/demo-java-tomcat:v0.0.14 -n demo --dry-run=server -oyaml"
pe "kubectl create deployment attest-example --image=ghcr.io/jimbugwadia/demo-java-tomcat:v0.0.13 -n demo --dry-run=server -oyaml"
pe "cosign download attestation ghcr.io/jimbugwadia/demo-java-tomcat:v0.0.14 | jq -r .payload | base64 -d | jq . | less"
kubectl delete -f check_attestations.yaml 1> /dev/null 2>&1
