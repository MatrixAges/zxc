const std = @import("std");
const rx = @import("rx");
const h = @import("helpers.zig");

test "ordinary RX tags compose directly inside a typed Module" {
    const branch = h.node("Switch", .{ .on = "$ctx.status" }, &.{
        h.node("Case", .{ .value = "blocked" }, &.{h.node("Return", .{ .value = "false" }, &.{})}),
        h.node("Default", .{}, &.{h.node("Task", .{ .name = "fallback" }, &.{h.call()})}),
    });

    const root = h.module(&.{
        h.node("Store", .{ .from = "scheduler", .as = "jobs" }, &.{}),
        h.node("Task", .{ .name = "validate" }, &.{branch}),
        h.node("Parallel", .{}, &.{ h.call(), h.node("Task", .{ .name = "query" }, &.{h.call()}) }),
        h.node("Emit", .{ .event = "order.created", .value = "$ctx.create_order" }, &.{}),
        h.node("Call", .{ .@"fn" = "advance", .in = "$in", .setter = "[store.jobs.dispatcher]" }, &.{}),
    });

    var result = try rx.validate(std.testing.allocator, "orders.rx", root);

    defer result.deinit();

    try std.testing.expect(result.value == .data);

    const data = result.value.data.module;

    try std.testing.expectEqualStrings("Input", data.attributes.in.?);
    try std.testing.expectEqualStrings("jobs", data.children[0].store.attributes.as.?);
    try std.testing.expectEqualStrings("$ctx.status", data.children[1].task.children[0].@"switch".attributes.on);
    try std.testing.expectEqualStrings("[store.jobs.dispatcher]", data.children[4].call.attributes.setter.?);
}

test "nesting table rejects misplaced flow elements" {
    const invalid = [_]rx.ast.Node{
        h.module(&.{h.node("Task", .{ .name = "outer" }, &.{h.node("Task", .{ .name = "inner" }, &.{h.call()})})}),
        h.module(&.{h.node("Task", .{ .name = "outer" }, &.{h.node("Store", .{ .from = "jobs" }, &.{})})}),
        h.module(&.{h.node("Parallel", .{}, &.{h.node("Return", .{ .value = "true" }, &.{})})}),
        h.module(&.{h.node("Switch", .{ .on = "$in" }, &.{h.call()})}),
        h.module(&.{h.node("Case", .{ .value = "a" }, &.{h.call()})}),
        h.module(&.{h.module(&.{h.call()})}),
    };

    for (invalid) |root| _ = try h.expectError("orders.rx", root, .unexpected_element);
}

test "Module has no custom name or Pipeline layer" {
    _ = try h.expectError("orders.rx", h.node("Module", .{ .name = "orders" }, &.{}), .unknown_attribute);
    _ = try h.expectError("orders.rx", h.module(&.{h.node("Pipeline", .{ .name = "run" }, &.{h.call()})}), .unexpected_element);
}

test "required unknown duplicate and empty attributes are rejected" {
    const missing = h.node("Call", .{ .@"fn" = "save" }, &.{});
    const issue = try h.expectError("orders.rx", h.module(&.{missing}), .missing_attribute);

    try std.testing.expectEqualStrings("in", issue.attribute.?);
    try std.testing.expectEqualDeep(h.location, issue.location);

    const unknown = h.node("Call", .{ .@"fn" = "save", .in = "$in", .sql = "select" }, &.{});
    _ = try h.expectError("orders.rx", h.module(&.{unknown}), .unknown_attribute);

    var duplicate = h.call();
    duplicate.attributes = &.{ duplicate.attributes[0], duplicate.attributes[0] };
    _ = try h.expectError("orders.rx", h.module(&.{duplicate}), .duplicate_attribute);
    const empty = h.node("Call", .{ .@"fn" = " ", .in = "$in" }, &.{});
    const empty_issue = try h.expectError("orders.rx", h.module(&.{empty}), .context);

    try std.testing.expectEqualDeep(h.value_location, empty_issue.location);
}

test "switch case values and default branches are unique" {
    const case = h.node("Case", .{ .value = "a" }, &.{h.call()});
    const fallback = h.node("Default", .{}, &.{h.call()});
    _ = try h.expectError("orders.rx", h.module(&.{h.node("Switch", .{ .on = "$in" }, &.{ case, case })}), .context);
    _ = try h.expectError("orders.rx", h.module(&.{h.node("Switch", .{ .on = "$in" }, &.{ fallback, fallback })}), .context);
}

test "module rejects duplicate Store namespaces" {
    _ = try h.expectError("orders.rx", h.module(&.{
        h.node("Store", .{ .from = "jobs" }, &.{}),
        h.node("Store", .{ .from = "backup", .as = "jobs" }, &.{}),
    }), .context);
}

test "empty execution containers and non whitespace text are rejected" {
    _ = try h.expectError("orders.rx", h.module(&.{h.node("Task", .{ .name = "empty" }, &.{})}), .child_count);

    var call = h.call();
    call.text = &.{.{ .value = "execute()", .location = h.value_location }};

    const issue = try h.expectError("orders.rx", h.module(&.{call}), .unexpected_text);

    try std.testing.expectEqualDeep(h.value_location, issue.location);
}

test "deep nested switches are not limited to a fixed schema expansion" {
    var nodes: [47]rx.ast.Node = undefined;

    nodes[0] = h.call();

    for (1..nodes.len) |index| {
        nodes[index] = if (index % 2 == 1)
            h.node("Case", .{ .value = "a" }, nodes[index - 1 .. index])

        else
            h.node("Switch", .{ .on = "$in" }, nodes[index - 1 .. index]);
    }

    try h.expectValid("orders.rx", h.module(nodes[46..47]));
}

test "leaf elements reject children and preserve the extra child position" {
    var call = h.call();

    call.children = &.{h.call()};

    const issue = try h.expectError("orders.rx", h.module(&.{call}), .child_count);

    try std.testing.expectEqualDeep(h.location, issue.location);
    try std.testing.expectEqual(@as(usize, 0), issue.child_count.?.max);
    try std.testing.expectEqual(@as(usize, 1), issue.child_count.?.actual);
}
