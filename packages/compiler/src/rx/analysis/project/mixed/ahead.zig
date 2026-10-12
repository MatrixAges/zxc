//! Analyzes the ZX bodies of one run of the dependency order on all cores before the run is linked. Modules of one depth
//! depend on none of each other, so each body reads the shared tables as the run found them, and linking still follows
//! the order: the type merge maps a type a body made to the same type an earlier module of the run added. A body this
//! skips, whose analysis fails, or whose tables changed in ways the link cannot account for is analyzed at its turn.
const std = @import("std");
const frontend = @import("frontend");
const State = @import("state.zig");
const Reuse = @import("reuse.zig");
const Zx = @import("zx.zig");
const Self = @This();

arenas: []std.heap.ArenaAllocator,
items: std.ArrayList(Item) = .empty,
/// The analysis of each module of the current run, by module.
results: []?Zx.Analyzed,
const Item = struct { prepared: Zx.Prepared, outcome: ?Zx.Outcome = null };

pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    const arenas = try allocator.alloc(std.heap.ArenaAllocator, @import("zx").parallel.width());

    for (arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    const results = try allocator.alloc(?Zx.Analyzed, count);

    @memset(results, null);

    return .{ .arenas = arenas, .results = results };
}

pub fn deinit(self: *Self) void {
    for (self.arenas) |*arena| arena.deinit();
}

/// Analyzes the bodies of a run's `modules` that will not be reused; a run of one module is left to its turn.
pub fn analyze(self: *Self, state: *State, cache: *frontend.project.ParseCache, sources: []const frontend.project.Source, reuse: *const Reuse, modules: []const usize) std.mem.Allocator.Error!void {
    for (self.items.items) |item| self.results[item.prepared.index] = null;
    for (self.arenas) |*arena| _ = arena.reset(.retain_capacity);

    self.items.clearRetainingCapacity();

    if (modules.len < 2) return;

    for (modules) |index| {
        if (!eligible(state, reuse, index)) continue;

        const issue = state.issue;

        const prepared = Zx.prepare(state, cache, sources, index, null) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            else => {
                state.issue = issue;

                continue;
            },
        };

        try self.items.append(state.allocator, .{ .prepared = prepared });
    }

    if (self.items.items.len < 2) return;

    const Work = struct {
        state: *const State,
        items: []Item,
        arenas: []std.heap.ArenaAllocator,
        next: std.atomic.Value(usize) = .init(0),
        fn run(work: *@This(), participant: usize) void {
            const arena = work.arenas[participant].allocator();

            while (true) {
                const position = work.next.fetchAdd(1, .monotonic);

                if (position >= work.items.len) return;

                const item = &work.items[position];

                item.outcome = Zx.analyze(work.state, arena, item.prepared, &.{}) catch null;
            }
        }
    };

    var work = Work{ .state = state, .items = self.items.items, .arenas = self.arenas };

    @import("zx").parallel.spread(Work, &work, Work.run, @min(self.arenas.len, self.items.items.len));

    for (self.items.items) |item| if (item.outcome) |outcome| switch (outcome) {
        .analyzed => |analyzed| self.results[item.prepared.index] = analyzed,
        .diagnostic => {},
    };
}

/// The analysis `analyze` made of `index`, while the tables still allow linking it.
pub fn take(self: *Self, state: *const State, index: usize) ?Zx.Analyzed {
    const analyzed = self.results[index] orelse return null;

    self.results[index] = null;

    return if (Zx.current(state, analyzed)) analyzed else null;
}

/// A ZX body analyzed at its turn without a Store, an earlier analysis to reuse, or a compiled library to load first.
fn eligible(state: *const State, reuse: *const Reuse, index: usize) bool {
    const module = state.graph.modules[index];

    if (module.source != .zx or reuse.reusable(state, index)) return false;

    const signature = state.signature(index) orelse return false;

    if (signature.signature.has_store) return false;

    for (module.dependencies) |edge| if (edge.target == .compiled) return false;

    return true;
}
