const std = @import("std");
const ir = @import("zx").ir;
pub const Uniqueness = @import("uniqueness/root.zig");
const Self = @This();

pub const Entry = @import("entry_flags.zig");

value: @import("value_call/analysis.zig").Summary,
entry_flags: Entry.Flags,
io: []const bool,
process: []const bool,
/// Functions that start tasks, themselves or through their callees.
tasks: []const bool,
/// The errors each function raises, null where unknown.
errors: []const ?[]const []const u8 = &.{},
layout_types: []const @import("iteration_layout/generated.zig").Type = &.{},
/// The pure functions that compare no represented aggregates by identity, themselves or through their callees.
identity_free: []const bool = &.{},
/// The functions whose output holds no part of their input.
fresh_outputs: []const bool = &.{},
constructed_outputs: []const bool = &.{},
grows: []const bool = &.{},
uniqueness: Uniqueness.Result,
basis: *const Uniqueness.Basis,
/// Shared by every `reentry` into the same functions.
entry_summaries: ?*Uniqueness.Summaries = null,
/// Replaces the entry plan with one for `program`, an entry body over the same types and functions the facts were
/// computed for.
pub fn reentry(self: *Self, allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!void {
    self.entry_flags = try Entry.analyze(workspace, program, .{ .local = self.value.local, .pure = self.value.pure, .io = self.io, .process = self.process, .tasks = self.tasks });

    if (self.entry_summaries) |summaries| if (summaries.input.len == program.functions.count()) {
        self.uniqueness.entry = try Uniqueness.analyzeEntryWith(allocator, workspace, program, self.basis, summaries);

        return;
    };

    self.uniqueness.entry = try Uniqueness.analyzeEntry(allocator, workspace, program, self.basis);
}

pub fn hasValueEntry(self: Self) bool {
    return self.entry_flags.value;
}

pub fn hasStateEntry(self: Self, program: ir.Program) bool {
    if (!@import("genz_options").generated_analysis) return !program.type_only and self.entry_flags.value and !self.entry_flags.tasks and
        (self.value.state.represented(program, program.output_type) or self.value.state.inlineRows(program, program.input_type));

    return @import("entry/policy.zig").select(.{
        .tasks = self.entry_flags.tasks,
        .enabled = self.entry_flags.value,
        .type_only = program.type_only,
        .represented_input = self.value.state.inlineRows(program, program.input_type),
        .represented_output = self.value.state.represented(program, program.output_type),
        .output_kind = @fromBackingInt(@intCast(program.types.kinds[@backingInt(program.output_type)])),
    }).state;
}

/// Whether the entry of `program` has `executeIn`: a body that starts tasks shares its allocator between threads, so
/// it runs in the arena `execute` lends alone.
pub fn hasAllocatorEntry(self: Self) bool {
    if (!@import("genz_options").generated_analysis) return !self.entry_flags.tasks;

    return @import("entry/policy.zig").allocator(self.entry_flags.tasks);
}

pub const Owned = struct {
    arena: std.heap.ArenaAllocator,
    value: Self,
    pub fn deinit(self: *Owned) void {
        self.arena.deinit();

        self.* = undefined;
    }
};

pub fn create(backing: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Owned {
    return createExported(backing, program, &.{});
}

/// Facts for a program whose `exported` functions the host also calls directly.
pub fn createExported(backing: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId) std.mem.Allocator.Error!Owned {
    return createRemembered(backing, program, exported, null);
}

/// Facts that also reuse and extend the body analyses `memo` remembers from earlier programs.
pub fn createRemembered(backing: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, memo: ?*Uniqueness.Memo) std.mem.Allocator.Error!Owned {
    return createWithConcurrency(backing, program, exported, memo, false);
}

/// `backing` and every allocator behind `memo` must be threadsafe; this call exclusively borrows `memo`.
pub fn createRememberedConcurrent(backing: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, memo: ?*Uniqueness.Memo) std.mem.Allocator.Error!Owned {
    return createWithConcurrency(backing, program, exported, memo, true);
}

fn createWithConcurrency(backing: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, memo: ?*Uniqueness.Memo, comptime concurrent: bool) std.mem.Allocator.Error!Owned {
    var arena = std.heap.ArenaAllocator.init(backing);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const basis = try owned.create(Uniqueness.Basis);
    var scratch = std.heap.ArenaAllocator.init(backing);

    defer scratch.deinit();

    const facts = try analyzeFrom(scratch.allocator(), backing, program, exported, .{ .build = .{ .allocator = owned, .basis = basis } }, memo, concurrent);

    const value: Self = .{
        .value = .{
            .pure = try owned.dupe(bool, facts.value.pure),
            .local = try owned.dupe(bool, facts.value.local),
            .values = try owned.dupe(bool, facts.value.values),
            .state = .{
                .element_storage = try owned.dupe(bool, facts.value.state.element_storage),
                .selected = try owned.dupe(bool, facts.value.state.selected),
                .borrowed = try owned.dupe(bool, facts.value.state.borrowed),
                .queries = try owned.dupe(@import("state_value/queries.zig").Kind, facts.value.state.queries),
                .keys = try owned.dupe([32]u8, facts.value.state.keys),
            },
        },
        .entry_flags = facts.entry_flags,
        .io = try owned.dupe(bool, facts.io),
        .process = try owned.dupe(bool, facts.process),
        .tasks = try owned.dupe(bool, facts.tasks),
        .grows = try owned.dupe(bool, facts.grows),
        .errors = try copyErrors(owned, facts.errors),
        .layout_types = try owned.dupe(@import("iteration_layout/generated.zig").Type, facts.layout_types),
        .identity_free = try owned.dupe(bool, facts.identity_free),
        .fresh_outputs = try owned.dupe(bool, facts.fresh_outputs),
        .constructed_outputs = try owned.dupe(bool, facts.constructed_outputs),
        .uniqueness = facts.uniqueness,
        .basis = basis,
        .entry_summaries = try owned.create(Uniqueness.Summaries),
    };

    value.entry_summaries.?.* = try .create(owned, program, basis);

    return .{ .arena = arena, .value = value };
}

pub fn analyze(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, basis: *const Uniqueness.Basis, memo: ?*Uniqueness.Memo) std.mem.Allocator.Error!Self {
    return analyzeFrom(allocator, workspace, program, exported, .{ .ready = basis }, memo, false);
}

/// All allocators must be threadsafe, including shared parents and those behind the exclusively borrowed `memo`.
pub fn analyzeConcurrent(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, basis: *const Uniqueness.Basis, memo: ?*Uniqueness.Memo) std.mem.Allocator.Error!Self {
    return analyzeFrom(allocator, workspace, program, exported, .{ .ready = basis }, memo, true);
}

/// The basis uniqueness reads, or where to build it: building it first on the uniqueness thread overlaps it with the
/// other passes, which read no basis.
const Source = union(enum) {
    ready: *const Uniqueness.Basis,
    build: struct { allocator: std.mem.Allocator, basis: *Uniqueness.Basis },
    fn basis(self: Source) *const Uniqueness.Basis {
        return switch (self) {
            .ready => |value| value,
            .build => |value| value.basis,
        };
    }
};

fn analyzeFrom(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, source: Source, memo: ?*Uniqueness.Memo, comptime concurrent: bool) std.mem.Allocator.Error!Self {
    const plans = switch (source) {
        .ready => allocator,
        .build => |build| build.allocator,
    };

    var uniqueness = Concurrent{ .arena = .init(workspace), .workspace = workspace, .program = program, .exported = exported, .source = source, .memo = memo };

    defer uniqueness.arena.deinit();

    const thread: ?std.Thread = if (concurrent) std.Thread.spawn(.{}, Concurrent.run, .{&uniqueness}) catch null else null;

    if (thread == null) {
        uniqueness.result = analyzeUniqueness(if (concurrent) uniqueness.arena.allocator() else plans, workspace, program, exported, source, memo, concurrent);
    }

    const others = remaining(allocator, workspace, program, exported);

    if (thread) |running| running.join();

    var value = try others;

    value.uniqueness = if (concurrent) try copyPlans(plans, try uniqueness.result) else try uniqueness.result;
    value.basis = source.basis();
    value.entry_flags = try Entry.analyze(workspace, program, .{ .local = value.value.local, .pure = value.value.pure, .io = value.io, .process = value.process, .tasks = value.tasks });

    return value;
}

/// Each function's output holds no part of its input when the input is no descendant of it; every function walks the
/// types under its output once, marking them with its own round.
fn freshOutputs(allocator: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error![]const bool {
    const result = try allocator.alloc(bool, program.functions.count());
    const seen = try allocator.alloc(u32, program.types.count());
    var pending: std.ArrayList(ir.TypeId) = .empty;

    defer allocator.free(seen);
    defer pending.deinit(allocator);
    @memset(seen, 0);

    for (result, 1..) |*fresh, round| {
        const function = program.functions.at(round - 1);

        pending.clearRetainingCapacity();

        try children(allocator, program, function.output_type, &pending);

        fresh.* = while (pending.pop()) |id| {
            if (id == function.input_type) break false;
            if (seen[@backingInt(id)] == round) continue;

            seen[@backingInt(id)] = @intCast(round);

            try children(allocator, program, id, &pending);
        } else true;
    }

    return result;
}

fn children(allocator: std.mem.Allocator, program: ir.Program, id: ir.TypeId, pending: *std.ArrayList(ir.TypeId)) std.mem.Allocator.Error!void {
    switch (program.typeOf(id)) {
        .optional, .list => |child| try pending.append(allocator, child),
        .tuple => |items| for (0..items.len) |index| try pending.append(allocator, items.at(index)),
        .object => |fields| for (0..fields.len) |index| try pending.append(allocator, fields.at(index).type_id),
        else => {},
    }
}

/// Every fact but the uniqueness plans.
fn remaining(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId) std.mem.Allocator.Error!Self {
    if (@import("genz_options").generated_analysis) {
        const generated = try @import("function_analysis/generated.zig").analyze(allocator, workspace, program, exported);

        return .{
            .value = generated.value,
            .io = generated.io,
            .process = generated.process,
            .tasks = generated.tasks,
            .grows = generated.grows,
            .fresh_outputs = generated.fresh_outputs,
            .constructed_outputs = generated.constructed_outputs,
            .identity_free = generated.identity_free,
            .errors = generated.errors,
            .layout_types = generated.layout_types,
            .entry_flags = undefined,
            .uniqueness = undefined,
            .basis = undefined,
        };
    }

    const value = try @import("value_call/analysis.zig").analyzeExported(allocator, program, exported);

    return .{
        .value = value,
        .io = try @import("io.zig").functions(allocator, program),
        .process = try @import("capabilities.zig").functions(allocator, program, .process),
        .tasks = try @import("tasks/allocator.zig").functions(allocator, program),
        .fresh_outputs = try freshOutputs(allocator, program),
        .constructed_outputs = try @import("value_call/fresh.zig").functions(allocator, program),
        .identity_free = try @import("iteration_layout/identity_free.zig").functions(allocator, program, value.pure),
        .errors = try @import("zx").error_effects.perFunction(allocator, program.types, program.functions),
        .entry_flags = undefined,
        .uniqueness = undefined,
        .basis = undefined,
    };
}

const Concurrent = struct {
    arena: std.heap.ArenaAllocator,
    workspace: std.mem.Allocator,
    program: ir.Program,
    exported: []const ir.FunctionId,
    source: Source,
    memo: ?*Uniqueness.Memo,
    result: std.mem.Allocator.Error!Uniqueness.Result = error.OutOfMemory,
    fn run(self: *Concurrent) void {
        self.result = analyzeUniqueness(self.arena.allocator(), self.workspace, self.program, self.exported, self.source, self.memo, true);
    }
};

fn analyzeUniqueness(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, source: Source, memo: ?*Uniqueness.Memo, comptime concurrent: bool) std.mem.Allocator.Error!Uniqueness.Result {
    if (source == .build) {
        const build = source.build;
        build.basis.* = try Uniqueness.Basis.create(build.allocator, workspace, program, memo);
    }

    return if (concurrent) Uniqueness.analyzeConcurrent(allocator, workspace, program, exported, source.basis(), memo) else Uniqueness.analyze(allocator, workspace, program, exported, source.basis(), memo);
}

/// The names live in the program, which outlives its facts.
fn copyErrors(allocator: std.mem.Allocator, source: []const ?[]const []const u8) std.mem.Allocator.Error![]const ?[]const []const u8 {
    const errors = try allocator.alloc(?[]const []const u8, source.len);

    for (source, errors) |names, *target| target.* = if (names) |value| try allocator.dupe([]const u8, value) else null;

    return errors;
}

fn copyPlans(allocator: std.mem.Allocator, source: Uniqueness.Result) std.mem.Allocator.Error!Uniqueness.Result {
    const functions = try allocator.alloc(Uniqueness.Plan, source.functions.len);

    for (source.functions, functions) |plan, *target| target.* = try copyPlan(allocator, plan);

    return .{ .functions = functions, .entry = try copyPlan(allocator, source.entry) };
}

fn copyPlan(allocator: std.mem.Allocator, source: Uniqueness.Plan) std.mem.Allocator.Error!Uniqueness.Plan {
    const renewals = try @import("uniqueness/renewals.zig").copy(allocator, source.renewals);

    return .{ .flags = try allocator.dupe(Uniqueness.Flags, source.flags), .renewals = renewals, .transfers = try allocator.dupe(u64, source.transfers), .slot_first = try allocator.dupe(u32, source.slot_first) };
}
