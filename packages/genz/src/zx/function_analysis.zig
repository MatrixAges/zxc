const std = @import("std");
const ir = @import("zx").ir;
pub const Uniqueness = @import("uniqueness/root.zig");
const Self = @This();

value: @import("value_call/analysis.zig").Summary,
io: []const bool,
process: []const bool,
/// Functions that start tasks, themselves or through their callees.
tasks: []const bool,
uniqueness: Uniqueness.Result,
basis: *const Uniqueness.Basis,
/// Replaces the entry plan with one for `program`, an entry body over the same types and functions the facts were
/// computed for.
pub fn reentry(self: *Self, allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program) std.mem.Allocator.Error!void {
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
        .uniqueness = try copyPlans(owned, facts.uniqueness),
        .basis = basis,
    };

    return .{ .arena = arena, .value = value };
}

pub fn analyze(allocator: std.mem.Allocator, workspace: std.mem.Allocator, program: ir.Program, exported: []const ir.FunctionId, basis: *const Uniqueness.Basis, memo: ?*Uniqueness.Memo) std.mem.Allocator.Error!Self {
    if (@import("genz_options").generated_analysis) {
        const facts = try @import("function_analysis/generated.zig").analyze(allocator, workspace, program);

        return .{
            .value = facts.value,
            .io = facts.io,
            .process = facts.process,
            .tasks = try @import("tasks/allocator.zig").functions(allocator, program),
            .uniqueness = try Uniqueness.analyze(allocator, workspace, program, exported, basis, memo),
            .basis = basis,
        };
    }

    return .{
        .value = try @import("value_call/analysis.zig").analyze(allocator, program),
        .io = try @import("io.zig").functions(allocator, program),
        .process = try @import("capabilities.zig").functions(allocator, program, .process),
        .tasks = try @import("tasks/allocator.zig").functions(allocator, program),
        .uniqueness = try Uniqueness.analyze(allocator, workspace, program, exported, basis, memo),
        .basis = basis,
    };
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
