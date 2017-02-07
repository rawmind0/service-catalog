# Weave Cloud Suite

Weave Cloud provides all you need to implement Continuous Delivery with hosted Prometheus monitoring and visual distributed system analysis/debug tools.

_To learn more and singup please visit [weave.works](https://weave.works)._

You will need to provide an authentication token before you install this stack.

## Technical Information

This stack installs a Kubernetes job that in turns installs the latest version of all the neccessary components.

To view the pods installed, try `kubectl get pods -n kube-system -l weave-cloud-component`.

## If you need to Uninstall...

If you would like to uninstall this stack, you will need to do it using Rancher UI or CLI first, and then run the following command:

```
kubectl detele -n kube-system -f "https://cloud.weave.works/k8s.yaml?t=${WEAVE_CLOUD_SERVICE_TOKEN}"
```
