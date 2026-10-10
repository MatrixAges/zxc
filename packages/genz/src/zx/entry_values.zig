const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const Lower = @import("lower.zig");
const buffers = @import("buffer_call/root.zig");
const context = @import("buffer_call/context.zig");

pub fn declarations(lowering: *Lower, output: *std.ArrayList(node.Declaration)) Lower.Error!void {
    if (!@import("value_call/analysis.zig").eligibleEntry(lowering.program, lowering.local_functions)) return;

    const output_type = lowering.program.typeOf(lowering.program.output_type);
    const aggregate = output_type == .object or output_type == .tuple or lowering.state_plan.represented(lowering.program, lowering.program.output_type);
    var value = if (aggregate) try lowering.functionValue("executeValue") else try lowering.function("executeValue", false);

    value.function.exported = true;

    try output.append(lowering.allocator, value);
    if (!@import("value_call/analysis.zig").eligibleEntry(lowering.program, lowering.pure_functions)) return;

    const lanes = try buffers.analysis.entry(lowering.allocator, lowering.workspace, lowering.program, lowering.buffer_functions, lowering.pure_functions);

    if (!buffers.available(lanes)) return;

    var buffered = try buffers.declaration(lowering, "executeBuffered", lanes, .value);

    buffered.function.exported = true;

    try output.append(lowering.allocator, buffered);
    try output.append(lowering.allocator, .{ .constant = .{ .name = "buffer_lanes", .value = try metadata(lowering, lanes), .exported = true } });
}

fn metadata(lowering: *Lower, lanes: []const buffers.Lane) Lower.Error!*const node.Expression {
    var entries: std.ArrayList(*const node.Expression) = .empty;

    for (lanes, 0..) |lane, index| {
        if (lane.rejection != null) continue;

        const fields = try lowering.allocator.dupe(node.Field, &.{
            .{ .name = "slot", .value = try lowering.builder.string(try context.name(lowering, index)) },
            .{ .name = "input", .value = try path(lowering, lowering.program.input_type, lane.input) },
            .{ .name = "output", .value = try path(lowering, lowering.program.output_type, lane.output) },
        });

        try entries.append(lowering.allocator, try lowering.builder.expression(.{ .object = .{ .fields = fields } }));
    }

    return lowering.builder.expression(.{ .tuple = try entries.toOwnedSlice(lowering.allocator) });
}

fn path(lowering: *Lower, root: ir.TypeId, indices: []const u32) Lower.Error!*const node.Expression {
    const names = try lowering.allocator.alloc(*const node.Expression, indices.len);
    var selected = root;

    for (indices, names) |index, *name| switch (lowering.program.typeOf(selected)) {
        .object => |fields| {
            const field = fields.at(index);

            name.* = try lowering.builder.string(field.name);
            selected = field.type_id;
        },
        .tuple => |items| {
            name.* = try lowering.builder.string(try std.fmt.allocPrint(lowering.allocator, "{d}", .{index}));
            selected = items.at(index);
        },
        else => unreachable,
    };

    return lowering.builder.expression(.{ .tuple = names });
}
