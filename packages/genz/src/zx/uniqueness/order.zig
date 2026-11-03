const std = @import("std");
const ir = @import("zx").ir;
const Seed = @import("order/seed.zig");
const generated_analysis = @import("genz_options").generated_analysis;
const Self = @This();
pub const none = std.math.maxInt(u32);
pub const Role = Seed.Role;
pub const Edge = Seed.Edge;
pub const Def = Seed.Def;

const Generated = if (generated_analysis) @import("order/generated.zig") else void;

nodes: if (generated_analysis) Generated.Nodes else void,
regions: if (generated_analysis) Generated.Regions else void,
edges: if (generated_analysis) Generated.Edges else void,
definitions: if (generated_analysis) Generated.Definitions else void,
def_loop: if (generated_analysis) []const u32 else void,
results: []const ir.ExprId,
repeated: []const ir.ExprId,
repeated_parent: []const u32,
concurrent: []const bool,
seed: if (generated_analysis) void else Seed,
pub fn create(allocator: std.mem.Allocator, workspace: std.mem.Allocator, symbols: ir.SymbolTable, expressions: ir.ExpressionTable, body: ir.Block) std.mem.Allocator.Error!Self {
    if (generated_analysis) return Generated.build(allocator, workspace, symbols, expressions, body);

    return @import("order/initial.zig").build(allocator, symbols, expressions, body);
}

pub fn apart(self: *const Self, left: u32, left_time: u32, right: u32, right_time: u32) bool {
    if (generated_analysis) return Generated.apart(&self.regions, left, left_time, right, right_time);

    return self.seed.apart(left, left_time, right, right_time);
}

pub fn crossesConcurrent(self: *const Self, inner: u32, outer: u32) bool {
    if (generated_analysis) return Generated.crossesConcurrent(self.repeated_parent, self.concurrent, inner, outer);

    return self.seed.crossesConcurrent(inner, outer);
}

pub fn definition(self: *const Self, symbol: ir.SymbolId) Def {
    if (!generated_analysis) return self.seed.defs[@backingInt(symbol)];

    const index = @backingInt(symbol);
    const value: ir.ExprId = @fromBackingInt(self.definitions.value[index]);

    return switch (self.definitions.kind[index]) {
        .Unknown => .unknown,
        .Input => .input,
        .Value => .{ .value = value },
        .Part => .{ .part = .{ .value = value, .index = self.definitions.index[index] } },
        .Carried => .{ .carried = value },
        .Condition => .{ .condition = value },
        .Element => .element,
    };
}

pub fn edge(self: *const Self, index: usize) Edge {
    if (!generated_analysis) return self.seed.edges.items[index];

    return .{ .parent = self.edges.parent[index], .child = @fromBackingInt(self.edges.child[index]), .role = @fromBackingInt(@intCast(@backingInt(self.edges.role[index]))), .index = self.edges.index[index], .region = self.edges.region[index] };
}

pub fn edgeCount(self: *const Self) usize {
    return if (generated_analysis) self.edges.parent.len else self.seed.edges.items.len;
}

pub fn edgeChild(self: *const Self, index: usize) u32 {
    return if (generated_analysis) self.edges.child[index] else @backingInt(self.seed.edges.items[index].child);
}

pub fn timeAt(self: *const Self, index: usize) u32 {
    return if (generated_analysis) self.nodes.time[index] else self.seed.time[index];
}

pub fn finishAt(self: *const Self, index: usize) u32 {
    return if (generated_analysis) self.nodes.finish[index] else self.seed.finish[index];
}

pub fn loopAt(self: *const Self, index: usize) u32 {
    return if (generated_analysis) self.nodes.repeated[index] else self.seed.loop[index];
}

pub fn defLoopAt(self: *const Self, index: usize) u32 {
    return if (generated_analysis) self.def_loop[index] else self.seed.def_loop[index];
}

pub fn regionDepth(self: *const Self, index: u32) u32 {
    return if (generated_analysis) self.regions.depth[index] else self.seed.regions.items[index].depth;
}

pub fn regionParent(self: *const Self, index: u32) u32 {
    return if (generated_analysis) self.regions.parent[index] else self.seed.regions.items[index].parent;
}
