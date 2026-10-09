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

    try @import("producing/append.zig").apply(allocator, items, types, first, origin);
}
