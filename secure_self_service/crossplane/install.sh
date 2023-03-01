kubectl create namespace crossplane-system
helm install crossplane --namespace crossplane-system crossplane-stable/crossplane
helm list -n crossplane-system

kubectl create secret generic aws-secret -n crossplane-system --from-file=creds=./aws-credentials.txt
kubectl create -f aws-provider.yaml
kubectl get provider
echo "Waiting..."
sleep 45
kubectl get provider
kubectl get crds
kubectl create -f aws-providerconfig.yaml

