const std = @import("std");
const f = @import("fixture.zig");

test "Gateway empty definition retains default limits" {
    var result = try f.analyze(f.allocator, "<Gateway name='api'/>", "main.gateway.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .definition);

    const definition = result.value.definition;

    try std.testing.expectEqualStrings("api", definition.name);
    try std.testing.expectEqual(@as(usize, 0), definition.routes.len);
    try std.testing.expectEqual(@as(u32, 8192), definition.max_header_bytes);
    try std.testing.expectEqual(@as(u32, 1048576), definition.max_body_bytes);
    try std.testing.expect(definition.listen == null);
    try std.testing.expect(definition.protocol == null);
}

test "Gateway nested groups trim prefix boundary but retain route suffix" {
    const source = "<Gateway name='api'><Group prefix='/api/'><Group prefix='/v1/'><Route method='GET' path='/items/' service='../service'/></Group></Group></Gateway>";
    var result = try f.analyze(f.allocator, source, "routes/main.gateway.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .definition);

    const route = result.value.definition.routes[0];

    try std.testing.expectEqualStrings("/api/v1/items/", route.path);
    try std.testing.expectEqualStrings("service.rx", route.service);
    try std.testing.expectEqual(.GET, route.method.?);
}

test "Gateway methods on same path stay independent" {
    const source = "<Gateway name='api'><Route method='GET' path='/a' service='first'/><Route method='HEAD' path='/a' service='second'/><Route method='POST' path='/a' service='third'/></Gateway>";
    var result = try f.analyze(f.allocator, source, "main.gateway.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .definition);
    try std.testing.expectEqual(@as(usize, 3), result.value.definition.routes.len);
    try std.testing.expectEqual(.GET, result.value.definition.routes[0].method.?);
    try std.testing.expectEqual(.HEAD, result.value.definition.routes[1].method.?);
    try std.testing.expectEqual(.POST, result.value.definition.routes[2].method.?);
    try std.testing.expectEqualStrings("third.rx", result.value.definition.routes[2].service);
}

test "Gateway all recognized methods fit independent route masks" {
    const source = "<Gateway name='api'><Route method='GET' path='/a' service='a'/><Route method='HEAD' path='/a' service='a'/><Route method='POST' path='/a' service='a'/><Route method='PUT' path='/a' service='a'/><Route method='DELETE' path='/a' service='a'/><Route method='CONNECT' path='/a' service='a'/><Route method='OPTIONS' path='/a' service='a'/><Route method='TRACE' path='/a' service='a'/><Route method='PATCH' path='/a' service='a'/></Gateway>";
    var result = try f.analyze(f.allocator, source, "main.gateway.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .definition);
    try std.testing.expectEqual(@as(usize, 9), result.value.definition.routes.len);
}

test "Gateway missing method remains wildcard for recognized methods" {
    var result = try f.analyze(f.allocator, "<Gateway name='api'><Route path='/a' service='handler'/></Gateway>", "main.gateway.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .definition);
    try std.testing.expect(result.value.definition.routes[0].method == null);
}

test "Gateway literal percent path colon and trailing slash remain distinct" {
    const source = "<Gateway name='api'><Route path='/a' service='a'/><Route path='/a/' service='a'/><Route path='/a%2Fb' service='a'/><Route path='/a%2fb' service='a'/><Route path='/a:b' service='a'/></Gateway>";
    var result = try f.analyze(f.allocator, source, "main.gateway.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .definition);
    for ([_][]const u8{ "/a", "/a/", "/a%2Fb", "/a%2fb", "/a:b" }, result.value.definition.routes) |expected, actual| try std.testing.expectEqualStrings(expected, actual.path);
}

test "Gateway service paths resolve relative to Gateway not URL groups" {
    const source = "<Gateway name='api'><Group prefix='/external'><Route path='/a' service='./internal/../handler'/></Group></Gateway>";
    var result = try f.analyze(f.allocator, source, "nested/main.gateway.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .definition);
    try std.testing.expectEqualStrings("nested/handler.rx", result.value.definition.routes[0].service);
}

test "Gateway definition owns source derived strings" {
    var source = "<Gateway name='stable' listen='127.0.0.1:1234'><Group prefix='/api'><Route path='/items' service='reader'/></Group></Gateway>".*;
    var result = try f.analyze(f.allocator, &source, "main.gateway.rx");

    defer result.deinit();
    @memset(&source, 'x');

    try std.testing.expect(result.value == .definition);
    try std.testing.expectEqualStrings("stable", result.value.definition.name);
    try std.testing.expectEqualStrings("127.0.0.1:1234", result.value.definition.listen.?);
    try std.testing.expectEqualStrings("/api/items", result.value.definition.routes[0].path);
    try std.testing.expectEqualStrings("reader.rx", result.value.definition.routes[0].service);
}

test "Gateway duplicate path diagnostic points to later path attribute" {
    const source = "<Gateway name='api'>\n<Route method='GET' path='/same' service='a'/>\n<Route method='GET' path='/same' service='b'/>\n</Gateway>";
    var result = try f.analyze(f.allocator, source, "main.gateway.rx");

    defer result.deinit();

    try std.testing.expect(result.value == .diagnostic);
    try std.testing.expectEqual(@as(usize, 3), result.value.diagnostic.location.line);
    try std.testing.expectEqual(std.mem.lastIndexOf(u8, source, "/same").?, result.value.diagnostic.location.offset);
}
