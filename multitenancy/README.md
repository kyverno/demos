# Kyverno multi-tenancy demo

This demo uses generate and mutate policies to create namespaced and cluster-wide resources:

* [roles.yaml](roles.yaml): installs a cluster-wide role called `ns-admin` that allows creation of namespaces.
* [check-ns-labels.yaml](check-ns-labels.yaml): requires a label `type` with values `small`, `medium`, or `large` for each namespace.
* [add-ns-label.yaml](add-ns-label.yaml): adds a `createdBy` label to each namespace.
* [add-quota.yaml](check-ns-labels.yaml): adds resource quotas based on the `type` label.
* [add-network-policy.yaml](add-network-policy): adds a default deny-all network policy to each namespace.
* [add-limit-range.yaml](add-limit-range): adds a LimitRange to each namespace.
* [add-access-controls.yaml](add-access-controls.yaml): creates fine-grained roles and role bindings for the namespace owners to allow viewing and deletion of namespaces.

