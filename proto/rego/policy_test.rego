package envoy.authz

import future.keywords

test_get_allowed {
  allow with input as {"attributes": {"request": {"http": {"method": "GET"}}}}
}

test_post_allowed {
  not allow with input as {"attributes": {"request": {"http": {"method": "POST", "path": "/admin/users"}}}}
}
