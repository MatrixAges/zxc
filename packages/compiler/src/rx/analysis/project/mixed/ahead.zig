//! Analyzes the ZX bodies and lowers the RX modules of one run of the dependency order on all cores before the run is
//! linked. Modules of one depth depend on none of each other, so each reads the shared tables as the run found them,
//! and linking still follows the order: the type merge maps a type a module made to the same type an earlier module of
//! the run added. A module this skips, whose analysis fails, or whose tables changed in ways the link cannot account
//! for is analyzed at its turn.
const std = @import("std");
const frontend = @import("frontend");
const rx = @import("rx");
const State = @import("state.zig");
const Reuse = @import("reuse.zig");
const Zx = @import("zx.zig");
const Rx = @import("rx.zig");
const Module = @import("../../module.zig");
const Frame = @import("../history.zig").Frame;
const Self = @This();

arenas: []std.heap.ArenaAllocator,
/// Holds what preparing the RX modules of the current run binds.
bindings: std.heap.ArenaAllocator,
items: std.ArrayList(Item) = .empty,
/// The analysis of each module of the current run, by module.
results: []?Result,
const Item = union(enum) {
    zx: struct { prepared: Zx.Prepared, outcome: ?Zx.Outcome = null },
    rx: struct { prepared: Rx.Prepared, value: ?Module.Value = null },
    fn index(self: Item) usize {
        return switch (self) {
            inline else => |item| item.prepared.index,
        };
    }
};

/// Fewer modules than this are analyzed at their turn: waking the other cores costs more than a run of two or three
/// modules saves.
const minimum = 4;
pub const Lowered = struct { prepared: Rx.Prepared, contract: Module.Contract };

const Result = union(enum) { zx: Zx.Analyzed, rx: Lowered };

pub fn init(allocator: std.mem.Allocator, count: usize) std.mem.Allocator.Error!Self {
    const arenas = try allocator.alloc(std.heap.ArenaAllocator, @import("zx").parallel.width());

    for (arenas) |*arena| arena.* = .init(std.heap.smp_allocator);

    const results = try allocator.alloc(?Result, count);

    @memset(results, null);

    return .{ .arenas = arenas, .bindings = .init(std.heap.smp_allocator), .results = results };
}

pub fn deinit(self: *Self) void {
    for (self.arenas) |*arena| arena.deinit();

    self.bindings.deinit();
}

/// Analyzes the bodies and lowers the RX modules of a run's `modules` that will not be reused; a run of one module is
/// left to its turn.
pub fn analyze(self: *Self, state: *State, cache: *frontend.project.ParseCache, sources: []const frontend.project.Source, derived: Frame, reuse: *const Reuse, modules: []const usize) std.mem.Allocator.Error!void {
    for (self.items.items) |item| self.results[item.index()] = null;
    for (self.arenas) |*arena| _ = arena.reset(.retain_capacity);

    _ = self.bindings.reset(.retain_capacity);

    self.items.clearRetainingCapacity();

    var eligible_count: usize = 0;

    for (modules) |index| eligible_count += @intFromBool(eligible(state, reuse, index));
    if (eligible_count < minimum) return;

    const owner = state.owner;

    defer state.owner = owner;

    for (modules) |index| {
        if (!eligible(state, reuse, index)) continue;

        const issue = state.issue;

        state.owner = index;

        const item = prepare(self, state, cache, sources, derived, index) catch |err| switch (err) {
            error.OutOfMemory => return error.OutOfMemory,
            else => {
                state.issue = issue;

                continue;
            },
        } orelse continue;

        try self.items.append(state.allocator, item);
    }

    if (self.items.items.len < minimum) return;

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

                switch (work.items[position]) {
                    .zx => |*item| item.outcome = Zx.analyze(work.state, arena, item.prepared, &.{}) catch null,
                    .rx => |*item| item.value = Rx.lower(work.state, arena, item.prepared) catch null,
                }
            }
        }
    };

    var work = Work{ .state = state, .items = self.items.items, .arenas = self.arenas };

    @import("zx").parallel.spread(Work, &work, Work.run, @min(self.arenas.len, self.items.items.len));

    for (self.items.items) |item| switch (item) {
        .zx => |value| if (value.outcome) |outcome| switch (outcome) {
            .analyzed => |analyzed| self.results[value.prepared.index] = .{ .zx = analyzed },
            .diagnostic => {},
        },
        .rx => |value| if (value.value) |outcome| switch (outcome) {
            .contract => |contract| self.results[value.prepared.index] = .{ .rx = .{ .prepared = value.prepared, .contract = contract } },
            .diagnostic => {},
        },
    };
}

fn prepare(self: *Self, state: *State, cache: *frontend.project.ParseCache, sources: []const frontend.project.Source, derived: Frame, index: usize) State.Error!?Item {
    switch (state.graph.modules[index].source) {
        .zx => return .{ .zx = .{ .prepared = try Zx.prepare(state, cache, sources, index, null) } },
        .rx => |source| {
            const module = derived.loaded.modules[source];
            const callees = @import("callees.zig");

            if (!try callees.local(state, derived.modules, module)) return null;

            const ids = try callees.load(state, cache, sources, derived.modules, module);

            return .{ .rx = .{ .prepared = try Rx.prepare(state, self.bindings.allocator(), index, module, derived.resolved[source], ids) } };
        },
    }
}

/// The analysis `analyze` made of the ZX body `index`, while the tables still allow linking it.
pub fn take(self: *Self, state: *const State, index: usize) ?Zx.Analyzed {
    const result = self.results[index] orelse return null;

    self.results[index] = null;

    return if (result == .zx and Zx.current(state, result.zx)) result.zx else null;
}

/// The lowering `analyze` made of the RX module `index`, while the tables still allow linking it.
pub fn lowered(self: *Self, state: *const State, index: usize) ?Lowered {
    const result = self.results[index] orelse return null;

    self.results[index] = null;

    return if (result == .rx and Rx.current(state, result.rx.prepared, result.rx.contract)) result.rx else null;
}

/// A module analyzed at its turn without a Store, an earlier analysis to reuse, or a compiled library to load first;
/// the RX entry stays at its turn, which keeps what it lowers for the project.
fn eligible(state: *const State, reuse: *const Reuse, index: usize) bool {
    const module = state.graph.modules[index];

    if (reuse.reusable(state, index)) return false;

    switch (module.source) {
        .zx => {
            const signature = state.signature(index) orelse return false;

            if (signature.signature.has_store) return false;
        },
        .rx => if (index == state.graph.entry) return false,
    }

    for (module.dependencies) |edge| if (edge.target == .compiled) return false;

    return true;
}
