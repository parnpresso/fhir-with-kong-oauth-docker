#!/bin/bash

echo -e "Creating service..."
curl --location -g -k --request POST 'https://localhost:8444/services' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "api",
    "url": "http://api:3000"
  }'

echo -e "\nCreating route..."
curl --location -g -k --request POST 'https://localhost:8444/routes' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "api-route",
    "service": {
      "name": "api"
    },
    "paths": ["/api"]
  }'

echo -e "\nEnabling plugin..."
curl --location -g -k --request POST 'https://localhost:8444/services/api/plugins' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "key-auth",
    "protocols": ["http", "https"]
  }'

echo -e "\nCreating consumer..."
curl --location -g -k --request POST 'https://localhost:8444/consumers' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "username": "parn"
  }'

echo -e "\nRegistering consumer to plugin..."
curl --location -g -k --request POST 'https://localhost:8444/consumers/parn/key-auth'

echo -e "\n\nTesting..."
curl --location -g -k --request GET 'https://localhost:8443/api' \
  --header 'apikey: kvSpu2ZgOY1KRX78l6exlnzjGANpaoVX'
