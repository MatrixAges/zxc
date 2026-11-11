const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const generated = @import("genz_options").generated_analysis;
const renewal = @import("../growth/renew.zig");
pub const Target = renewal.Target;

pub const Plan = struct {
    owner: ir.ExprId,
    entries: bool = false,
    delayed: bool = false,
    immediate: []const []const u32 = &.{},
    pub fn needsEntries(self: Plan, lowering: *const Lower) bool {
        if (generated) return self.entries;

        for (lowering.plan.renewals) |record| {
            if (record.owner == @backingInt(self.owner) and !record.value) return true;
        }

        return false;
    }
    pub fn emit(self: Plan, lowering: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, target: Target) Lower.Error!void {
        if (generated) return renewal.appendEntry(lowering, body, type_id, target, self.immediate);

        for (lowering.plan.renewals) |record| {
            if (record.owner == @backingInt(self.owner) and !record.value) try renew(lowering, body, type_id, target, record.path);
        }
    }
};

pub const Request = struct {
    owner: ir.ExprId,
    type_id: ir.TypeId,
    classify: ?ir.Iteration = null,
    inline_lists: bool = false,
};

pub fn plan(self: *const Lower, temporary: std.mem.Allocator, request: Request) Lower.Error!Plan {
    if (!generated or self.plan.renewals.len == 0) return .{ .owner = request.owner };

    const entry = @import("generated_iteration_renewal_plan");
    const Parameter = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    const Facts = std.meta.Child(@FieldType(Input, "facts"));
    const program = &self.program;
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Facts, "types")), program.types);
    const roots = if (request.classify) |iteration| [2]u32{ @backingInt(iteration.condition), @backingInt(iteration.body) } else undefined;

    const facts: Facts = .{
        .expressions = zx.columns.pointer(@FieldType(Facts, "expressions"), &program.expressions),
        .types = &types,
        .selected = self.state_plan.selected,
        .referenced = self.state_plan.borrowed,
        .roots = if (request.classify != null) &roots else &.{},
        .state_type = @backingInt(request.type_id),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const Records = @FieldType(Input, "records");

    const records = if (@typeInfo(std.meta.Child(Records)) == .pointer)
        try zx.columns.pointers(Records, memory.allocator(), self.plan.renewals)
    else
        zx.columns.slice(Records, self.plan.renewals);

    const input = zx.columns.view(Input, .{
        .facts = &facts,
        .records = records,
        .owner = @backingInt(request.owner),
        .classify = request.classify != null,
        .inline_lists = request.inline_lists,
    });

    const output = entry.executeValue(memory.allocator(), if (indirect) &input else input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    return .{
        .owner = request.owner,
        .entries = output.entries,
        .delayed = output.delayed,
        .immediate = if (output.immediate.len == 0) &.{} else try temporary.dupe([]const u32, output.immediate),
    };
}

fn renew(self: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, target: Target, path: []const u32) Lower.Error!void {
    const reference = switch (target) {
        .reference => |value| value,
        .name => |name| try self.builder.identifier(name),
    };

    return @import("../growth/renew_seed.zig").renew(self, body, type_id, reference, path);
}
