# Description

This use case illustrates how Kyverno can be used to create your own custom "audit" events, here if a resource like a ConfigMap is updated, and include the user information who made the request. This can be useful in cases where the Kubernetes audit log either cannot be directly edited, it hasn't been enabled, or you just wish to have central visibility on certain resources of interest.

In this demo, Kyverno will generate a standard Kubernetes Event resource when a ConfigMap is edited. The Event will be associated with the ConfigMap being edited and will include the user information who made the request. This allows you to perform, for example, a `kubectl describe` on the ConfigMap and see this information, or, forwarded to a log aggregation system if using something like [k8s-event-logger](https://github.com/max-rocket-internet/k8s-event-logger).

Once the ConfigMap is created, apply the manifest which represents an edit. You should see an Event generated and associated with this ConfigMap which prints the request information. Note that until Kyverno 1.10, subsequent edits may not print an additional Event unless the UpdateRequest is deleted.
