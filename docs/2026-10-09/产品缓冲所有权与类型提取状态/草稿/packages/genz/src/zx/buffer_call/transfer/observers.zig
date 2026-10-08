const std = @import("std");
const ir = @import("zx").ir;
const Graph = @import("../../iteration_buffer/ownership/graph.zig");
const Selection = @import("selection.zig");
const Self = @This();

allocator: std.mem.Allocator,
program: ir.Program,
graph: Graph,
selection: Selection,
pub fn valid(self: Self, id: ir.ExprId, path: []const u32) std.mem.Allocator.Error!bool {
    const index = @backingInt(id);

    if (id == self.selection.anchor) return self.graph.regions[index] == 0 and self.graph.uses[index] == 1;

    for (path[0..@min(path.len, self.selection.path.len)], self.selection.path[0..@min(path.len, self.selection.path.len)]) |left, right| {
        if (left != right) return true;
    }

    if (path.len >= self.selection.path.len) return false;
    if (self.graph.regions[index] != 0 or self.graph.uses[index] == 255) return false;

    var uses: usize = 0;

    for (0..self.program.expressions.count()) |parent| {
        const field = switch (self.program.expressions.at(parent).value) {
            .field, .tuple_field => |field| field,
            else => continue,
        };

        if (field.target != id) continue;

        const child = try self.allocator.alloc(u32, path.len + 1);

        @memcpy(child[0..path.len], path);

        child[path.len] = field.index;

        if (!try self.valid(@fromBackingInt(@intCast(parent)), child)) return false;

        uses += 1;
    }

    return uses == self.graph.uses[index];
}
