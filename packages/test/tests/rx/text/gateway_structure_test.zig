const std = @import("std");
const allocation_testing = @import("allocation_testing");
const rx = @import("rx");
const h = @import("gateway_check.zig");

const source =
    \\<Gateway name="api" protocol="http" listen="127.0.0.1:8080">
    \\  <Group prefix="/api">
    \\    <Group prefix="/v1">
    \\      <Route method="POST" path="/orders?x=1&amp;y=2" service="../orders/create.rx"/>
    \\    </Group>
    \\    <Route path="/health" service="health"/>
    \\  </Group>
    \\</Gateway>
;

test "Gateway text preserves nested groups attributes and decoded entities" {
    var parsed = try rx.parseXml(std.testing.allocator, source);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(std.testing.allocator, "api.gateway.rx", parsed.value.node);

    defer result.deinit();

    try std.testing.expect(result.value == .data);

    const gateway = result.value.data.gateway;
    const group = gateway.children[0].group;
    const nested = group.children[0].group;
    const route = nested.children[0].route;

    try std.testing.expectEqualStrings("api", gateway.attributes.name);
    try std.testing.expectEqualStrings("127.0.0.1:8080", gateway.attributes.listen.?);
    try std.testing.expectEqualStrings("/api", group.attributes.prefix);
    try std.testing.expectEqualStrings("/v1", nested.attributes.prefix);
    try std.testing.expectEqualStrings("/orders?x=1&y=2", route.attributes.path);
    try std.testing.expectEqualStrings("../orders/create.rx", route.attributes.service);
    try std.testing.expectEqual(rx.gateway.Method.POST, route.attributes.method.?);
    try std.testing.expectEqualStrings("/health", group.children[1].route.attributes.path);
    try std.testing.expectEqual(@as(?rx.gateway.Method, null), group.children[1].route.attributes.method);
}

test "Gateway text accepts route with both optional enums absent" {
    try h.accept("<Gateway name='fragment'><Route path='/orders' service='orders/create'/></Gateway>", null, null);
}

test "Gateway text rejects Module in gateway file" {
    try h.reject("<Module/>", .unexpected_element, null);
}

test "Gateway text rejects Store in gateway file" {
    try h.reject("<Store/>", .unexpected_element, null);
}

test "Gateway text successful validation releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{false});
}

test "Gateway text schema failure releases every allocation failure" {
    try allocation_testing.checkAllAllocationFailures(std.testing.allocator, checkAllocation, .{true});
}

fn checkAllocation(allocator: std.mem.Allocator, invalid: bool) !void {
    const input = if (invalid)
        "<Gateway name='api'><Group prefix='/api'><Route path='/' service='home'/><Route path='/bad' service='/absolute'/></Group></Gateway>"

    else
        source;

    var parsed = try rx.parseXml(allocator, input);

    defer parsed.deinit();

    try std.testing.expect(parsed.value == .node);

    var result = try rx.validate(allocator, "api.gateway.rx", parsed.value.node);

    defer result.deinit();

    if (invalid) {
        try std.testing.expect(result.value == .diagnostic);
        try std.testing.expectEqual(.context, result.value.diagnostic.code);
        try std.testing.expectEqualStrings("service", result.value.diagnostic.attribute.?);
    } else {
        try std.testing.expect(result.value == .data);
        try std.testing.expectEqualStrings("api", result.value.data.gateway.attributes.name);
    }
}
