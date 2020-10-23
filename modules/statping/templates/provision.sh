curl -X POST -H "Content-Type: application/json" -d '{
    "name": "New Service",
    "domain": "https://statping.com",
    "expected": "",
    "expected_status": 200,
    "check_interval": 30,
    "type": "http",
    "method": "GET",
    "post_data": "",
    "port": 0,
    "timeout": 30,
    "order_id": 0
}' "${cluster_url}/api/services"
