const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const buffers = @import("root.zig");

pub fn declaration(lowering: *Lower, name: []const u8, callee: node.ExpressionId, lanes: []const buffers.Lane) Lower.Error!node.Declaration {
    const state = if (lowering.state_plan.represented(lowering.program, lowering.program.output_type)) try @import("../state_value/root.zig").enter(lowering) else null;

    defer if (state) |saved| saved.restore();

    const slots = try lowering.allocator.alloc(?@import("../object_reduce/append/builder.zig"), lanes.len);

    @memset(slots, null);

    const argument = try @import("context.zig").argument(lowering, lowering.program.output_type, lanes, slots);
    const result = try lowering.call(callee, &.{ try lowering.builder.identifier("allocator"), try lowering.builder.identifier("in"), argument }, false);
    const errors = try @import("zx").error_effects.program(lowering.allocator, lowering.program);

    return .{ .function = .{
        .name = name,
        .parameters = try lowering.allocator.dupe(node.Field, &.{
            .{ .name = "allocator", .value = try @import("../intrinsics.zig").standardField(lowering, &.{ "mem", "Allocator" }) },
            .{ .name = "in", .value = lowering.types[@backingInt(lowering.program.input_type)] },
        }),
        .return_type = try lowering.builder.expression(.{ .error_union = .{ .payload = lowering.layouts[@backingInt(lowering.program.output_type)], .errors = errors } }),
        .body = try lowering.builder.statements(&.{.{ .result = result }}),
        .inlined = true,
    } };
}
