const std = @import("std");
const ir = @import("zx").ir;
const node = @import("genz").node;
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, function: ir.Function, index: usize) Lower.Error!node.Declaration {
    const implementation = function.external.?;
    var callee = try self.builtin(.import, &.{try self.builder.string(implementation.module)});
    var parts = std.mem.splitScalar(u8, implementation.member, '.');

    while (parts.next()) |part| callee = try self.field(callee, part);

    const allocator = try self.builder.identifier("allocator");
    var arguments: std.ArrayList(*const node.Expression) = .empty;

    if (implementation.allocator_argument) try arguments.append(self.allocator, allocator);

    const input_type = self.program.typeOf(function.input_type);
    const no_input = (implementation.expand_tuple and input_type.tuple.len == 0) or (input_type == .scalar and input_type.scalar == .void);

    if (implementation.expand_tuple) {
        for (input_type.tuple, 0..) |_, position| {
            const argument = try self.field(try self.builder.identifier("in"), try std.fmt.allocPrint(self.allocator, "{d}", .{position}));

            try arguments.append(self.allocator, try self.runtimeCall("nativeArgument", &.{ callee, try self.builder.integer(position + @intFromBool(implementation.allocator_argument)), allocator, argument }, true));
        }
    } else if (!no_input) {
        try arguments.append(self.allocator, try self.runtimeCall("nativeArgument", &.{ callee, try self.builder.integer(@intFromBool(implementation.allocator_argument)), allocator, try self.builder.identifier("in") }, true));
    }

    var body: std.ArrayList(node.Statement) = .empty;

    if (no_input) try body.append(self.allocator, .{ .discard = try self.builder.identifier("in") });

    const returned = try self.call(callee, arguments.items, implementation.fallible);
    const converted = try self.runtimeCall("nativeResult", &.{ self.types[@intFromEnum(function.output_type)], allocator, returned }, true);

    try body.append(self.allocator, .{ .result = converted });

    const parameters = try self.allocator.alloc(node.Field, 2);

    parameters[0] = .{ .name = "allocator", .value = try self.field(try self.builder.identifier("runtime"), "Allocator") };
    parameters[1] = .{ .name = "in", .value = self.types[@intFromEnum(function.input_type)] };

    return .{ .function = .{ .name = try std.fmt.allocPrint(self.allocator, "function_{d}", .{index}), .parameters = parameters, .return_type = try self.builder.expression(.{ .error_union = self.types[@intFromEnum(function.output_type)] }), .body = try body.toOwnedSlice(self.allocator) } };
}
