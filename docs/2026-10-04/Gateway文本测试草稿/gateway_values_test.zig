const h = @import("gateway_check.zig");

test "Gateway text decodes http protocol with absent method" {
    try h.accept("<Gateway name='api' protocol='http'><Route path='/orders' service='orders/create'/></Gateway>", .http, null);
}

test "Gateway text decodes grpc protocol with absent method" {
    try h.accept("<Gateway name='api' protocol='grpc'><Route path='/orders' service='orders/create'/></Gateway>", .grpc, null);
}

test "Gateway text decodes websocket protocol with absent method" {
    try h.accept("<Gateway name='api' protocol='websocket'><Route path='/orders' service='orders/create'/></Gateway>", .websocket, null);
}

test "Gateway text decodes tcp protocol with absent method" {
    try h.accept("<Gateway name='api' protocol='tcp'><Route path='/orders' service='orders/create'/></Gateway>", .tcp, null);
}

test "Gateway text decodes mqtt protocol with absent method" {
    try h.accept("<Gateway name='api' protocol='mqtt'><Route path='/orders' service='orders/create'/></Gateway>", .mqtt, null);
}

test "Gateway text decodes GET method with absent protocol" {
    try h.accept("<Gateway name='api'><Route method='GET' path='/orders' service='orders/create'/></Gateway>", null, .GET);
}

test "Gateway text decodes HEAD method with absent protocol" {
    try h.accept("<Gateway name='api'><Route method='HEAD' path='/orders' service='orders/create'/></Gateway>", null, .HEAD);
}

test "Gateway text decodes POST method with absent protocol" {
    try h.accept("<Gateway name='api'><Route method='POST' path='/orders' service='orders/create'/></Gateway>", null, .POST);
}

test "Gateway text decodes PUT method with absent protocol" {
    try h.accept("<Gateway name='api'><Route method='PUT' path='/orders' service='orders/create'/></Gateway>", null, .PUT);
}

test "Gateway text decodes DELETE method with absent protocol" {
    try h.accept("<Gateway name='api'><Route method='DELETE' path='/orders' service='orders/create'/></Gateway>", null, .DELETE);
}

test "Gateway text decodes CONNECT method with absent protocol" {
    try h.accept("<Gateway name='api'><Route method='CONNECT' path='/orders' service='orders/create'/></Gateway>", null, .CONNECT);
}

test "Gateway text decodes OPTIONS method with absent protocol" {
    try h.accept("<Gateway name='api'><Route method='OPTIONS' path='/orders' service='orders/create'/></Gateway>", null, .OPTIONS);
}

test "Gateway text decodes TRACE method with absent protocol" {
    try h.accept("<Gateway name='api'><Route method='TRACE' path='/orders' service='orders/create'/></Gateway>", null, .TRACE);
}

test "Gateway text decodes PATCH method with absent protocol" {
    try h.accept("<Gateway name='api'><Route method='PATCH' path='/orders' service='orders/create'/></Gateway>", null, .PATCH);
}
