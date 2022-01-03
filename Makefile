start:
	COMPOSE_PROFILES=database KONG_DATABASE=postgres docker-compose up

clean:
	docker-compose kill
	docker-compose rm -f
	docker volume rm $(docker volume ls --filter name=fhir-with-kong-oauth-docker -q)
