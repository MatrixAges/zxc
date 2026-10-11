//! The error set of every function at once. A function's set is what its own body raises joined with the sets of the
//! functions it calls, so the sets are joined per strongly connected component of the call graph, callees first
//! (Tarjan's algorithm), and each body is visited once instead of once per function that reaches it. The bodies are
//! visited on all cores.
const std = @import("std");
const ir = @import("../ir.zig");
const Effects = @import("../error_effects.zig");

const Own = struct { names: []const []const u8, unknown: bool, callees: []const ir.FunctionId };

const unvisited = std.math.maxInt(u32);

/// Each function's error set, null where unknown, as `Effects.program` reports for its body.
pub fn all(allocator: std.mem.Allocator, types: ir.TypeTable, functions: ir.FunctionTable) std.mem.Allocator.Error![]const ?[]const []const u8 {
    const count = functions.count();
    const own = try allocator.alloc(Own, count);
    const arenas = try allocator.alloc(std.heap.ArenaAllocator, @max(@min(std.Thread.getCpuCount() catch 1, count), 1));

    for (arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    defer {
        for (arenas) |*arena| arena.deinit();

        allocator.free(arenas);
    }

    try visitAll(arenas, &.{ .types = types, .functions = functions, .own = own });

    const result = try allocator.alloc(?[]const []const u8, count);
    const order = try allocator.alloc(u32, count);
    const low = try allocator.alloc(u32, count);
    const on_stack = try allocator.alloc(bool, count);
    var stack: std.ArrayList(u32) = .empty;
    var frames: std.ArrayList(struct { node: u32, child: u32 }) = .empty;
    var next: u32 = 0;

    defer {
        allocator.free(order);
        allocator.free(low);
        allocator.free(on_stack);
        stack.deinit(allocator);
        frames.deinit(allocator);
    }

    @memset(order, unvisited);
    @memset(on_stack, false);

    for (0..count) |root| {
        if (order[root] != unvisited) continue;

        try enter(allocator, &frames, &stack, order, low, on_stack, &next, @intCast(root));

        while (frames.items.len != 0) {
            const top = frames.items.len - 1;
            const node = frames.items[top].node;
            const callees = own[node].callees;

            if (frames.items[top].child < callees.len) {
                const target = @backingInt(callees[frames.items[top].child]);

                frames.items[top].child += 1;

                if (order[target] == unvisited) {
                    try enter(allocator, &frames, &stack, order, low, on_stack, &next, target);
                } else if (on_stack[target]) low[node] = @min(low[node], order[target]);

                continue;
            }

            _ = frames.pop();

            if (frames.items.len != 0) {
                const parent = frames.items[frames.items.len - 1].node;

                low[parent] = @min(low[parent], low[node]);
            }

            if (low[node] != order[node]) continue;

            const start = std.mem.lastIndexOfScalar(u32, stack.items, node).?;
            const members = stack.items[start..];
            const joined = try join(allocator, own, result, on_stack, members);

            for (members) |member| {
                result[member] = joined;
                on_stack[member] = false;
            }

            stack.shrinkRetainingCapacity(start);
        }
    }

    return result;
}

const Visits = struct {
    types: ir.TypeTable,
    functions: ir.FunctionTable,
    own: []Own,
    next: std.atomic.Value(usize) = .init(0),
    failed: std.atomic.Value(bool) = .init(false),
    fn run(self: *Visits, arena: *std.heap.ArenaAllocator) void {
        while (!self.failed.load(.monotonic)) {
            const index = self.next.fetchAdd(1, .monotonic);

            if (index >= self.own.len) return;

            self.own[index] = effects(arena.allocator(), self.types, self.functions, index) catch {
                self.failed.store(true, .monotonic);

                return;
            };
        }
    }
};

/// Each function's own effects, one thread per arena; the effects live in the arenas.
fn visitAll(arenas: []std.heap.ArenaAllocator, template: *const Visits) std.mem.Allocator.Error!void {
    var visits = template.*;
    var threads: [64]std.Thread = undefined;
    var started: usize = 0;

    for (arenas[1..@min(arenas.len, threads.len)]) |*arena| {
        threads[started] = std.Thread.spawn(.{}, Visits.run, .{ &visits, arena }) catch break;
        started += 1;
    }

    visits.run(&arenas[0]);

    for (threads[0..started]) |thread| thread.join();
    if (visits.failed.load(.monotonic)) return error.OutOfMemory;
}

fn enter(allocator: std.mem.Allocator, frames: anytype, stack: *std.ArrayList(u32), order: []u32, low: []u32, on_stack: []bool, next: *u32, node: u32) std.mem.Allocator.Error!void {
    order[node] = next.*;
    low[node] = next.*;
    next.* += 1;
    on_stack[node] = true;

    try stack.append(allocator, node);
    try frames.append(allocator, .{ .node = node, .child = 0 });
}

/// What a function raises itself, and the source functions it calls.
fn effects(allocator: std.mem.Allocator, types: ir.TypeTable, functions: ir.FunctionTable, index: usize) std.mem.Allocator.Error!Own {
    var callees: std.ArrayList(ir.FunctionId) = .empty;
    var self = Effects{ .allocator = allocator, .types = types, .functions = functions, .callees = &callees };

    defer self.deinit();

    const function = functions.at(index);

    if (function.external != null) try self.call(@fromBackingInt(@intCast(index))) else try self.raises(function);

    const unknown = self.unknown;

    self.unknown = false;

    return .{ .names = (try self.finish()).?, .unknown = unknown, .callees = try callees.toOwnedSlice(allocator) };
}

/// The set of one component: its members' own effects and the sets of the components they call, all already joined.
fn join(allocator: std.mem.Allocator, own: []const Own, result: []const ?[]const []const u8, on_stack: []const bool, members: []const u32) std.mem.Allocator.Error!?[]const []const u8 {
    var self = Effects{ .allocator = allocator, .types = .{}, .functions = .{} };

    defer self.deinit();

    for (members) |member| {
        if (own[member].unknown) self.unknown = true;

        for (own[member].names) |name| try self.add(name);

        for (own[member].callees) |callee| {
            const index = @backingInt(callee);

            if (on_stack[index]) continue;

            if (result[index]) |names| {
                for (names) |name| try self.add(name);
            } else self.unknown = true;
        }
    }

    return self.finish();
}
