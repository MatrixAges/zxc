const std = @import("std");
const ast = @import("ast.zig");
const diagnostic = @import("diagnostic.zig");

pub const Bounds = struct {
    min: usize = 0,
    max: usize = std.math.maxInt(usize),
};

pub const empty = sequence(.{});

pub fn list(comptime Child: type, comptime bounds: Bounds) type {
    if (bounds.min > bounds.max) @compileError("DSL list min exceeds max");

    return struct {
        pub const Data = []const Child.Data;

        pub fn decode(allocator: std.mem.Allocator, node: ast.Node, reporter: *diagnostic.Reporter, context: anytype) diagnostic.Error!Data {
            if (node.children.len < bounds.min or node.children.len > bounds.max) return countError(node, reporter, bounds);

            const values = try allocator.alloc(Child.Data, node.children.len);

            for (node.children, values) |child, *value| {
                value.* = try Child.decode(allocator, child, reporter, context);
            }

            return values;
        }
    };
}

pub fn sequence(comptime schemas: anytype) type {
    const types = blk: {
        var result: [schemas.len]type = undefined;

        for (schemas, 0..) |Schema, index| result[index] = Schema.Data;

        break :blk result;
    };

    return struct {
        pub const Data = std.meta.Tuple(&types);

        pub fn decode(allocator: std.mem.Allocator, node: ast.Node, reporter: *diagnostic.Reporter, context: anytype) diagnostic.Error!Data {
            if (node.children.len != schemas.len) return countError(node, reporter, .{ .min = schemas.len, .max = schemas.len });

            var values: Data = undefined;

            inline for (schemas, 0..) |Schema, index| {
                values[index] = try Schema.decode(allocator, node.children[index], reporter, context);
            }

            return values;
        }
    };
}

pub fn choice(comptime schemas: anytype) type {
    const fields = std.meta.fields(@TypeOf(schemas));

    if (fields.len == 0) @compileError("DSL choice requires at least one schema");

    const allowed_names = blk: {
        var names: []const []const u8 = &.{};

        for (fields) |field| {
            for (@field(schemas, field.name).names) |name| {
                for (names) |previous| {
                    if (std.mem.eql(u8, previous, name)) @compileError("Ambiguous DSL choice element: " ++ name);
                }

                names = names ++ .{name};
            }
        }

        break :blk names;
    };

    const DataType = blk: {
        var types: [fields.len]type = undefined;

        for (fields, 0..) |field, index| {
            types[index] = @field(schemas, field.name).Data;
        }

        break :blk @Union(.auto, std.meta.FieldEnum(@TypeOf(schemas)), std.meta.fieldNames(@TypeOf(schemas)), &types, &@splat(.{}));
    };

    return struct {
        pub const Data = DataType;
        pub const names = allowed_names;

        pub fn matches(name: []const u8) bool {
            inline for (fields) |field| {
                if (@field(schemas, field.name).matches(name)) return true;
            }

            return false;
        }
        pub fn decode(allocator: std.mem.Allocator, node: ast.Node, reporter: *diagnostic.Reporter, context: anytype) diagnostic.Error!Data {
            inline for (fields) |field| {
                const Schema = @field(schemas, field.name);

                if (Schema.matches(node.name)) return @unionInit(Data, field.name, try Schema.decode(allocator, node, reporter, context));
            }

            return reporter.fail(.{
                .code = .unexpected_element,
                .location = node.location,
                .element = node.name,
                .message = "Element does not match any allowed alternative",
            });
        }
    };
}

fn countError(node: ast.Node, reporter: *diagnostic.Reporter, bounds: Bounds) diagnostic.Error {
    return reporter.fail(.{
        .code = .child_count,
        .location = if (node.children.len > bounds.max) node.children[bounds.max].location else node.location,
        .element = node.name,
        .child_count = .{ .min = bounds.min, .max = bounds.max, .actual = node.children.len },
        .message = "Number of child elements does not match the schema",
    });
}
