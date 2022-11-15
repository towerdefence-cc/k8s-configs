helm repo add open-match https://open-match.dev/chart/stable
helm install open-match --create-namespace --namespace open-match open-match/open-match \
  --set "open-match-core.swaggerui.enabled=false" \
  --set "telemetry.prometheus.enabled" \

