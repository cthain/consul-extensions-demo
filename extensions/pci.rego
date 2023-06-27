package envoy.authz

import future.keywords

import input.attributes.request.http as http_request
import input.attributes.metadata_context.filter_metadata.consul as consul

default allow := false

allow {
  permit
}

permit {
  consul.namespace == "pci-frontend"
}

permit {
  consul.namespace == "pci-backend"
}
