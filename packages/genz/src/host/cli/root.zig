const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn render(allocator: std.mem.Allocator, stateful: bool) std.mem.Allocator.Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    var declarations: std.ArrayList(node.Declaration) = .empty;
    var body: std.ArrayList(node.Statement) = .empty;
    const memory = builder.allocator;

    for ([_][]const u8{ "std", "application" }) |name| try declarations.append(memory, .{ .constant = .{ .name = name, .value = try builder.builtin(.import, &.{try builder.string(name)}) } });

    if (stateful) {
        try declarations.append(memory, .{ .constant = .{ .name = "State", .value = try builder.builtin(.import, &.{try builder.string("zxc_state")}) } });

        try body.appendSlice(memory, &.{
            .{ .constant = .{ .name = "args", .value = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "init", "minimal", "args", "toSlice" }), &.{try builder.call(try builder.path(&.{ "init", "arena", "allocator" }), &.{})}) }) } },
            .{ .variable = .{ .name = "state", .value = try builder.expression(.{ .object = .{ .type_expr = try builder.identifier("State"), .fields = try memory.dupe(node.Field, &.{.{ .name = "arena", .value = try builder.path(&.{ "init", "arena" }) }}) } }) } },
            .{ .defer_expression = try builder.call(try builder.path(&.{ "state", "deinit" }), &.{}) },
            .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "state", "initialize" }), &.{}) }) },
            .{ .variable = .{ .name = "request", .value = try builder.call(try builder.path(&.{ "state", "request" }), &.{}) } },
            .{ .defer_expression = try builder.call(try builder.path(&.{ "request", "deinit" }), &.{}) },
            .{ .constant = .{ .name = "allocator", .value = try builder.call(try builder.path(&.{ "request", "arena", "allocator" }), &.{}) } },
        });
    } else {
        try body.appendSlice(memory, &.{
            .{ .constant = .{ .name = "allocator", .value = try builder.call(try builder.path(&.{ "init", "arena", "allocator" }), &.{}) } },
            .{ .constant = .{ .name = "args", .value = try builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ "init", "minimal", "args", "toSlice" }), &.{try builder.identifier("allocator")}) }) } },
        });
    }

    try body.append(memory, try @import("input.zig").lower(builder));

    const requires_io = try builder.path(&.{ "application", "requires_io" });
    const with_process = try builder.expression(.{ .conditional = .{ .condition = requires_io, .yes = try execute(builder, stateful, true, true), .no = try execute(builder, stateful, false, true) } });
    const without_process = try builder.expression(.{ .conditional = .{ .condition = requires_io, .yes = try execute(builder, stateful, true, false), .no = try execute(builder, stateful, false, false) } });

    try body.append(memory, .{ .constant = .{ .name = "output", .value = try builder.expression(.{ .conditional = .{ .condition = try builder.path(&.{ "application", "requires_process" }), .yes = with_process, .no = without_process } }) } });
    try body.append(memory, try @import("output.zig").lower(builder));

    try declarations.append(memory, .{ .function = .{
        .name = "main",
        .parameters = try memory.dupe(node.Field, &.{.{ .name = "init", .value = try builder.path(&.{ "std", "process", "Init" }) }}),
        .return_type = try builder.expression(.{ .error_union = .{ .inferred = true, .payload = try builder.expression(.{ .primitive = .void }) } }),
        .body = try body.toOwnedSlice(memory),
        .exported = true,
    } });

    return @import("../../render.zig").render(allocator, declarations.items);
}

fn execute(builder: Builder, stateful: bool, io: bool, process: bool) std.mem.Allocator.Error!*const node.Expression {
    var arguments: std.ArrayList(*const node.Expression) = .empty;

    if (!stateful) try arguments.append(builder.allocator, try builder.path(&.{ "init", "arena" }));
    try arguments.append(builder.allocator, try builder.identifier("input"));
    if (io) try arguments.append(builder.allocator, try builder.path(&.{ "init", "io" }));
    if (process) try arguments.append(builder.allocator, try builder.path(&.{ "init", "minimal" }));

    return builder.expression(.{ .try_value = try builder.call(try builder.path(&.{ if (stateful) "request" else "application", "execute" }), arguments.items) });
}
