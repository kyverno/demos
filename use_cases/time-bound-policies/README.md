# Description

This use case illustrates how Kyverno 1.9+ can be used to set an active/inactive period when a policy should or should not apply. By using some new custom JMESPath filters introduced in Kyverno 1.9, Kyverno can factor in the current time and a specified window to determine if a policy should apply.

In this demo, a policy exists in the cluster which should only take effect during business hours. A Pod which is in violation of said policy will be blocked within business hours but allowed if outside of them. By changing the operator to `AnyNotIn` instead of `AnyIn`, you invert the condition such that the policy goes into effect if NOT in the same business hours.
