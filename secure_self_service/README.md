# Demo for automated, secure, self-service EKS cluster provisioning using Crossplane, ArgoCD and Kyverno

Secure self-service cluster provisioning workflow requires Crossplane, Kyverno and ArgoCD to be deployed on a management cluster. Each of these components is preconfigured with appropriate permissions and to perform specific tasks
* Crossplane - Provisions the EKS cluster.
* Kyverno - Watches for resources and generates resources to initiate cluster creation and register the created cluster with ArgoCD.
* ArgoCD - Deploys the cluster resources to the management cluster and deploys the add-ons to the newly created tenant cluster.


## Setup

Create a management cluster on Amazon EKS and follow the instructions to install Crossplane, ArgoCD and Kyverno on the management cluster.

**Install and Configure Crossplane** 

Install the crossplane and the AWS provider by following the instructions [here](https://docs.crossplane.io/v1.11/getting-started/provider-aws/). In order to use the AWS provider, you have to configure IAM role for service account in AWS (IRSA) and give full access to the EKS service. Instructions to configure IRSA can be found [here](https://aws-controllers-k8s.github.io/community/docs/user-docs/irsa/#step-1-create-an-oidc-identity-provider-for-your-cluster).

Once the cross plane AWS provider is configured, you can verify if it is configured by trying to create a cluster. 

**Install and Configure ArgoCD**

Next, install ArgoCD using the instructions to install the helm chart [here](https://github.com/argoproj/argo-helm/tree/main/charts/argo-cd). 

ArgoCD will be used to install the add-ons once the cluster has been provisioned so it needs to be able to assume the same role that was used to create the cluster. You can find detailed instructions to install and configure ArgoCD on the EKS cluster [here](https://www.modulo2.nl/blog/argocd-on-aws-with-multiple-clusters).

Once ArgoCD is installed and verified, create the [AppSets for the cluster add-ons](appsets/). 

```console
kubectl create -f argocd/appsets/appset_kyverno.yaml -n argocd
kubectl create -f argocd/appsets/appset_kyverno_policies.yaml -n argocd
```

You can verify the appsets:
```console
 kubectl get appsets -n argocd
```
In ArgoCD, change the resource tracking method to annotation so that it does not conflict with Kyverno as described [here](https://kyverno.io/docs/installation/#notes-for-argocd-users).

```console
kubectl edit cm -n argocd argocd-cm
```

```yaml
apiVersion: v1
data:
  application.resourceTrackingMethod: annotation
kind: ConfigMap
```

**Configure Kyverno**

Install Kyverno by following the instructions [here](https://kyverno.io/docs/installation/). 

Now, apply the policies to register the created cluster with ArgoCD.

```console
kubectl create -f policies/mgmt-cluster
```

The register-cluster policy registers newly created EKS clusters with ArgoCD so that the cluster add-ons can be deployed. 

**Create an EKS Cluster**

Once everything is in place, we can verify the setup. Apply the cluster creation request to your cluster.

```yaml
apiVersion: eks.aws.upbound.io/v1beta1
kind: Cluster
metadata:
  name: crossplane-cluster
  annotations:
spec:
  forProvider:
    region: us-west-1
    roleArn: arn:aws:iam::XXXXXXXX6:role/eks-role
    vpcConfig:
    - subnetIds: [ "subnet-0dff3fad15acc9156", "subnet-0ed4ba827d3066107"]
  providerConfigRef:
    name: default
```

This should initiate creation of the cluster. Within a few seconds, you should be able to go to your Amazon EKS console and view that the cluster is being created. You can also verify the cluster creation in your management cluster using the commands:

```console
kubectl get clusters.eks.aws.upbound.io -n <namespace>
```

The cluster creation should take around 10-15 minutes. Once the cluster is created (in ACTIVE status), the register-cluster policy will trigger to register the newly created EKS cluster with ArgoCD so that the cluster add-ons can be deployed. This can be verified on the ArgoCD web console or by accessing the newly created cluster


The newly created cluster has Kyverno and the default policies installed. You can also install other required add-ons by creating corresponding ArgoCD appsets. This cluster is ready for use by your application teams!

