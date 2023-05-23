# Description

This use case illustrates how Kyverno can be used to cleanup "bare" Pods in a Kubernetes cluster on a scheduled basis. Very often, such bare Pods are created as part of the troubleshooting process by cluster admins or platform teams. They are commonly left hanging around after their usefulness has ended thereby creating cruft by consuming resources and potentially increasing costs. The ClusterCleanupPolicy in Kyverno 1.9+ can be leveraged to identify these bare Pods and clean them up.
