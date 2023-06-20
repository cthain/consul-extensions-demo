# A simple Envoy external authorization server

This prototype is a simple Envoy HTTP and gRPC authorization server.
It currently allows odd requests and denies even requests; i.e., it will allow request 1, deny request 2, etc...

## Build

```shell
docker build . -t authz-server
```

## Run HTTP server

```shell
docker run -d --rm --name authz-http-server -p 8080:8080 authz-server authz -mode http
```

## Run gRPC server

```shell
docker run -d --rm --name authz-grpc-server -p 8080:8080 authz-server authz -mode grpc
```
