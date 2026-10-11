//! Reuses the modules of an earlier analysis (see `../history.zig`). While every module so far appended the same
//! rows as before, the tables stay aligned with the earlier ones, and a module whose source is unchanged and whose
//! dependencies were all reused copies its earlier rows. Analysis reads callee bodies, not only their signatures, so
//! a module depending on one analyzed again is analyzed again too. Once a module appends different types, or a
//! different number of rows, every later module is analyzed.
const std = @import("std");
const ir = @import("zx").ir;
const State = @import("state.zig");
const history = @import("../history.zig");
const columns = @import("../history/columns.zig");
const ParseCache = @import("frontend").project.ParseCache;
const Self = @This();

record: ?*history.History,
previous: ?*const history.Retained = null,
aligned: bool = false,
initial: history.Checkpoint,
redone: []bool,
digests: []?[32]u8,
before: []history.Checkpoint,
after: []history.Checkpoint,

pub fn begin(state: *const State, cache: *const ParseCache, record: ?*history.History) std.mem.Allocator.Error!Self {
    const count = state.graph.modules.len;
    const initial = checkpoint(state);
    var self = Self{
        .record = record,
        .initial = initial,
        .redone = try state.allocator.alloc(bool, count),
        .digests = try state.allocator.alloc(?[32]u8, count),
        .before = try state.allocator.alloc(history.Checkpoint, count),
        .after = try state.allocator.alloc(history.Checkpoint, count),
    };

    @memset(self.redone, false);
    @memset(self.before, initial);
    @memset(self.after, initial);

    for (state.graph.modules, self.digests) |module, *digest| digest.* = if (module.source == .zx) cache.sourceDigest(module.path) else null;

    const owner = record orelse return self;
    const previous = if (owner.previous) |*value| value else return self;

    self.previous = previous;
    self.aligned = matches(state, previous, owner.frame, initial);

    return self;
}

/// Copies `index`'s rows from the earlier analysis when nothing they derive from changed; false when it must be
/// analyzed.
pub fn reuse(self: *Self, state: *State, index: usize) std.mem.Allocator.Error!bool {
    self.before[index] = checkpoint(state);

    const previous = self.previous orelse return false;

    if (!self.aligned or !self.unchanged(state, index)) return false;

    const start = previous.before[index];
    const end = previous.after[index];

    if (start.native_modules != end.native_modules or start.initializers != end.initializers or start.libraries != end.libraries) return false;

    try columns.transplant(state.allocator, &state.types.items, previous.types, start.types, end.types);
    try columns.transplant(state.allocator, &state.types.origins.items, previous.origins, start.origins, end.origins);
    try columns.transplant(state.allocator, &state.functions, previous.functions, @splat(start.functions), @splat(end.functions));

    state.finished[index] = previous.finished[index];
    state.verified = state.functions.count();
    self.after[index] = checkpoint(state);

    if (self.record) |owner| owner.reused += 1;

    return true;
}

/// Records that `index` was analyzed, and whether the tables still match the earlier analysis after it.
pub fn analyzed(self: *Self, state: *const State, index: usize) void {
    const end = checkpoint(state);

    self.redone[index] = true;
    self.after[index] = end;

    if (self.record) |owner| owner.analyzed += 1;

    const previous = self.previous orelse return;

    if (!self.aligned) return;

    const start = self.before[index];
    const earlier = previous.after[index];

    self.aligned = end.functions == earlier.functions and end.native_modules == earlier.native_modules and end.initializers == earlier.initializers and end.libraries == earlier.libraries and
        columns.equal(previous.types, start.types, earlier.types, state.types.items.view(), start.types, end.types) and
        columns.equal(previous.origins, start.origins, earlier.origins, state.types.origins.items.view(), start.origins, end.origins);
}

/// Leaves this analysis for the next one.
pub fn finish(self: *const Self, state: *const State) std.mem.Allocator.Error!void {
    const owner = self.record orelse return;
    const paths = try state.allocator.alloc([]const u8, state.graph.modules.len);

    for (state.graph.modules, paths) |module, *path| path.* = try state.allocator.dupe(u8, module.path);

    owner.next = .{
        .frame = owner.frame,
        .initial = self.initial,
        .paths = paths,
        .digests = self.digests,
        .before = self.before,
        .after = self.after,
        .finished = try state.allocator.dupe(?@import("frontend").project.artifact.source_link.Loaded, state.finished),
        .types = state.types.items.view(),
        .origins = state.types.origins.items.view(),
        .functions = state.functions.view(),
    };
}

/// A module is unchanged when its source is: aligned tables imply an unchanged frame, which covers every RX source.
/// The entry is always lowered again, since its contract is built while lowering it.
fn unchanged(self: *const Self, state: *const State, index: usize) bool {
    const module = state.graph.modules[index];

    if (index == state.graph.entry) return false;

    if (module.source == .zx) {
        const earlier = self.previous.?.digests[index] orelse return false;
        const current = self.digests[index] orelse return false;

        if (!std.mem.eql(u8, &earlier, &current)) return false;
    }

    for (module.dependencies) |edge| switch (edge.target) {
        .source => |dependency| if (self.redone[dependency]) return false,
        .compiled => return false,
        .native => {},
    };

    return true;
}

/// Whether this analysis starts from the tables the earlier one started from, over the same modules.
fn matches(state: *const State, previous: *const history.Retained, frame: [32]u8, initial: history.Checkpoint) bool {
    if (!std.mem.eql(u8, &previous.frame, &frame) or !previous.initial.eql(initial) or previous.paths.len != state.graph.modules.len) return false;

    for (previous.paths, state.graph.modules) |path, module| if (!std.mem.eql(u8, path, module.path)) return false;

    const types: @TypeOf(initial.types) = @splat(0);
    const origins: @TypeOf(initial.origins) = @splat(0);

    if (!columns.equal(previous.types, types, initial.types, state.types.items.view(), types, initial.types)) return false;
    if (!columns.equal(previous.origins, origins, initial.origins, state.types.origins.items.view(), origins, initial.origins)) return false;

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
