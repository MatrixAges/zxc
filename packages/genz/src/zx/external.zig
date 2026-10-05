const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, function: ir.Function, index: usize) Lower.Error!node.Declaration {
    const implementation = function.external.?;
    self.uses_allocator = false;

    var callee = try self.builder.identifier(self.native_names[@backingInt(implementation.module)]);

    for (implementation.member) |part| callee = try self.field(callee, part);

    const allocator = try self.builder.identifier("allocator");
    var arguments: std.ArrayList(*const node.Expression) = .empty;

    if (implementation.allocator_argument) try arguments.append(self.allocator, allocator);
    if (implementation.io_argument) try arguments.append(self.allocator, try self.builder.identifier("io"));
    if (implementation.process_argument) try arguments.append(self.allocator, try self.builder.identifier("process"));

    const input_type = self.program.typeOf(function.input_type);
    const no_input = (implementation.expand_tuple and input_type.tuple.len == 0) or (input_type == .scalar and input_type.scalar == .void);

    if (implementation.expand_tuple) {
        for (input_type.tuple, 0..) |_, position| {
            const argument = try self.field(try self.builder.identifier("in"), try std.fmt.allocPrint(self.allocator, "{d}", .{position}));

            try arguments.append(self.allocator, argument);
        }
    } else if (!no_input) {
        const argument = try self.builder.identifier("in");

        try arguments.append(self.allocator, argument);
    }

    var body: std.ArrayList(node.Statement) = .empty;

    if (no_input) try body.append(self.allocator, .{ .discard = try self.builder.identifier("in") });

    const returned = try self.call(callee, arguments.items, implementation.fallible);

    try body.append(self.allocator, .{ .constant = .{ .name = "native_result", .value = returned } });

    const result = try self.builder.identifier("native_result");

    if (!self.uses_allocator) try body.append(self.allocator, .{ .discard = allocator });
    try body.append(self.allocator, .{ .result = result });

    const parameters = try self.allocator.alloc(node.Field, 2 + @as(usize, @intFromBool(implementation.io_argument)) + @as(usize, @intFromBool(implementation.process_argument)));

    parameters[0] = .{ .name = "allocator", .value = try @import("intrinsics.zig").standardField(self, &.{ "mem", "Allocator" }) };
    parameters[1] = .{ .name = "in", .value = self.types[@backingInt(function.input_type)] };

    if (implementation.io_argument) parameters[2] = .{ .name = "io", .value = try @import("intrinsics.zig").standardField(self, &.{"Io"}) };
    if (implementation.process_argument) parameters[parameters.len - 1] = .{ .name = "process", .value = try @import("intrinsics.zig").standardField(self, &.{ "process", "Init", "Minimal" }) };

    return .{ .function = .{ .name = try std.fmt.allocPrint(self.allocator, "function_{d}", .{index}), .parameters = parameters, .return_type = try self.builder.expression(.{ .error_union = .{ .payload = self.types[@backingInt(function.output_type)], .errors = if (implementation.fallible) implementation.errors else &.{} } }), .body = try body.toOwnedSlice(self.allocator) } };
}
