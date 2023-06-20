package main

import (
	"context"
	"fmt"
	"log"
	"sync"

	envoy_service_auth_v3 "github.com/envoyproxy/go-control-plane/envoy/service/auth/v3"
	"google.golang.org/genproto/googleapis/rpc/code"
	"google.golang.org/genproto/googleapis/rpc/status"
)

type grpcServer struct {
	deny bool
	m    sync.Mutex
}

var _ envoy_service_auth_v3.AuthorizationServer = (*grpcServer)(nil)

// Check implements authorization's Check interface which performs authorization check based on the
// attributes associated with the incoming request.
func (s *grpcServer) Check(ctx context.Context, req *envoy_service_auth_v3.CheckRequest) (*envoy_service_auth_v3.CheckResponse, error) {
	log.Println("processing gRPC authz request: denied =", s.deny)
	s.m.Lock()
	defer func() {
		s.deny = !s.deny
		s.m.Unlock()
	}()

	c := code.Code_OK
	if s.deny {
		//c = code.Code_PERMISSION_DENIED
		return nil, fmt.Errorf("suck it")
	}
	return &envoy_service_auth_v3.CheckResponse{
		Status: &status.Status{
			Code: int32(c),
		},
	}, nil
}
