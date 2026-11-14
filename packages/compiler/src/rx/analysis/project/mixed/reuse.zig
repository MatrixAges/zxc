//! Reuses the modules of an earlier analysis (see `../history.zig`). While every module so far appended the same
//! rows as before, the tables stay aligned with the earlier ones, and a module whose source is unchanged and whose
//! dependencies were all reused copies its earlier rows. Analysis reads callee bodies, not only their signatures, and
//! some facts follow calls through every body reached, so a module depending on one whose rows changed, directly or
//! through its own dependencies, is analyzed again too. A module analyzed again into the very rows and link it had
//! before, whose dependencies changed nothing either, changes nothing its dependents read, so they stay reusable. Once a
//! module appends different types, or a different number of rows, every later module is analyzed.
const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const State = @import("state.zig");
const history = @import("../history.zig");
const columns = @import("../history/columns.zig");
const ParseCache = @import("frontend").project.ParseCache;
const Self = @This();

record: ?*history.History,
previous: ?*const history.Retained = null,
derived: history.Frame,
aligned: bool = false,
initial: history.Checkpoint = undefined,
/// Modules whose rows or link differ from the earlier ones, or that depend on such a module.
redone: []bool = &.{},
digests: []?[32]u8 = &.{},
before: []history.Checkpoint = &.{},
after: []history.Checkpoint = &.{},
pub fn begin(state: *const State, cache: *const ParseCache, record: ?*history.History, derived: history.Frame) std.mem.Allocator.Error!Self {
    const owner = record orelse return .{ .record = null, .derived = derived };
    const count = state.graph.modules.len;
    const initial = checkpoint(state);

    var self = Self{
        .record = record,
        .derived = derived,
        .initial = initial,
        .redone = try state.allocator.alloc(bool, count),
        .digests = try state.allocator.alloc(?[32]u8, count),
        .before = try state.allocator.alloc(history.Checkpoint, count),
        .after = try state.allocator.alloc(history.Checkpoint, count),
    };

    @memset(self.redone, false);
    @memset(self.before, initial);
    @memset(self.after, initial);

    for (state.graph.modules, self.digests) |module, *digest| digest.* = switch (module.source) {
        .zx => cache.sourceDigest(module.path),
        .store => null,
        .rx => owner.rxDigest(module.path),
    };

    const previous = if (owner.previous) |*value| value else return self;

    self.previous = previous;
    self.aligned = matches(state, previous, owner.shape, initial);

    return self;
}

/// Copies `index`'s rows from the earlier analysis when nothing they derive from changed; false when it must be
/// analyzed.
pub fn reuse(self: *Self, state: *State, index: usize) std.mem.Allocator.Error!bool {
    const owner = self.record orelse return false;

    self.before[index] = checkpoint(state);

    if (!self.reusable(state, index)) return false;

    const previous = self.previous.?;
    const start = previous.before[index];
    const end = previous.after[index];

    try columns.transplant(state.allocator, &state.types.items, previous.types, start.types, end.types);
    try columns.transplant(state.allocator, &state.types.origins.items, previous.origins, start.origins, end.origins);
    try columns.transplant(state.allocator, &state.functions, previous.functions, @splat(start.functions), @splat(end.functions));

    state.finished[index] = previous.finished[index];
    state.verified = state.functions.count();
    self.after[index] = checkpoint(state);
    owner.reused += 1;

    return true;
}

/// Whether `reuse` copies `index`'s rows while the tables stay aligned until its turn; they only ever fall out of line,
/// so a module this rejects is analyzed whatever the modules before it do.
pub fn reusable(self: *const Self, state: *const State, index: usize) bool {
    const previous = self.previous orelse return false;

    if (!self.aligned or !self.unchanged(state, index)) return false;

    const start = previous.before[index];
    const end = previous.after[index];

    return start.native_modules == end.native_modules and start.initializers == end.initializers and start.libraries == end.libraries;
}

/// Records that `index` was analyzed, and whether the tables still match the earlier analysis after it.
pub fn analyzed(self: *Self, state: *const State, index: usize) void {
    const owner = self.record orelse return;
    const end = checkpoint(state);

    self.redone[index] = true;
    self.after[index] = end;
    owner.analyzed += 1;

    const previous = self.previous orelse return;

    if (!self.aligned) return;

    const start = self.before[index];
    const earlier = previous.after[index];

    self.aligned = @import("history/alignment.zig").matches(state, previous, start, earlier, end);

    if (self.aligned and !self.reaches(state, index) and repeated(state, previous, index, start.functions)) self.redone[index] = false;
}

/// Whether a dependency of `index` changed.
fn reaches(self: *const Self, state: *const State, index: usize) bool {
    if (state.graph.modules[index].compiled_dependency) return true;

    const dependencies = state.graph.source_dependencies.?.at(index);

    if (dependencies.len == 0) return false;

    if (comptime @import("rx_options").generated_graph) {
        const rule = @import("generated_rx_mixed_dependency_changed");
        var empty = std.heap.FixedBufferAllocator.init(&.{});
        const input: std.meta.Child(rule.Input) = .{ .dependencies = dependencies, .redone = self.redone };

        return zx.columns.invoke(rule.executeValue, empty.allocator(), &input) catch unreachable;
    }

    for (dependencies) |dependency| if (self.redone[@intCast(dependency)]) return true;

    return false;
}

