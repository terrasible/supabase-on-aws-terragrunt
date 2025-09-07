#!/bin/bash

# Simple External Endpoint Testing Script

API_GATEWAY_URL="https://supabase.terrasible.com"
GRAFANA_URL="https://grafana.terrasible.com"

echo "Testing external endpoints..."
echo

# Test API Gateway
echo "Testing API Gateway: $API_GATEWAY_URL"
if curl -s --connect-timeout 10 "$API_GATEWAY_URL/health" > /dev/null; then
    echo "✓ API Gateway is accessible"
else
    echo "✗ API Gateway failed"
fi

# Test Grafana
echo "Testing Grafana: $GRAFANA_URL"
if curl -s --connect-timeout 10 "$GRAFANA_URL/api/health" > /dev/null; then
    echo "✓ Grafana is accessible"
else
    echo "✗ Grafana failed"
fi

echo
echo "Test completed."
