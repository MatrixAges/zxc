const std = @import("std");
const ir = @import("zx").ir;
const flow = @import("flow.zig");
const Trace = @import("trace.zig");
const Reach = @import("reach.zig");
const Self = @This();
const Error = std.mem.Allocator.Error;
pub const Candidate = struct { lane: usize, origin: []const u32 };

trace: *Trace,
arena: std.heap.ArenaAllocator,
versions: std.heap.ArenaAllocator,
reach: Reach,
rows: []?[]const Reach.Index,
leaves: std.AutoHashMapUnmanaged(ir.TypeId, []const []const u32) = .empty,
candidates: std.AutoHashMapUnmanaged(ir.ExprId, []const Candidate) = .empty,
counts: []?@import("reads.zig").Multiplicity,
/// Shared audit facts of all lanes of one function: lane i owns origin i of one origin-set analysis.
pub fn init(self: *Self, backing: std.mem.Allocator, trace: *Trace, lanes: []const flow.Lane) Error!void {
    self.* = .{ .trace = trace, .arena = std.heap.ArenaAllocator.init(backing), .versions = std.heap.ArenaAllocator.init(backing), .reach = undefined, .rows = &.{}, .counts = &.{} };

    errdefer self.deinit();

    const allocator = self.arena.allocator();
    const count = trace.function.expressions.count();
    const origins = try allocator.alloc([]const u32, lanes.len);
    const loops = try allocator.alloc([]const flow.Iteration, lanes.len);

    for (lanes, origins, loops) |lane, *origin, *selected| {
        origin.* = lane.input;
        selected.* = lane.iterations;
    }

    self.reach = try Reach.init(allocator, trace, origins, loops);
    self.rows = try allocator.alloc(?[]const Reach.Index, count);
    self.counts = try allocator.alloc(?@import("reads.zig").Multiplicity, count);

    @memset(self.rows, null);
}

pub fn deinit(self: *Self) void {
    self.versions.deinit();
    self.arena.deinit();
}

pub fn reads(self: *Self, lane: usize) @import("reads.zig") {
    @memset(self.counts, null);

    return .{ .batch = self, .origin = lane };
}

/// Reach nodes of every leaf path of one expression, independent of the lane origin.
pub fn paths(self: *Self, id: ir.ExprId) Error![]const Reach.Index {
    const cached = &self.rows[@backingInt(id)];

    if (cached.*) |found| return found;

    const leaves = try self.leavesOf(self.trace.function.expressions.at(@backingInt(id)).type_id);
    const found = try self.arena.allocator().alloc(Reach.Index, leaves.len);

    for (leaves, found) |path, *index| index.* = try self.reach.visit(id, path);

    self.rows[@backingInt(id)] = found;

    return found;
}

/// Callee lanes accepted for one call together with the caller origin of their input.
pub fn calls(self: *Self, id: ir.ExprId, call: @FieldType(@FieldType(ir.Expression, "value"), "call")) Error![]const Candidate {
    if (self.candidates.get(id)) |found| return found;

    const allocator = self.arena.allocator();
    var found: std.ArrayList(Candidate) = .empty;

    for (self.trace.summaries[@backingInt(call.function)], 0..) |callee, lane| {
        if (callee.rejection != null) continue;

        const origin = try self.trace.trace(call.argument, callee.input) orelse continue;

        try found.append(allocator, .{ .lane = lane, .origin = origin });
    }

    try self.candidates.put(allocator, id, found.items);

    return found.items;
}

pub fn versionsAllocator(self: *Self) std.mem.Allocator {
    _ = self.versions.reset(.retain_capacity);

    return self.versions.allocator();
}

fn leavesOf(self: *Self, type_id: ir.TypeId) Error![]const []const u32 {
    if (self.leaves.get(type_id)) |found| return found;

    const allocator = self.arena.allocator();
    var found: std.ArrayList([]const u32) = .empty;

    try flow.leaves(allocator, self.trace.program, type_id, &.{}, true, &found);
    try self.leaves.put(allocator, type_id, found.items);

    return found.items;
}
