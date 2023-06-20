package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"

	envoy_service_auth_v3 "github.com/envoyproxy/go-control-plane/envoy/service/auth/v3"
	"google.golang.org/grpc"
)

func main() {
	mode := flag.String("mode", "http", "authz server mode: http or grpc")
	port := flag.Int("port", 8080, "server port")
	flag.Parse()

	addr := fmt.Sprintf(":%d", *port)

	log.Println("starting", *mode, "server on", addr)

	switch *mode {
	case "http":
		svc := http.Server{Addr: addr, Handler: &httpServer{}}
		if err := svc.ListenAndServe(); err != nil {
			log.Fatalln("error:", err)
		}
		fmt.Println("server exited")
	case "grpc":
		l, err := net.Listen("tcp", addr)
		if err != nil {
			log.Fatalf("failed to listen on %d: %v", *port, err)
		}
		svc := grpc.NewServer()
		envoy_service_auth_v3.RegisterAuthorizationServer(svc, &grpcServer{})
		svc.Serve(l)
	default:
		log.Fatalf("failed to start server: unknown mode %q: mode must be one of 'http' or 'grpc'", *mode)
	}
}
