const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn declaration(lowering: *Lower, exported: bool) Lower.Error!node.Declaration {
    const type_type = try lowering.builder.expression(.{ .primitive = .type });
    const element = try lowering.builder.identifier("zx_element");
    const standard = try lowering.builtin(.import, &.{try lowering.builder.string("std")});
    const buffer = try lowering.call(try lowering.field(standard, "ArrayList"), &.{element}, false);

    const fields = try lowering.allocator.dupe(node.Field, &.{
        .{ .name = "buffer", .value = try lowering.builder.expression(.{ .pointer = buffer }) },
        .{ .name = "started", .value = try lowering.builder.expression(.{ .pointer = try lowering.builder.expression(.{ .primitive = .bool }) }) },
    });

    return .{ .function = .{
        .name = "zxBufferSlot",
        .parameters = try lowering.allocator.dupe(node.Field, &.{.{ .name = "zx_element", .value = type_type, .comptime_parameter = true }}),
        .return_type = type_type,
        .body = try lowering.allocator.dupe(node.Statement, &.{.{ .result = try lowering.builder.expression(.{ .struct_type = fields }) }}),
        .exported = exported,
    } };
}

pub fn typeOf(lowering: *Lower, element: *const node.Expression) Lower.Error!*const node.Expression {
    const factory = if (lowering.shared_types)
        try lowering.field(try lowering.builder.identifier("zx_abi"), "zxBufferSlot")
    else
        try lowering.builder.identifier("zxBufferSlot");

    return lowering.call(factory, &.{element}, false);
}
