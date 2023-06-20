package main

import (
	"fmt"
	"io"
	"net/http"
	"sync"
)

type httpServer struct {
	deny bool
	m    sync.Mutex
}

func (h *httpServer) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Printf("handling request: url = %#v, r = %#v\n", *r.URL, *r)
	h.m.Lock()
	defer h.m.Unlock()

	body, err := io.ReadAll(r.Body)
	if err != nil {
		fmt.Println("error reading body:", err)
	} else {
		fmt.Println("body =", string(body))
	}

	fmt.Println("")

	status := http.StatusOK
	if h.deny {
		status = http.StatusForbidden
	}
	w.WriteHeader(status)
	h.deny = !h.deny
}
