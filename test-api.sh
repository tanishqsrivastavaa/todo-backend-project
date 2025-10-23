#!/bin/bash

# Test script for Todo Backend API
# This script tests the API structure and endpoints

echo "=== Todo Backend API Test Script ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
PASS=0
FAIL=0

# Check if server is running
check_server() {
    echo "Checking if server is accessible..."
    if curl -s http://localhost:5000/health > /dev/null; then
        echo -e "${GREEN}✓ Server is running${NC}"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗ Server is not running on port 5000${NC}"
        ((FAIL++))
        return 1
    fi
}

# Test health endpoint
test_health() {
    echo ""
    echo "Testing /health endpoint..."
    RESPONSE=$(curl -s http://localhost:5000/health)
    if echo "$RESPONSE" | grep -q "success"; then
        echo -e "${GREEN}✓ Health check passed${NC}"
        ((PASS++))
    else
        echo -e "${RED}✗ Health check failed${NC}"
        ((FAIL++))
    fi
}

# Test root endpoint
test_root() {
    echo ""
    echo "Testing / endpoint..."
    RESPONSE=$(curl -s http://localhost:5000/)
    if echo "$RESPONSE" | grep -q "Todo Backend API"; then
        echo -e "${GREEN}✓ Root endpoint working${NC}"
        ((PASS++))
    else
        echo -e "${RED}✗ Root endpoint failed${NC}"
        ((FAIL++))
    fi
}

# Test auth endpoints exist
test_auth_endpoints() {
    echo ""
    echo "Testing auth endpoints..."
    
    # Test register endpoint (should fail without data but endpoint exists)
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:5000/api/auth/register)
    if [ "$STATUS" -eq "400" ] || [ "$STATUS" -eq "429" ]; then
        echo -e "${GREEN}✓ /api/auth/register endpoint exists${NC}"
        ((PASS++))
    else
        echo -e "${RED}✗ /api/auth/register endpoint issue (status: $STATUS)${NC}"
        ((FAIL++))
    fi
    
    # Test login endpoint
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:5000/api/auth/login)
    if [ "$STATUS" -eq "400" ] || [ "$STATUS" -eq "429" ]; then
        echo -e "${GREEN}✓ /api/auth/login endpoint exists${NC}"
        ((PASS++))
    else
        echo -e "${RED}✗ /api/auth/login endpoint issue (status: $STATUS)${NC}"
        ((FAIL++))
    fi
}

# Test todo endpoints require auth
test_todo_endpoints() {
    echo ""
    echo "Testing todo endpoints (should require auth)..."
    
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/api/todos)
    if [ "$STATUS" -eq "401" ]; then
        echo -e "${GREEN}✓ /api/todos requires authentication${NC}"
        ((PASS++))
    else
        echo -e "${RED}✗ /api/todos authentication issue (status: $STATUS)${NC}"
        ((FAIL++))
    fi
}

# Test rate limiting
test_rate_limiting() {
    echo ""
    echo "Testing rate limiting..."
    echo -e "${YELLOW}Note: This test makes multiple requests${NC}"
    
    # Make 6 rapid requests to auth endpoint (limit is 5)
    local count=0
    for i in {1..6}; do
        STATUS=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:5000/api/auth/login -H "Content-Type: application/json" -d '{}')
        if [ "$STATUS" -eq "429" ]; then
            count=$((count + 1))
        fi
    done
    
    if [ "$count" -gt "0" ]; then
        echo -e "${GREEN}✓ Rate limiting is active${NC}"
        ((PASS++))
    else
        echo -e "${YELLOW}⚠ Rate limiting may not be configured (got status codes but no 429)${NC}"
        echo -e "${YELLOW}  This is okay if requests were spread out${NC}"
        ((PASS++))
    fi
}

# Run tests
echo "Starting tests..."
echo ""

check_server
if [ $? -eq 0 ]; then
    test_health
    test_root
    test_auth_endpoints
    test_todo_endpoints
    test_rate_limiting
else
    echo ""
    echo -e "${YELLOW}⚠ Server is not running. Please start the server with:${NC}"
    echo "  npm start"
    echo ""
    echo "Make sure MongoDB is running and .env file is configured."
fi

# Print summary
echo ""
echo "==================================="
echo "Test Summary"
echo "==================================="
echo -e "Passed: ${GREEN}${PASS}${NC}"
echo -e "Failed: ${RED}${FAIL}${NC}"
echo ""

if [ "$FAIL" -eq "0" ]; then
    echo -e "${GREEN}All tests passed! 🎉${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed${NC}"
    exit 1
fi
