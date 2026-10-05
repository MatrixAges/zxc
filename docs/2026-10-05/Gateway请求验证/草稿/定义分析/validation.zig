const std = @import("std");
const f = @import("fixture.zig");

test "Gateway rejects duplicate method after Group expansion" {
    try f.reject("<Gateway name='api'><Group prefix='/api/'><Route method='GET' path='/same' service='a'/></Group><Route method='GET' path='/api/same' service='b'/></Gateway>", "context");
}

test "Gateway rejects wildcard before concrete method" {
    try f.reject("<Gateway name='api'><Route path='/same' service='a'/><Route method='GET' path='/same' service='b'/></Gateway>", "context");
}

test "Gateway rejects concrete method before wildcard" {
    try f.reject("<Gateway name='api'><Route method='GET' path='/same' service='a'/><Route path='/same' service='b'/></Gateway>", "context");
}

test "Gateway rejects duplicate wildcard" {
    try f.reject("<Gateway name='api'><Route path='/same' service='a'/><Route path='/same' service='b'/></Gateway>", "context");
}

test "Gateway rejects relative route path" {
    try f.reject("<Gateway name='api'><Route path='relative' service='a'/></Gateway>", "context");
}

test "Gateway rejects empty route path" {
    try f.reject("<Gateway name='api'><Route path='' service='a'/></Gateway>", "context");
}

test "Gateway rejects query route path" {
    try f.reject("<Gateway name='api'><Route path='/a?b' service='a'/></Gateway>", "context");
}

test "Gateway rejects fragment route path" {
    try f.reject("<Gateway name='api'><Route path='/a#b' service='a'/></Gateway>", "context");
}

test "Gateway rejects space route path" {
    try f.reject("<Gateway name='api'><Route path='/a b' service='a'/></Gateway>", "context");
}

test "Gateway rejects wildcard route path" {
    try f.reject("<Gateway name='api'><Route path='/*' service='a'/></Gateway>", "context");
}

test "Gateway rejects parameter route path" {
    try f.reject("<Gateway name='api'><Route path='/:id' service='a'/></Gateway>", "context");
}

test "Gateway rejects braces route path" {
    try f.reject("<Gateway name='api'><Route path='/{id}' service='a'/></Gateway>", "context");
}

test "Gateway rejects percent tail route path" {
    try f.reject("<Gateway name='api'><Route path='/%' service='a'/></Gateway>", "context");
}

test "Gateway rejects percent digit route path" {
    try f.reject("<Gateway name='api'><Route path='/%2' service='a'/></Gateway>", "context");
}

test "Gateway rejects percent invalid route path" {
    try f.reject("<Gateway name='api'><Route path='/%GG' service='a'/></Gateway>", "context");
}

test "Gateway rejects nonASCII route path" {
    try f.reject("<Gateway name='api'><Route path='/中文' service='a'/></Gateway>", "context");
}

test "Gateway rejects relative group prefix" {
    try f.reject("<Gateway name='api'><Group prefix='api'><Route path='/a' service='a'/></Group></Gateway>", "context");
}

test "Gateway rejects query group prefix" {
    try f.reject("<Gateway name='api'><Group prefix='/api?query'><Route path='/a' service='a'/></Group></Gateway>", "context");
}

test "Gateway rejects wildcard group prefix" {
    try f.reject("<Gateway name='api'><Group prefix='/*'><Route path='/a' service='a'/></Group></Gateway>", "context");
}

test "Gateway execution rejects grpc protocol" {
    try f.reject("<Gateway name='api' protocol='grpc'/>", "context");
}

test "Gateway execution rejects websocket protocol" {
    try f.reject("<Gateway name='api' protocol='websocket'/>", "context");
}

test "Gateway execution rejects tcp protocol" {
    try f.reject("<Gateway name='api' protocol='tcp'/>", "context");
}

test "Gateway execution rejects mqtt protocol" {
    try f.reject("<Gateway name='api' protocol='mqtt'/>", "context");
}

test "Gateway rejects zero header limit" {
    try f.reject("<Gateway name='api' max_header_bytes='0'/>", "context");
}

test "Gateway rejects above maximum header limit" {
    try f.reject("<Gateway name='api' max_header_bytes='16777217'/>", "context");
}

test "Gateway rejects hostname listen address" {
    try f.reject("<Gateway name='api' listen='localhost:8080'/>", "context");
}

test "Gateway rejects missing port listen address" {
    try f.reject("<Gateway name='api' listen='127.0.0.1'/>", "context");
}

test "Gateway rejects invalid address listen address" {
    try f.reject("<Gateway name='api' listen='999.1.1.1:80'/>", "context");
}

test "Gateway rejects port overflow listen address" {
    try f.reject("<Gateway name='api' listen='127.0.0.1:65536'/>", "context");
}

test "Gateway accepts bracketed IPv6 and boundary limits" {
    var result = try f.analyze(f.allocator, "<Gateway name='api' protocol='http' listen='[::1]:0' max_header_bytes='16777216' max_body_bytes='0'/>", "main.gateway.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .definition);
    try std.testing.expectEqualStrings("[::1]:0", result.value.definition.listen.?);
    try std.testing.expectEqual(@as(u32, 16777216), result.value.definition.max_header_bytes);
    try std.testing.expectEqual(@as(u32, 0), result.value.definition.max_body_bytes);
}

test "Gateway service cannot escape project root" {
    try f.reject("<Gateway name='api'><Route path='/a' service='../outside'/></Gateway>", "context");
}

test "Gateway owner must have gateway extension" {
    var result = try f.analyze(f.allocator, "<Gateway name='api'/>", "main.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
}

test "Gateway rejects IPv6 without explicit port" {
    try f.reject("<Gateway name='api' listen='[::1]'/>", "context");
}

test "Gateway accepts explicit decimal boundary ports" {
    for ([_][]const u8{ "127.0.0.1:0", "127.0.0.1:65535", "[::1]:65535" }) |listen| {
        const source = try std.fmt.allocPrint(f.allocator, "<Gateway name='api' listen='{s}'/>", .{listen});

        defer f.allocator.free(source);

        var result = try f.analyze(f.allocator, source, "main.gateway.rx");

        defer result.deinit();

        try std.testing.expect(result.value == .definition);
        try std.testing.expectEqualStrings(listen, result.value.definition.listen.?);
    }
}

test "Gateway rejects empty explicit port" {
    try f.reject("<Gateway name='api' listen='127.0.0.1:'/>", "context");
}
