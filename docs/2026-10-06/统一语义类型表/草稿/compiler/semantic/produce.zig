const std = @import("std");
const ir = @import("zx").ir;
const data = @import("nominal_data");

pub fn append(allocator: std.mem.Allocator, items: *data.Storage, types: ir.TypeTable, first: usize, origin: data.Origin) std.mem.Allocator.Error!void {
    if (!@import("parser_options").generated_parser) {
        for (first..types.count()) |index| {
            const name = types.at(index).nominalName() orelse continue;

            try items.append(allocator, .{
                .type_id = @fromBackingInt(@intCast(index)),
                .origin = try data.copy(allocator, origin),
                .name = name,
            });
        }

        return;
    }

    std.debug.assert(first <= types.count());

    const generated = @import("generated_origin_production");
    const writer = @import("origin_writer");
    const Input = @typeInfo(generated.Input).pointer.child;
    const view = writer.View{ .allocator = allocator, .items = items, .labels = types.labels, .origin = origin };
    const input: Input = .{ .kinds = types.kinds, .first = first, .writer = @ptrCast(&view) };
    var storage: [0]u8 = undefined;
    var fixed = std.heap.FixedBufferAllocator.init(&storage);
    var arena = std.heap.ArenaAllocator.init(fixed.allocator());

    defer arena.deinit();

    generated.execute(&arena, &input) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        else => unreachable,
    };
}
