const std = @import("std");
const rx = @import("rx");
const h = @import("helpers.zig");

test {
    _ = @import("flow_test.zig");
    _ = @import("gateway_test.zig");
    _ = @import("store_test.zig");
    _ = @import("modules_test.zig");
    _ = @import("dependency_graph_test.zig");
}

test "file suffix selects the root schema and reserves app.rx" {
    const module = h.module(&.{});

    try h.expectValid("src/orders.rx", module);

    _ = try h.expectError("src/app.rx", module, .context);
    _ = try h.expectError("orders.zx", module, .context);

    const gateway_issue = try h.expectError("orders.gateway.rx", module, .unexpected_element);
    const store_issue = try h.expectError("orders.store.rx", module, .unexpected_element);

    try std.testing.expectEqualStrings("Gateway", gateway_issue.expected.?);
    try std.testing.expectEqualStrings("Store", store_issue.expected.?);
}

test "root diagnostics preserve source position" {
    var invalid = h.node("Unknown", .{}, &.{});

    invalid.location = .{ .offset = 119, .line = 12, .column = 5 };

    const issue = try h.expectError("orders.rx", invalid, .unexpected_element);

    try std.testing.expectEqualDeep(invalid.location, issue.location);
    try std.testing.expectEqualStrings("Module", issue.expected.?);
}

test "out of memory is propagated without leaking partial data" {
    const root = h.module(&.{h.call()});

    try std.testing.checkAllAllocationFailures(std.testing.allocator, struct {
        fn run(allocator: std.mem.Allocator, input: rx.ast.Node) !void {
            var result = try rx.validate(allocator, "orders.rx", input);

            defer result.deinit();

            try std.testing.expect(result.value == .data);
        }
    }.run, .{root});
}
