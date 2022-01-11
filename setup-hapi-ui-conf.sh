#!/bin/bash

curl --location -g -k --request POST 'https://localhost:8444/services' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "hapi-fhir-api",
    "url": "http://hapi-fhir-api:8080"
  }'

curl --location -g --request POST 'https://localhost:8444/routes' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "hapi-fhir-route",
    "service": {
      "name": "hapi-fhir-api"
    },
    "paths": ["/hapi-fhir"]
  }'

curl --location -g --request POST 'https://localhost:8444/services/hapi-fhir-api/plugins' \
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

curl --location -g --request POST 'https://localhost:8444/consumers' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "username": "HNS"
  }'

curl --location -g --request POST 'https://localhost:8444/consumers/a57bd817-e5c7-4ea8-ac86-775f7779b32f/oauth2' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "name": "National Health Service of UK",
    "redirect_uris": ["http://nhs.co.uk/oauth-callback"]
  }'

curl --location -g --request POST 'https://localhost:8443/hapi-fhir/oauth2/authorize' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "client_id": "E6T3vugp9jNPPuiLJNF4uzeA3wlgBn3W",
    "response_type": "code",
    "scope": "patient",
    "provision_key": "NDNPvpyWes5xo8Kg67X6y2tRcfQdo00A",
    "authenticated_userid": "parn"
  }'

curl --location -g --request POST 'https://localhost:8443/hapi-fhir/oauth2/token' \
  --header 'Content-Type: application/json' \
  --data-raw '{
    "grant_type": "authorization_code",
    "code": "5OmROcyLLSyWcWtx2VK32LfR0OKy1VJl",
    "client_id": "E6T3vugp9jNPPuiLJNF4uzeA3wlgBn3W",
    "client_secret": "44lnf2S0ARQ5qkjcBtutSRfm0HbNYZ2F"
  }'
