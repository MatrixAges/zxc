const std = @import("std");
const ast = @import("ast.zig");
const diagnostic = @import("diagnostic.zig");

pub fn checkType(comptime T: type) void {
    switch (@typeInfo(T)) {
        .bool, .int, .float, .@"enum" => {},
        .optional => |info| checkType(info.child),
        else => if (T != []const u8) @compileError("Unsupported DSL attribute type: " ++ @typeName(T)),
    }
}

pub fn decode(comptime T: type, input: anytype, reporter: *diagnostic.Reporter) diagnostic.Error!T {
    const node = ast.view(input);
    const info = @typeInfo(T).@"struct";
    var slots: [info.field_names.len]usize = @splat(0);

    for (0..node.attributeCount()) |index| {
        const attribute = node.schemaAttribute(index);

        const slot = for (info.field_names, 0..) |field_name, ordinal| {
            if (std.mem.eql(u8, field_name, attribute.name)) break ordinal;
        } else return reporter.fail(.{
            .code = .unknown_attribute,
            .location = attribute.location,
            .element = node.name(),
            .attribute = attribute.name,
            .message = "Attribute is not allowed on this element",
        });

        if (slots[slot] != 0) return reporter.fail(.{
            .code = .duplicate_attribute,
            .location = attribute.location,
            .element = node.name(),
            .attribute = attribute.name,
            .message = "Attribute occurs more than once",
        });

        slots[slot] = index + 1;
    }

    var result: T = undefined;

    inline for (info.field_names, info.field_types, info.field_attrs, slots) |field_name, field_type, field_attrs, index| {
        if (index != 0) {
            const attribute = node.schemaAttribute(index - 1);
            const source = if (attribute.kind == .expression) std.mem.trim(u8, attribute.value, " \t\r\n") else attribute.value;

            @field(result, field_name) = convert(field_type, source) catch return reporter.fail(.{
                .code = .invalid_attribute,
                .location = attribute.value_location,
                .element = node.name(),
                .attribute = attribute.name,
                .expected = @typeName(field_type),
                .message = "Attribute value does not match its declared type",
            });
        } else {
            if (field_attrs.defaultValue(field_type)) |value| {
                @field(result, field_name) = value;
            } else if (@typeInfo(field_type) == .optional) {
                @field(result, field_name) = null;
            } else {
                return reporter.fail(.{
                    .code = .missing_attribute,
                    .location = node.location(),
                    .element = node.name(),
                    .attribute = field_name,
                    .expected = @typeName(field_type),
                    .message = "Required attribute is missing",
                });
            }
        }
    }

    return result;
}

fn convert(comptime T: type, value: []const u8) error{InvalidValue}!T {
    if (T == []const u8) return value;

    return switch (@typeInfo(T)) {
        .optional => |info| try convert(info.child, value),
        .bool => if (std.mem.eql(u8, value, "true")) true else if (std.mem.eql(u8, value, "false")) false else error.InvalidValue,
        .int => std.fmt.parseInt(T, value, 10) catch error.InvalidValue,
        .float => blk: {
            const number = std.fmt.parseFloat(T, value) catch return error.InvalidValue;

            if (!std.math.isFinite(number)) return error.InvalidValue;

            break :blk number;
        },
        .@"enum" => std.meta.stringToEnum(T, value) orelse error.InvalidValue,
        else => unreachable,
    };
}
