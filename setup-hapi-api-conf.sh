#!/bin/bash

echo -e "Creating service..."
curl --location -g -k --request POST 'https://localhost:8444/services' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "hapi-fhir-api",
    "url": "http://hapi-fhir-api:8080"
  }'

echo -e "\nCreating route..."
curl --location -g -k --request POST 'https://localhost:8444/routes' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "hapi-fhir-route",
    "service": {
      "name": "hapi-fhir-api"
    },
    "paths": ["/hapi-fhir"]
  }'

echo -e "\nEnabling plugin..."
curl --location -g -k --request POST 'https://localhost:8444/services/hapi-fhir-api/plugins' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "oauth2",
    "config": {
      "scopes": ["user_profile", "patient"],
      "mandatory_scope": true,
      "enable_authorization_code": true
    },
    "protocols": ["http", "https"]
  }'

echo -e "\nCreating consumer..."
curl --location -g -k --request POST 'https://localhost:8444/consumers' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "username": "NHS"
  }'

echo -e "\nRegistering consumer to plugin..."
curl --location -g -k --request POST 'https://localhost:8444/consumers/NHS/oauth2' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "National Health Service of UK",
    "redirect_uris": ["http://nhs.co.uk/oauth-callback"]
  }'

echo -e "\nCreating authorization code..."
curl --location -g -k --request POST 'https://localhost:8443/hapi-fhir/oauth2/authorize' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "client_id": "AfqYfTqR5ZCEf42CAP0zKEUZ0ne0i0QX",
    "response_type": "code",
    "scope": "patient",
    "provision_key": "AT2Mhp22T7YKY1gNNsy2BJyFlQxJfoSg",
    "authenticated_userid": "parn"
  }'

echo -e "\nCreating token..."
curl --location -g -k --request POST 'https://localhost:8443/hapi-fhir/oauth2/token' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "grant_type": "authorization_code",
    "code": "wFpF4E0jo33MVXluMS9jh2NpeqeAA5al",
    "client_id": "AfqYfTqR5ZCEf42CAP0zKEUZ0ne0i0QX",
    "client_secret": "bqdHLT7puhXF7LiCkQaggJCS68y5xWX4"
  }'

echo -e "\n\nTesting..."
curl --location -g -k --request GET 'https://localhost:8443/hapi-fhir' \
  --header 'Authorization: Bearer tHgD8578vplBrAiyJ5mWmN2vIFQqCxjG'
