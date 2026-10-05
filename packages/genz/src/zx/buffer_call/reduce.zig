const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../lower.zig");

pub const Match = struct { expression: ir.ExprId, lane: usize };

pub fn match(lowering: *Lower, transform: ir.Transform, field: u32) Lower.Error!?Match {
    const expression = lowering.program.expression(transform.body).value;

    if (expression != .call) return null;

    for (lowering.buffer_functions[@intFromEnum(expression.call.function)], 0..) |lane, index| {
        if (lane.rejection != null or lane.output.len != 1 or lane.output[0] != field) continue;
        if (!try projects(lowering.allocator, lowering.program, expression.call.argument, lane.input, transform.parameters[0], field)) continue;

        return .{ .expression = transform.body, .lane = index };
    }

    return null;
}

fn projects(allocator: std.mem.Allocator, program: ir.Program, id: ir.ExprId, path: []const u32, accumulator: ir.SymbolId, field: u32) std.mem.Allocator.Error!bool {
    return switch (program.expression(id).value) {
        .reference => |symbol| symbol == accumulator and path.len == 1 and path[0] == field,
        .field, .tuple_field => |projection| blk: {
            const nested = try allocator.alloc(u32, path.len + 1);

            nested[0] = projection.index;

            @memcpy(nested[1..], path);

            break :blk try projects(allocator, program, projection.target, nested, accumulator, field);
        },
        .object => |object| blk: {
            if (path.len == 0) break :blk false;

            for (object.fields) |item| {
                if (item.index == path[0]) break :blk try projects(allocator, program, item.value, path[1..], accumulator, field);
            }

            break :blk false;
        },
        .tuple => |items| if (path.len != 0 and path[0] < items.len) projects(allocator, program, items[path[0]], path[1..], accumulator, field) else false,
        .conditional => |value| try projects(allocator, program, value.yes, path, accumulator, field) and try projects(allocator, program, value.no, path, accumulator, field),
        else => false,
    };
}
