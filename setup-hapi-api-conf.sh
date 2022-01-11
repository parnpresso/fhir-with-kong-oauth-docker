#!/bin/bash

echo -e "Creating service..."
curl --location -g -k --request POST 'https://localhost:8444/services' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "hapi-api",
    "url": "http://hapi-fhir-api:8080/fhir"
  }'

echo -e "\nCreating route..."
curl --location -g -k --request POST 'https://localhost:8444/routes' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "hapi-api-route",
    "service": {
      "name": "hapi-api"
    },
    "paths": ["/hapi-api"]
  }'

echo -e "\nEnabling plugin..."
curl --location -g -k --request POST 'https://localhost:8444/services/hapi-api/plugins' \
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
curl --location -g -k --request POST 'https://localhost:8443/hapi-api/oauth2/authorize' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "client_id": "XUPly2MPHh9VaRaany3LSoSbQoPNQ3xv",
    "response_type": "code",
    "scope": "patient",
    "provision_key": "IOUhcmHRfMYmUg2VWBJ9mQCoy6BOqjyM",
    "authenticated_userid": "parn"
  }'

echo -e "\nCreating token..."
curl --location -g -k --request POST 'https://localhost:8443/hapi-api/oauth2/token' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "grant_type": "authorization_code",
    "code": "vxq0lpMRwgKwEvdYkS0ah6326eCIvJzp",
    "client_id": "XUPly2MPHh9VaRaany3LSoSbQoPNQ3xv",
    "client_secret": "UvxNdGZKvvFy244J2kx2o7M3auQ038GR"
  }'

echo -e "\n\nTesting..."
curl --location -g -k --request GET 'https://localhost:8443/hapi-api' \
  --header 'Authorization: Bearer GS4rldBlqkGohMTD7gBeM8pbxHlyqB3j'
