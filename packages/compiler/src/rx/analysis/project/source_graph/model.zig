const std = @import("std");
const rx = @import("rx");
const project = @import("frontend").project;
const Diagnostic = @import("../../call/target.zig").Diagnostic;

pub const Source = union(enum) { zx: usize, rx: usize };
pub const Target = union(enum) { source: usize, compiled: project.compiled.Target, native: []const u8 };
pub const Edge = struct { target: Target, location: rx.ast.Location };
pub const Module = struct { path: []const u8, source: Source, dependencies: []const Edge = &.{} };
pub const Graph = struct { modules: []const Module, order: []const usize, entry: usize };
pub const Value = union(enum) { graph: Graph, diagnostic: Diagnostic };

pub const Result = struct {
    arena: std.heap.ArenaAllocator,
    value: Value,
    pub fn deinit(self: *Result) void {
        self.arena.deinit();

        self.* = undefined;
    }
};
