const std = @import("std");
const ir = @import("zx").ir;

pub const Plan = struct { type_ids: []const u32, numbers: []const u32 };

pub fn create(allocator: std.mem.Allocator, types: ir.TypeTable, input: ir.TypeId, output: ir.TypeId) std.mem.Allocator.Error!Plan {
    if (@import("genz_options").generated_analysis) {
        const generated = @import("generated_shape_plan");
        const Input = std.meta.Child(generated.Input);

        const args: Input = .{
            .kinds = types.kinds,
            .first = types.first,
            .second = types.second,
            .children = types.children,
            .field_types = types.field_types,
            .input = @backingInt(input),
            .output = @backingInt(output),
        };

        const result = @import("zx").columns.invoke(generated.executeValue, allocator, &args) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            else => unreachable,
        };

        return .{ .type_ids = result.type_ids, .numbers = result.numbers };
    }

    return seed(allocator, types, input, output);
}

fn seed(allocator: std.mem.Allocator, types: ir.TypeTable, input: ir.TypeId, output: ir.TypeId) std.mem.Allocator.Error!Plan {
    const numbers = try allocator.alloc(u32, types.count());

    errdefer allocator.free(numbers);
    @memset(numbers, std.math.maxInt(u32));

    var order: std.ArrayList(u32) = .empty;

    errdefer order.deinit(allocator);

    const Frame = struct { node: u32, child: usize = 0 };
    var frames: std.ArrayList(Frame) = .empty;

    defer frames.deinit(allocator);

    for ([_]ir.TypeId{ input, output }) |root| {
        if (numbers[@backingInt(root)] != std.math.maxInt(u32)) continue;
        try frames.append(allocator, .{ .node = @backingInt(root) });

        while (frames.items.len != 0) {
            const top = &frames.items[frames.items.len - 1];
            const node = top.node;
            const value = types.at(node);

            const count: usize = switch (value) {
                .optional, .list => 1,
                .object => |fields| fields.len,
                .tuple => |items| items.len,
                else => 0,
            };

            if (top.child < count) {
                const child = switch (value) {
                    .optional, .list => |child| child,
                    .object => |fields| fields.at(top.child).type_id,
                    .tuple => |items| items.at(top.child),
                    else => unreachable,
                };

                top.child += 1;

                if (numbers[@backingInt(child)] == std.math.maxInt(u32)) try frames.append(allocator, .{ .node = @backingInt(child) });
            } else {
                numbers[node] = @intCast(order.items.len);

                try order.append(allocator, node);

                frames.items.len -= 1;
            }
        }
    }

    return .{ .type_ids = try order.toOwnedSlice(allocator), .numbers = numbers };
}
