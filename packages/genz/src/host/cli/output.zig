const std = @import("std");
const node = @import("../../node.zig");
const Builder = @import("../../builder.zig");

pub fn lower(builder: Builder) std.mem.Allocator.Error!node.Statement {
    const interface = try builder.path(&.{ "file", "interface" });
    const write_null = try builder.call(try builder.field(interface, "writeAll"), &.{try builder.string("null")});
    const write_json = try builder.call(try builder.path(&.{ "std", "json", "Stringify", "value" }), &.{ try builder.identifier("output"), try builder.object(&.{}), try builder.expression(.{ .address_of = interface }) });
    const enabled = try builder.field(try builder.builtin(.import, &.{try builder.string("result.zig")}), "emit");

    return builder.branch(enabled, &.{
        .{ .variable = .{ .name = "buffer", .type_expr = try builder.expression(.{ .fixed_array_type = .{ .length = try builder.integer(4096), .element = try builder.expression(.{ .primitive = .u8 }) } }), .value = try builder.expression(.undefined_value) } },
        .{ .variable = .{ .name = "file", .value = try builder.call(try builder.path(&.{ "std", "Io", "File", "Writer", "initStreaming" }), &.{
            try builder.call(try builder.expression(.{ .enum_literal = "stdout" }), &.{}),
            try builder.path(&.{ "init", "io" }),
            try builder.expression(.{ .address_of = try builder.identifier("buffer") }),
        }) } },
        try builder.branch(try builder.binary(.equal, try builder.path(&.{ "application", "Output" }), try builder.expression(.{ .primitive = .void })), &.{.{ .expression = try builder.expression(.{ .try_value = write_null }) }}, &.{.{ .expression = try builder.expression(.{ .try_value = write_json }) }}),
        .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.field(interface, "writeByte"), &.{try builder.integer('\n')}) }) },
        .{ .expression = try builder.expression(.{ .try_value = try builder.call(try builder.field(interface, "flush"), &.{}) }) },
    }, &.{});
}
