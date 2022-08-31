# Install 

1. Install Sigstore CLI

```sh
go install github.com/sigstore/k8s-manifest-sigstore/cmd/kubectl-sigstore@latest
```

2. Install Cosign

```sh
go install github.com/sigstore/cosign/cmd/cosign@latest
```

# Demo steps

1. Create cluster role binding to cluster-admin

```sh
kubectl create clusterrolebinding test --clusterrole cluster-admin --dry-run=server
```

2. Install cluster policy

```sh
kubectl apply -f sign-rbac.yaml
```

3. Try to create the cluster role binding - it will fail

```sh
kubectl create clusterrolebinding test --clusterrole cluster-admin --dry-run=server
```

4. Sign the cluster role binding YAML

(if you need, generate a key pair using `cosign generate-keypair`)

```sh
kubectl sigstore sign -f clusterrole.yaml  --key ~/kyverno-cosign/cosign.key
```

5. Install the signed YAML

```sh
 kubectl apply -f clusterrole.yaml.signed --dry-run=server
```

6. Edit the signed YAML and change `edit` to `cluster-admin`

```sh
sed -i 's/name: edit/name: cluster-admin/' clusterrole.yaml.signed
```

7. Try installing the signed YAML again - it will give an error

```sh
 kubectl apply -f clusterrole.yaml.signed --dry-run=server
```
