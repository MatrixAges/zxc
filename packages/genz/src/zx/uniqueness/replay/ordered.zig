const std = @import("std");
const storage = @import("zx").columns.storage;
const Memo = @import("../memo.zig");

pub fn agree(comptime kind: Memo.Kind, allocator: std.mem.Allocator, left: Memo.Result(kind), right: Memo.Result(kind)) std.mem.Allocator.Error!bool {
    const comparison = switch (kind) {
        .settled => @import("generated_uniqueness_replay_settled"),
        .planned => @import("generated_uniqueness_replay_planned"),
        .demanded => @import("generated_uniqueness_replay_demanded"),
    };

    const Parameter = @typeInfo(@TypeOf(comparison.executeValue)).@"fn".param_types[1].?;
    const indirect = @typeInfo(Parameter) == .pointer;
    const Input = if (indirect) std.meta.Child(Parameter) else Parameter;
    const Field = @FieldType(Input, "left");
    const referenced = @typeInfo(Field) == .pointer;
    const Record = if (referenced) std.meta.Child(Field) else Field;
    const left_view = if (kind == .planned) plannedView(Record, &left) else storage.view(Record, left);
    const right_view = if (kind == .planned) plannedView(Record, &right) else storage.view(Record, right);

    const input: Input = .{
        .left = if (referenced) &left_view else left_view,
        .right = if (referenced) &right_view else right_view,
    };

    return comparison.executeValue(allocator, if (indirect) &input else input) catch |err| switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        else => std.debug.panic("ordered replay comparison failed: {s}", .{@errorName(err)}),
    };
}

fn plannedView(comptime Target: type, plan: *const Memo.Planned) Target {
    return storage.view(Target, .{
        .flags = plan.flags,
        .renewals = &plan.renewals,
        .transfers = plan.transfers,
        .slot_first = plan.slot_first,
    });
}
