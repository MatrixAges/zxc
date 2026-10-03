const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");

pub fn lower(self: *Lower, function: ir.Function, index: usize) Lower.Error!node.Declaration {
    const implementation = function.external.?;
    self.uses_allocator = false;

    var callee = try self.builder.identifier(self.native_names[@intFromEnum(implementation.module)]);

    for (implementation.member) |part| callee = try self.field(callee, part);

    const allocator = try self.builder.identifier("allocator");
    var arguments: std.ArrayList(*const node.Expression) = .empty;

    if (implementation.allocator_argument) try arguments.append(self.allocator, allocator);

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

    const parameters = try self.allocator.alloc(node.Field, 2);

    parameters[0] = .{ .name = "allocator", .value = try @import("intrinsics.zig").standardField(self, &.{ "mem", "Allocator" }) };
    parameters[1] = .{ .name = "in", .value = self.types[@intFromEnum(function.input_type)] };

    return .{ .function = .{ .name = try std.fmt.allocPrint(self.allocator, "function_{d}", .{index}), .parameters = parameters, .return_type = try self.builder.expression(.{ .error_union = self.types[@intFromEnum(function.output_type)] }), .body = try body.toOwnedSlice(self.allocator) } };
}
