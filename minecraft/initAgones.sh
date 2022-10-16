kubectl create namespace towerdefence
helm install agones agones/agones --set "gameservers.namespaces={towerdefence}" \
  --set "agones.featureGates=PlayerTracking=true&PlayerAllocationFilter=true" --namespace agones-system

EXTERNAL_IP=$(kubectl get services agones-allocator -n agones-system -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
helm upgrade agones agones/agones --reuse-values \
   --set agones.allocator.service.loadBalancerIP="${EXTERNAL_IP}" \
   --namespace agones-system
