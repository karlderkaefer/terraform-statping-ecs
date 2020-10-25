function wait_for_server() {
  echo "waiting for server ${cluster_url} to come up"
  max_iterations=60
  wait_seconds=5
  iterations=0
  while true
  do
    ((iterations++))
    printf '.'
    http_code=$(curl -Ls -o /dev/null -w '%%{http_code}' "${cluster_url}")
    if [ "$http_code" -eq 200 ]; then
      echo "server is up. continue provisioning ${service_name}"
      break
    fi
    if [ "$iterations" -ge "$max_iterations" ]; then
      echo "Giving up"
      exit 1
    fi
    sleep $wait_seconds
  done
}

# if the service already exists return the exit code 0
function create_or_skip_service() {
    curl -X GET \
    -Ls \
    -o /dev/null \
    -H "Authorization: Bearer ${api_key}" \
    -H "Content-Type: application/json" \
    "${cluster_url}/api/services" | jq -e ".[] | select(.name | contains(\"${service_name}\"))"
  SERVICE_FOUND_CODE=$?

  if [ $SERVICE_FOUND_CODE -ne 0 ]; then
    echo "service ${service_name} does not exist yet. creating"
    curl -X POST \
    -Ls \
    -H "Authorization: Bearer ${api_key}" \
    -H "Content-Type: application/json" \
    -d '${service_json}' "${cluster_url}/api/services"
  else
    echo "service ${service_name} already exists. skipping"
  fi
}

wait_for_server
create_or_skip_service



