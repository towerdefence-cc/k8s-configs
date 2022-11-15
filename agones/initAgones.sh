kubectl create namespace towerdefence
helm repo add agones https://agones.dev/chart/stable
helm repo update
helm install agones agones/agones --set "gameservers.namespaces={towerdefence}" \
  --set "agones.featureGates=PlayerTracking=true&PlayerAllocationFilter=true" \
  --set "agones.allocator.service.http.enabled=false" \
  --set "agones.allocator.service.grpc.port=10000" \
  --set "agones.allocator.service.loadBalancerIP=65.109.85.250" \
  --set "agones.metrics.prometheusEnabled=true" \
  --set "agones.metrics.prometheusServiceDiscovery=true" \
  --set "agones.allocator.serviceMetrics.http.portName=metrics" \
  -n agones-system --create-namespace

EXTERNAL_IP=$(kubectl get services agones-allocator -n agones-system -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
helm upgrade agones agones/agones --reuse-values \
  --set agones.allocator.service.loadBalancerIP="${EXTERNAL_IP}" \
  -n agones-system

helm upgrade agones agones/agones --reuse-values \
  --set "agones.allocator.serviceMetrics.http.portName=metrics" \
  -n agones-system

helm upgrade agones agones/agones --reuse-values \
  --set "agones.allocator.service.http.enabled=false" \
  --set "agones.allocator.service.grpc.port=10000" \
  -n agones-system

