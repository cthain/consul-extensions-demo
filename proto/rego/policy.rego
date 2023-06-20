package envoy.authz

import future.keywords

import input.attributes.request.http as http_request

default allow := false

allow {
	http_request.method == "GET"
}

allow {
	http_request.method == "POST"
	t := time.clock(time.now_ns())
	t[0] != 18
}
