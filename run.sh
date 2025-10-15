#!/bin/bash

# SSE Server Test Script
# Sends various HTTP requests with 1-second delays to test SSE monitoring

echo "🚀 Starting SSE Server Test Script"
echo "📡 Sending requests to http://localhost:3000"
echo "⏱️  Delay: 1 second between requests"
echo ""

# Function to send request with delay
send_request() {
  local method=$1
  local url=$2
  local headers=$3
  local data=$4

  echo "📤 Sending $method request to $url"

  if [ -n "$data" ]; then
    curl -s -X "$method" "http://localhost:3000$url" $headers -d "$data"
  else
    curl -s -X "$method" "http://localhost:3000$url" $headers
  fi

  echo "✅ Request completed"
  echo "⏳ Waiting 1 second..."
  sleep 1
  echo ""
}

# Test requests with different methods and headers
echo "=== POST Request (User Creation) ==="
send_request "POST" "/api/users" \
  '-H "Content-Type: application/json"' \
  '-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"' \
  '-H "X-API-Version: v2"' \
  '-H "User-Agent: TestScript/1.0"' \
  '{"name": "Alice Johnson", "email": "alice@example.com", "role": "user"}'

echo "=== GET Request (Product Retrieval) ==="
send_request "GET" "/api/products/123" \
  '-H "Accept: application/json"' \
  '-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"' \
  '-H "X-Client-ID: test-script"' \
  '-H "X-Request-ID: req-001"' \
  '-H "Cache-Control: no-cache"'

echo "=== PUT Request (Order Update) ==="
send_request "PUT" "/api/orders/456" \
  '-H "Content-Type: application/json"' \
  '-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"' \
  '-H "X-API-Version: v2"' \
  '-H "X-Client-ID: test-script"' \
  '-H "If-Match: W/\"1234567890\""' \
  '-H "X-Request-ID: req-002"' \
  '{"status": "processing", "updatedAt": "2025-01-27T12:00:00Z"}'

echo "=== DELETE Request (Cache Cleanup) ==="
send_request "DELETE" "/api/cache/old-data" \
  '-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"' \
  '-H "X-API-Version: v1"' \
  '-H "X-Client-ID: test-script"' \
  '-H "X-Request-ID: req-003"' \
  '-H "X-Admin-Key: test-admin-key"'

echo "=== PATCH Request (Settings Update) ==="
send_request "PATCH" "/api/profile/settings" \
  '-H "Content-Type: application/json"' \
  '-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"' \
  '-H "X-API-Version: v2"' \
  '-H "X-Client-ID: test-script"' \
  '-H "X-Request-ID: req-004"' \
  '-H "X-Timezone: UTC"' \
  '-H "X-Language: en-US"' \
  '{"theme": "light", "notifications": {"email": true, "push": true}}'

echo "=== Additional Test Requests ==="
send_request "POST" "/api/auth/login" \
  '-H "Content-Type: application/json"' \
  '-H "X-Client-ID: mobile-app"' \
  '-H "X-Request-ID: req-005"' \
  '{"username": "testuser", "password": "testpass123"}'

send_request "GET" "/api/analytics/dashboard" \
  '-H "Accept: application/json"' \
  '-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"' \
  '-H "X-Client-ID: web-dashboard"' \
  '-H "X-Request-ID: req-006"' \
  '-H "X-Time-Range: last-7-days"'

send_request "PUT" "/api/inventory/items/789" \
  '-H "Content-Type: application/json"' \
  '-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9"' \
  '-H "X-API-Version: v2"' \
  '-H "X-Client-ID: inventory-system"' \
  '-H "X-Request-ID: req-007"' \
  '{"quantity": 150, "lastRestocked": "2025-01-27T10:00:00Z"}'

echo "🎉 Test script completed!"
echo "📊 Check your SSE monitoring dashboard at http://localhost:3000"
echo "🔍 You should see 8 requests displayed in reverse chronological order"
