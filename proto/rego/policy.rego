package envoy.authz

import future.keywords

import input.attributes.request.http as http_request

default allow := false

allow {
	permitted
}

permitted {
	methods := {"GET", "HEAD", "OPTIONS"}
	methods[http_request.method]
}

permitted {
	methods := {"POST", "PUT", "PATCH", "DELETE"}
	business_days := {"Monday", "Tuesday", "Wednesday", "Friday"}
	business_hours := {15,16,17,18,19,20,21,23}
	d := time.weekday(time.now_ns())
	t := time.clock(time.now_ns())


	glob.match("/admin/**", ["/"], http_request.path)
	methods[http_request.method]
	business_days[d]
	business_hours[t[0]]
}
