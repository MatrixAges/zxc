const std = @import("std");
const ir = @import("zx").ir;
pub const Uniqueness = @import("uniqueness/root.zig");
const Self = @This();

value: @import("value_call/analysis.zig").Summary,
io: []const bool,
process: []const bool,
/// Functions that start tasks, themselves or through their callees.
tasks: []const bool,
/// The errors each function raises, null where unknown.
errors: []const ?[]const []const u8 = &.{},

/// The pure functions that compare no represented aggregates by identity, themselves or through their callees.
identity_free: []const bool = &.{},
/// The functions whose output holds no part of their input.
fresh_outputs: []const bool = &.{},
uniqueness: Uniqueness.Result,
basis: *const Uniqueness.Basis,
/// Shared by every `reentry` into the same functions.
entry_summaries: ?*Uniqueness.Summaries = null,
/// Replaces the entry plan with one for `program`, an entry body over the same types and functions the facts were
/// computed for.
pub fn reentry(self: *Self, allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!void {
    if (self.entry_summaries) |summaries| if (summaries.input.len == program.functions.count()) {
        self.uniqueness.entry = try Uniqueness.analyzeEntryWith(allocator, workspace, program, self.basis, summaries);

        return;
    };

    self.uniqueness.entry = try Uniqueness.analyzeEntry(allocator, workspace, program, self.basis);
}

pub fn hasValueEntry(self: Self, program: ir.Program) bool {
    return @import("value_call/analysis.zig").eligibleEntry(program, self.value.local);
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
    var arena = std.heap.ArenaAllocator.init(backing);

    errdefer arena.deinit();

    const owned = arena.allocator();
    const basis = try owned.create(Uniqueness.Basis);
    basis.* = try .create(owned, program);
    var scratch = std.heap.ArenaAllocator.init(backing);

    defer scratch.deinit();

    const facts = try analyze(scratch.allocator(), backing, program, exported, basis, memo);

    const value: Self = .{
        .value = .{
            .pure = try owned.dupe(bool, facts.value.pure),
            .local = try owned.dupe(bool, facts.value.local),
            .values = try owned.dupe(bool, facts.value.values),
            .state = .{
                .selected = try owned.dupe(bool, facts.value.state.selected),
                .keys = try owned.dupe([32]u8, facts.value.state.keys),
            },
        },
        .io = try owned.dupe(bool, facts.io),
        .process = try owned.dupe(bool, facts.process),
        .tasks = try owned.dupe(bool, facts.tasks),
        .errors = try copyErrors(owned, facts.errors),
        .identity_free = try owned.dupe(bool, facts.identity_free),
        .fresh_outputs = try owned.dupe(bool, facts.fresh_outputs),
        .uniqueness = try copyPlans(owned, facts.uniqueness),
        .basis = basis,
        .entry_summaries = try owned.create(Uniqueness.Summaries),
    };

    value.entry_summaries.?.* = try .create(owned, program, basis);

    return .{ .arena = arena, .value = value };
}

pub fn analyze(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, basis: *const Uniqueness.Basis, memo: ?*Uniqueness.Memo) std.mem.Allocator.Error!Self {
    // Uniqueness, the costliest pass, reads only the program and the basis, so it runs beside the others.
    var uniqueness = Concurrent{ .arena = .init(workspace), .workspace = workspace, .program = program, .exported = exported, .basis = basis, .memo = memo };

    defer uniqueness.arena.deinit();

    const thread = std.Thread.spawn(.{}, Concurrent.run, .{&uniqueness}) catch null;

    if (thread == null) uniqueness.run();

    const others = remaining(allocator, workspace, program);
    const errors = @import("zx").error_effects.perFunction(allocator, program.types, program.functions);
    const identity_free = if (others) |value| @import("iteration_layout/identity_free.zig").functions(allocator, program, value.value.pure) else |err| err;

    if (thread) |running| running.join();

    var value = try others;

    value.errors = try errors;
    value.identity_free = try identity_free;
    value.fresh_outputs = try freshOutputs(allocator, program);
    value.uniqueness = try copyPlans(allocator, try uniqueness.result);
    value.basis = basis;

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
fn remaining(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!Self {
    if (@import("genz_options").generated_analysis) {
        const generated = try @import("function_analysis/generated.zig").analyze(allocator, workspace, program);

        return .{
            .value = generated.value,
            .io = generated.io,
            .process = generated.process,
            .tasks = generated.tasks,
            .uniqueness = undefined,
            .basis = undefined,
        };
    }

    return .{
        .value = try @import("value_call/analysis.zig").analyze(allocator, program),
        .io = try @import("io.zig").functions(allocator, program),
        .process = try @import("capabilities.zig").functions(allocator, program, .process),
        .tasks = try @import("tasks/allocator.zig").functions(allocator, program),
        .uniqueness = undefined,
        .basis = undefined,
    };
}

const Concurrent = struct {
    arena: std.heap.ArenaAllocator,
    workspace: std.mem.Allocator,
    program: ir.Program,
    exported: []const ir.FunctionId,
    basis: *const Uniqueness.Basis,
    memo: ?*Uniqueness.Memo,
    result: std.mem.Allocator.Error!Uniqueness.Result = error.OutOfMemory,
    fn run(self: *Concurrent) void {
        self.result = Uniqueness.analyze(self.arena.allocator(), self.workspace, self.program, self.exported, self.basis, self.memo);
    }
};

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
    const renewals = try allocator.alloc(Uniqueness.Renewal, source.renewals.len);

    for (source.renewals, renewals) |renewal, *target| target.* = .{ .owner = renewal.owner, .path = try allocator.dupe(u32, renewal.path) };

    return .{ .flags = try allocator.dupe(Uniqueness.Flags, source.flags), .renewals = renewals };
}
