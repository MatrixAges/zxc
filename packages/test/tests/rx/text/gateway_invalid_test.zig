const h = @import("gateway_check.zig");

test "Gateway text requires name" {
    try h.reject("<Gateway/>", .missing_attribute, "name");
}

test "Gateway text rejects blank name" {
    try h.reject("<Gateway name=' '/>", .context, "name");
}

test "Gateway text rejects unknown protocol" {
    try h.reject("<Gateway name='api' protocol='shell'/>", .invalid_attribute, "protocol");
}

test "Gateway text protocol is case sensitive" {
    try h.reject("<Gateway name='api' protocol='HTTP'/>", .invalid_attribute, "protocol");
}

test "Gateway text rejects blank listen" {
    try h.reject("<Gateway name='api' listen=' '/>", .context, "listen");
}

test "Gateway text rejects unknown attribute" {
    try h.reject("<Gateway name='api' host='localhost'/>", .unknown_attribute, "host");
}

test "Gateway text rejects flow Call" {
    try h.reject("<Gateway name='api'><Call fn='load' in='$in'/></Gateway>", .unexpected_element, null);
}

test "Gateway text rejects nested Gateway" {
    try h.reject("<Gateway name='api'><Gateway name='nested'/></Gateway>", .unexpected_element, null);
}

test "Gateway text Group requires prefix" {
    try h.reject("<Gateway name='api'><Group><Route path='/' service='home'/></Group></Gateway>", .missing_attribute, "prefix");
}

test "Gateway text Group rejects blank prefix" {
    try h.reject("<Gateway name='api'><Group prefix=' '><Route path='/' service='home'/></Group></Gateway>", .context, "prefix");
}

test "Gateway text Group requires children" {
    try h.reject("<Gateway name='api'><Group prefix='/api'/></Gateway>", .child_count, null);
}

test "Gateway text Group rejects Return" {
    try h.reject("<Gateway name='api'><Group prefix='/api'><Return value='$in'/></Group></Gateway>", .unexpected_element, null);
}

test "Gateway text Route requires path" {
    try h.reject("<Gateway name='api'><Route service='home'/></Gateway>", .missing_attribute, "path");
}

test "Gateway text Route requires service" {
    try h.reject("<Gateway name='api'><Route path='/'/></Gateway>", .missing_attribute, "service");
}

test "Gateway text Route rejects blank path" {
    try h.reject("<Gateway name='api'><Route path=' ' service='home'/></Gateway>", .context, "path");
}

test "Gateway text Route rejects blank service" {
    try h.reject("<Gateway name='api'><Route path='/' service=' '/></Gateway>", .context, "service");
}

test "Gateway text Route method is case sensitive" {
    try h.reject("<Gateway name='api'><Route path='/' service='home' method='post'/></Gateway>", .invalid_attribute, "method");
}

test "Gateway text Route rejects unknown method" {
    try h.reject("<Gateway name='api'><Route path='/' service='home' method='FETCH'/></Gateway>", .invalid_attribute, "method");
}

test "Gateway text Route rejects absolute service" {
    try h.reject("<Gateway name='api'><Route path='/' service='/home'/></Gateway>", .context, "service");
}

test "Gateway text Route rejects reserved app service" {
    try h.reject("<Gateway name='api'><Route path='/' service='app.rx'/></Gateway>", .context, "service");
}

test "Gateway text Route rejects Gateway service" {
    try h.reject("<Gateway name='api'><Route path='/' service='api.gateway.rx'/></Gateway>", .context, "service");
}

test "Gateway text Route rejects Store service" {
    try h.reject("<Gateway name='api'><Route path='/' service='jobs.store.rx'/></Gateway>", .context, "service");
}

test "Gateway text Route rejects directory service" {
    try h.reject("<Gateway name='api'><Route path='/' service='home/'/></Gateway>", .context, "service");
}

test "Gateway text Route rejects URL service" {
    try h.reject("<Gateway name='api'><Route path='/' service='https://host/home'/></Gateway>", .context, "service");
}

test "Gateway text Route rejects child" {
    try h.reject("<Gateway name='api'><Route path='/' service='home'><Route path='/x' service='other'/></Route></Gateway>", .child_count, null);
}

test "Gateway text Route rejects text" {
    try h.reject("<Gateway name='api'><Route path='/' service='home'>run</Route></Gateway>", .unexpected_text, null);
}
