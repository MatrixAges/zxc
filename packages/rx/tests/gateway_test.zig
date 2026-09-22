const std = @import("std");
const rx = @import("rx");
const h = @import("helpers.zig");

test "gateway groups routes and optional fragment settings" {
    const route = h.node("Route", .{ .method = "POST", .path = "/orders", .service = "orders/create" }, &.{});
    const group = h.node("Group", .{ .prefix = "/v1" }, &.{route});
    const root = h.node("Gateway", .{ .name = "api", .protocol = "http", .listen = "0.0.0.0:8080" }, &.{h.node("Group", .{ .prefix = "/api" }, &.{group})});
    var result = try rx.validate(std.testing.allocator, "app.gateway.rx", root);

    defer result.deinit();

    try std.testing.expect(result.value == .data);
    try std.testing.expectEqual(rx.gateway.Protocol.http, result.value.data.gateway.attributes.protocol.?);
    try std.testing.expectEqual(rx.gateway.Method.POST, result.value.data.gateway.children[0].group.children[0].group.children[0].route.attributes.method.?);
    try h.expectValid("users.gateway.rx", h.node("Gateway", .{ .name = "api" }, &.{route}));
}

test "socket routes do not require HTTP methods" {
    try h.expectValid("socket.gateway.rx", h.node("Gateway", .{ .name = "socket", .protocol = "websocket" }, &.{
        h.node("Route", .{ .path = "/message", .service = "chat/handle" }, &.{}),
    }));
}

test "gateway rejects unknown adapters incomplete routes and flow children" {
    const issue = try h.expectError("api.gateway.rx", h.node("Gateway", .{ .name = "api", .protocol = "shell" }, &.{}), .invalid_attribute);

    try std.testing.expectEqualDeep(h.value_location, issue.location);

    _ = try h.expectError("api.gateway.rx", h.node("Gateway", .{ .name = "api" }, &.{h.node("Route", .{ .path = "/orders" }, &.{})}), .missing_attribute);
    _ = try h.expectError("api.gateway.rx", h.node("Gateway", .{ .name = "api" }, &.{h.call()}), .unexpected_element);
    _ = try h.expectError("orders.rx", h.node("Gateway", .{ .name = "api" }, &.{}), .unexpected_element);
}

test "gateway supports each declared adapter and rejects invalid HTTP methods" {
    inline for (.{ "http", "grpc", "websocket", "tcp", "mqtt" }) |protocol| {
        try h.expectValid("api.gateway.rx", h.node("Gateway", .{ .name = "api", .protocol = protocol }, &.{}));
    }

    const route = h.node("Route", .{ .method = "post", .path = "/orders", .service = "orders/create" }, &.{});
    const issue = try h.expectError("api.gateway.rx", h.node("Gateway", .{ .name = "api" }, &.{route}), .invalid_attribute);

    try std.testing.expectEqualStrings("method", issue.attribute.?);
}
