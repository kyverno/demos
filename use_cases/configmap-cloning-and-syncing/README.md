# Description

This use case illustrates how to use Kyverno's `generate` rule capability to clone a ConfigMap with a certificate authority into both existing Namespaces as well as new Namespaces created after the policy has been deployed. It shows off both classic generate behavior as well as "generate new" behavior and can be adapted for any other type of resource in the cluster (granting of additional privileges may be required if this is done).
