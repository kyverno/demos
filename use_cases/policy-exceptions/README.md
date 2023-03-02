# Description

This use case illustrates how Kyverno can be used to allow violating resources without modifying the policy itself by using the PolicyException resource in Kyverno 1.9. This demo requires that the PolicyException feature is enabled. See the docs for full documentation but the current flag is `--enablePolicyException`.

In this demo, a "bad" Pod which violates one of the Pod Security Standard controls, which would normally be blocked, will be allowed once a matching PolicyException is created. After creating the PolicyException, attempting to create the same Pod will show it is allowed.
