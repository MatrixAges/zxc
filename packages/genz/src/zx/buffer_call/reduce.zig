const std = @import("std");
const ir = @import("zx").ir;
const Lower = @import("../lower.zig");

pub const Match = struct { expression: ir.ExprId, lane: usize };

pub fn match(lowering: *Lower, transform: ir.Transform, path: []const u32) Lower.Error!?Match {
    const expression = lowering.program.expression(transform.body).value;

    if (expression != .call) return null;

    for (lowering.buffer_functions[@intFromEnum(expression.call.function)], 0..) |lane, index| {
        if (lane.rejection != null or !std.mem.eql(u32, lane.output, path)) continue;
        if (!try projects(lowering.allocator, lowering.program, expression.call.argument, lane.input, transform.parameters[0], path)) continue;

        return .{ .expression = transform.body, .lane = index };
    }

    return null;
}

fn projects(allocator: std.mem.Allocator, program: ir.Program, id: ir.ExprId, path: []const u32, accumulator: ir.SymbolId, output: []const u32) std.mem.Allocator.Error!bool {
    return switch (program.expression(id).value) {
        .reference => |symbol| symbol == accumulator and std.mem.eql(u32, path, output),
        .field, .tuple_field => |projection| blk: {
            const nested = try allocator.alloc(u32, path.len + 1);

            nested[0] = projection.index;

            @memcpy(nested[1..], path);

            break :blk try projects(allocator, program, projection.target, nested, accumulator, output);
        },
        .object => |object| blk: {
            if (path.len == 0) break :blk false;

            for (object.fields) |item| {
                if (item.index == path[0]) break :blk try projects(allocator, program, item.value, path[1..], accumulator, output);
            }

            break :blk false;
        },
        .tuple => |items| if (path.len != 0 and path[0] < items.len) projects(allocator, program, items[path[0]], path[1..], accumulator, output) else false,
        .conditional => |value| try projects(allocator, program, value.yes, path, accumulator, output) and try projects(allocator, program, value.no, path, accumulator, output),
        else => false,
    };
}
