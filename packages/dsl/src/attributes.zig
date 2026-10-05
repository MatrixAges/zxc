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

pub fn decode(comptime T: type, node: ast.Node, reporter: *diagnostic.Reporter) diagnostic.Error!T {
    const fields = std.meta.fields(T);

    for (node.attributes, 0..) |attribute, index| {
        var known = false;

        inline for (fields) |field| {
            if (std.mem.eql(u8, field.name, attribute.name)) known = true;
        }

        if (!known) return reporter.fail(.{
            .code = .unknown_attribute,
            .location = attribute.location,
            .element = node.name,
            .attribute = attribute.name,
            .message = "Attribute is not allowed on this element",
        });

        for (node.attributes[0..index]) |previous| {
            if (std.mem.eql(u8, previous.name, attribute.name)) return reporter.fail(.{
                .code = .duplicate_attribute,
                .location = attribute.location,
                .element = node.name,
                .attribute = attribute.name,
                .message = "Attribute occurs more than once",
            });
        }
    }

    var result: T = undefined;

    inline for (fields) |field| {
        var found = false;

        for (node.attributes) |attribute| {
            if (!std.mem.eql(u8, field.name, attribute.name)) continue;

            const source = if (attribute.kind == .expression) std.mem.trim(u8, attribute.value, " \t\r\n") else attribute.value;

            @field(result, field.name) = convert(field.type, source) catch return reporter.fail(.{
                .code = .invalid_attribute,
                .location = attribute.value_location,
                .element = node.name,
                .attribute = attribute.name,
                .expected = @typeName(field.type),
                .message = "Attribute value does not match its declared type",
            });

            found = true;

            break;
        }

        if (!found) {
            if (field.defaultValue()) |value| {
                @field(result, field.name) = value;
            } else if (@typeInfo(field.type) == .optional) {
                @field(result, field.name) = null;
            } else {
                return reporter.fail(.{
                    .code = .missing_attribute,
                    .location = node.location,
                    .element = node.name,
                    .attribute = field.name,
                    .expected = @typeName(field.type),
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
