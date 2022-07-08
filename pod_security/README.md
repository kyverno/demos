1. Install kyverno: 

```sh
kubectl create -f https://raw.githubusercontent.com/kyverno/kyverno/main/config/install.yaml
```

2. Run a bad pod

```sh
kubectl run r00t --restart=Never -ti --rm --image lol --overrides '{"spec":{"hostPID": true, "containers":[{"name":"1","image":"public.ecr.aws/h1a5s9h8/alpine:latest","command":["nsenter","--mount=/proc/1/ns/mnt","--","/bin/bash"],"stdin": true,"tty":true,"securityContext":{"privileged":true}}]}}'
```

3. Install [pod security standard restricted](https://kubernetes.io/docs/concepts/security/pod-security-standards/#restricted) policies in enforce mode:

```sh
kustomize build https://github.com/kyverno/policies/pod-security/enforce | kubectl apply -f -
```

3. Show that the bad pod is now blocked

```sh
kubectl run r00t2 --restart=Never -ti --rm --image lol --overrides '{"spec":{"hostPID": true, "containers":[{"name":"1","image":"public.ecr.aws/h1a5s9h8/alpine:latest","command":["nsenter","--mount=/proc/1/ns/mnt","--","/bin/bash"],"stdin": true,"tty":true,"securityContext":{"privileged":true}}]}}'
```

5. Show that policy reports with violations are seen for existing non-compliant pods
