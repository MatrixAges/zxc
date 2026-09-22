const std = @import("std");
const ast = @import("ast.zig");
const attributes = @import("attributes.zig");
const diagnostic = @import("diagnostic.zig");

pub fn element(comptime name: []const u8, comptime Attributes: type, comptime Children: type) type {
    if (name.len == 0) @compileError("DSL element name cannot be empty");
    if (@typeInfo(Attributes) != .@"struct") @compileError("DSL attributes must be a struct");

    for (std.meta.fields(Attributes)) |field| {
        if (field.is_comptime) @compileError("DSL attributes must be runtime fields");

        attributes.checkType(field.type);
    }

    return struct {
        pub const names: []const []const u8 = &.{name};

        pub const Data = struct {
            attributes: Attributes,
            children: Children.Data,
        };
        pub fn matches(actual: []const u8) bool {
            return std.mem.eql(u8, name, actual);
        }
        pub fn decode(allocator: std.mem.Allocator, node: ast.Node, reporter: *diagnostic.Reporter, context: anytype) diagnostic.Error!Data {
            if (!matches(node.name)) return reporter.fail(.{
                .code = .unexpected_element,
                .location = node.location,
                .element = node.name,
                .expected = name,
                .message = "Element is not allowed at this position",
            });

            const values = try attributes.decode(Attributes, node, reporter);

            for (node.text) |text| {
                if (std.mem.trim(u8, text.value, " \t\r\n").len != 0) return reporter.fail(.{
                    .code = .unexpected_text,
                    .location = text.location,
                    .element = node.name,
                    .message = "Only elements and whitespace are allowed here",
                });
            }

            return .{
                .attributes = values,
                .children = try Children.decode(allocator, node, reporter, context),
            };
        }
    };
}
