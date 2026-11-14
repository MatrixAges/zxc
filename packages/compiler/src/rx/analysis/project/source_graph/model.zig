const std = @import("std");
const rx = @import("rx");
const project = @import("frontend").project;
const Diagnostic = @import("../../call/target.zig").Diagnostic;

pub const Source = union(enum) { zx: usize, rx: usize, store: usize };
pub const Target = union(enum) { source: usize, compiled: project.compiled.Target, native: []const u8 };
pub const Reference = enum(u8) { dependency, call, type_import, store };
pub const Edge = struct { target: Target, location: rx.ast.Location, reference: Reference = .dependency };
pub const Module = struct { path: []const u8, source: Source, dependencies: []const Edge = &.{} };

pub const References = struct {
    remaining: []const Edge,
    pub fn next(self: *References, reference: Reference) *const Edge {
        while (self.remaining.len != 0) {
            const edge = &self.remaining[0];

            self.remaining = self.remaining[1..];

            if (edge.reference == reference) return edge;
        }

        unreachable;
    }
};

pub const Schedule = struct {
    order: []const usize,
    /// Exclusive end of each consecutive run of equal dependency depth.
    batch_ends: []const usize,
};

pub const Scheduled = union(enum) { schedule: Schedule, diagnostic: Diagnostic };

pub const Adjacency = struct {
    starts: []u64,
    ends: []u64,
    targets: []const u64 = &.{},
};

pub const Graph = struct {
    modules: []const Module,
    order: []const usize,
    batch_ends: []const usize,
    entry: usize,
    additional_roots: []const usize = &.{},
};

pub const Value = union(enum) { graph: Graph, diagnostic: Diagnostic };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: Value,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn cycle(module: Module, edge: Edge) Scheduled {
    return .{ .diagnostic = .{
        .path = module.path,
        .location = edge.location,
        .code = "module",
        .message = "source module dependencies must be acyclic across RX and ZX, including unused imports",
    } };
}