/// Whether `index`, analyzed again into tables still aligned, appended the very function rows and produced the very
/// link it had before, down to the bodies they point to.
fn repeated(state: *const State, previous: *const history.Retained, index: usize, start: usize) bool {
    if (state.graph.modules[index].source == .store) return true;

    const current = state.finished[index] orelse return false;
    const earlier = previous.finished[index] orelse return false;
    const end = state.functions.count();

    if (previous.before[index].functions != start or previous.after[index].functions != end) return false;
    if (!columns.same(current, earlier)) return false;

    const left = previous.functions;
    const right = state.functions.view();

    inline for (@typeInfo(ir.FunctionTable).@"struct".field_names) |name| {
        const Element = std.meta.Elem(@FieldType(ir.FunctionTable, name));
        const shared = comptime @typeInfo(Element) == .pointer and @typeInfo(Element).pointer.size == .one;

        if (shared) {
            for (@field(left, name)[start..end], @field(right, name)[start..end]) |a, b| if (!columns.same(a.*, b.*)) return false;
        } else if (!columns.same(@field(left, name)[start..end], @field(right, name)[start..end])) return false;
    }

    return true;
}

/// Leaves this analysis for the next one.
pub fn finish(self: *const Self, state: *const State, selected: []const @import("rx").ModuleSource, sources: []const @import("frontend").project.Source) void {
    const owner = self.record orelse return;

    owner.next = .{
        .frame = owner.frame,
        .shape = owner.shape,
        .modules = selected,
        .sources = sources,
        .derived = self.derived,
        .initial = self.initial,
        .digests = self.digests,
        .before = self.before,
        .after = self.after,
        .finished = state.finished,
        .types = state.types.items.view(),
        .origins = state.types.origins.items.view(),
        .functions = state.functions.view(),
    };
}

/// A module is unchanged when its source is and so are its dependencies; aligned tables imply an unchanged shape. An RX
/// module's signature is resolved over every RX module at once, so it must also have resolved as before. The entry is
/// always lowered again, since its contract is built while lowering it.
fn unchanged(self: *const Self, state: *const State, index: usize) bool {
    const module = state.graph.modules[index];
    const previous = self.previous.?;

    if (index == state.graph.entry) return false;

    if (module.source == .store) {
        const before = previous.derived.dependencies.modules[index].source;

        return before == .store and columns.same(previous.derived.stores[before.store].node, self.derived.stores[module.source.store].node) and !self.reaches(state, index);
    }

    const earlier = previous.digests[index] orelse return false;
    const current = self.digests[index] orelse return false;

    if (!std.mem.eql(u8, &earlier, &current)) return false;

    if (module.source == .rx) {
        const before = previous.derived.dependencies.modules[index].source;

        if (before != .rx or !columns.same(previous.derived.resolved[before.rx], self.derived.resolved[module.source.rx])) return false;
    }

    return !self.reaches(state, index);
}

/// Whether this analysis starts from the tables the earlier one started from, over the same modules in the same order.
fn matches(state: *const State, previous: *const history.Retained, shape: [32]u8, initial: history.Checkpoint) bool {
    const earlier = previous.derived.dependencies;

    if (!std.mem.eql(u8, &previous.shape, &shape) or !previous.initial.eql(initial) or earlier.modules.len != state.graph.modules.len) return false;
    if (!std.mem.eql(usize, earlier.order, state.graph.order)) return false;

    if (earlier.modules.ptr != state.graph.modules.ptr) {
        for (earlier.modules, state.graph.modules) |before, after| if (!zx.bytes.equal(before.path, after.path)) return false;
    }

    const start: history.Checkpoint = .{
        .types = @splat(0),
        .origins = @splat(0),
        .functions = 0,
        .native_modules = 0,
        .initializers = 0,
        .libraries = 0,
    };

    if (!@import("history/alignment.zig").matches(state, previous, start, initial, initial)) return false;

    return signatures(previous.functions, state.functions.view(), initial.functions);
}

/// Compares the function rows' signature columns; the tables each row points to belong to one analysis.
fn signatures(left: ir.FunctionTable, right: ir.FunctionTable, count: usize) bool {
    inline for (@typeInfo(ir.FunctionTable).@"struct".field_names) |name| {
        const Element = std.meta.Elem(@FieldType(ir.FunctionTable, name));
        const shared = comptime @typeInfo(Element) == .pointer and @typeInfo(Element).pointer.size == .one;

        if (!shared and !columns.same(@field(left, name)[0..count], @field(right, name)[0..count])) return false;
    }

    return true;
}

fn checkpoint(state: *const State) history.Checkpoint {
    return .{
        .types = columns.measure(&state.types.items),
        .origins = columns.measure(&state.types.origins.items),
        .functions = state.functions.count(),
        .native_modules = state.native_modules.count(),
        .initializers = state.initializers.items.len,
        .libraries = state.libraries.count(),
    };
}
