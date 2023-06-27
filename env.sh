#!/bin/bash

# consul cli
export CONSUL_HTTP_TOKEN='1111111-2222-3333-4444-555555555555'
export CONSUL_HTTP_ADDR=localhost:8501
export CONSUL_HTTP_SSL=true
export CONSUL_HTTP_SSL_VERIFY=false

# apps
export API_APP=$(kubectl get pods | grep 'api-' | awk '{print $1}')
export WEB_APP=$(kubectl get pods | grep 'web-' | awk '{print $1}')
export PCI_WEB_APP=$(kubectl get pods -n pci-frontend | grep 'pci-frontend-web-' | awk '{print $1}')
