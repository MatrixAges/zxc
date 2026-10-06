const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");

pub fn lower(builder: Builder) std.mem.Allocator.Error!node.Declaration {
    const bytes = try builder.identifier("bytes");
    const byte = try builder.identifier("byte");
    const offset = try builder.identifier("offset");
    const first_end = try builder.identifier("first_end");
    const length = try builder.identifier("length");
    const line = try builder.identifier("line");
    const colon = try builder.identifier("colon");
    const zero = try builder.integer(0);
    const two = try builder.integer(2);
    const u8_type = try builder.expression(.{ .primitive = .u8 });
    const invalid = try builder.expression(.{ .boolean = false });
    const missing = try builder.expression(.{ .return_value = invalid });
    const crlf = try builder.string("\r\n");
    const index_of = try builder.path(&.{ "std", "mem", "indexOf" });
    const index_scalar = try builder.path(&.{ "std", "mem", "indexOfScalar" });
    const remaining = try builder.expression(.{ .slice = .{ .target = bytes, .start = offset } });
    const control = try builder.binary(.less, byte, try builder.integer(0x20));
    const delete = try builder.binary(.equal, byte, try builder.integer(0x7f));
    const valid_name = try builder.call(try builder.path(&.{ "std", "ascii", "isAlphanumeric" }), &.{byte});
    const punctuation = try builder.call(index_scalar, &.{ u8_type, try builder.string("!#$%&'*+-.^_`|~"), byte });
    const invalid_name = try builder.binary(.logical_and, try builder.expression(.{ .unary = .{ .operator = .not, .operand = valid_name } }), try builder.binary(.equal, punctuation, try builder.expression(.null_value)));
    const invalid_value = try builder.binary(.logical_or, try builder.binary(.logical_and, control, try builder.binary(.not_equal, byte, try builder.integer('\t'))), delete);

    return .{ .function = .{
        .name = "validHead",
        .parameters = try builder.allocator.dupe(node.Field, &.{.{ .name = "bytes", .value = try builder.expression(.{ .const_slice = u8_type }) }}),
        .return_type = try builder.expression(.{ .primitive = .bool }),
        .body = try builder.statements(&.{
            .{ .constant = .{ .name = "first_end", .value = try builder.binary(.coalesce, try builder.call(index_of, &.{ u8_type, bytes, crlf }), missing) } },
            .{ .for_loop = .{
                .iterable = try builder.expression(.{ .slice = .{ .target = bytes, .start = zero, .end = first_end } }),
                .capture = "byte",
                .body = try builder.statements(&.{try builder.branch(try builder.binary(.logical_or, control, delete), &.{.{ .result = invalid }}, &.{})}),
            } },
            .{ .variable = .{ .name = "offset", .value = try builder.binary(.add, first_end, two) } },
            .{ .while_loop = .{
                .condition = try builder.binary(.less, offset, try builder.field(bytes, "len")),
                .body = try builder.statements(&.{
                    .{ .constant = .{ .name = "length", .value = try builder.binary(.coalesce, try builder.call(index_of, &.{ u8_type, remaining, crlf }), missing) } },
                    .{ .constant = .{ .name = "line", .value = try builder.expression(.{ .slice = .{ .target = remaining, .start = zero, .end = length } }) } },
                    .{ .assignment = .{ .target = offset, .value = try builder.binary(.add, offset, try builder.binary(.add, length, two)) } },
                    try builder.branch(try builder.binary(.equal, try builder.field(line, "len"), zero), &.{.{ .result = try builder.binary(.equal, offset, try builder.field(bytes, "len")) }}, &.{}),
                    .{ .constant = .{ .name = "colon", .value = try builder.binary(.coalesce, try builder.call(index_scalar, &.{ u8_type, line, try builder.integer(':') }), missing) } },
                    try builder.branch(try builder.binary(.equal, colon, zero), &.{.{ .result = invalid }}, &.{}),
                    .{ .for_loop = .{
                        .iterable = try builder.expression(.{ .slice = .{ .target = line, .start = zero, .end = colon } }),
                        .capture = "byte",
                        .body = try builder.statements(&.{try builder.branch(invalid_name, &.{.{ .result = invalid }}, &.{})}),
                    } },
                    .{ .for_loop = .{
                        .iterable = try builder.expression(.{ .slice = .{ .target = line, .start = try builder.binary(.add, colon, try builder.integer(1)) } }),
                        .capture = "byte",
                        .body = try builder.statements(&.{try builder.branch(invalid_value, &.{.{ .result = invalid }}, &.{})}),
                    } },
                }),
            } },
            .{ .result = invalid },
        }),
    } };
}
