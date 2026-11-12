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

        pub fn decode(allocator: std.mem.Allocator, input: anytype, reporter: *diagnostic.Reporter, context: anytype) diagnostic.Error!Data {
            const node = ast.view(input);

            if (node.childCount() < bounds.min or node.childCount() > bounds.max) return countError(node, reporter, bounds);

            const values = try allocator.alloc(Child.Data, node.childCount());
            var children = node.children();

            for (values) |*value| {
                value.* = try Child.decode(allocator, children.next().?, reporter, context);
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
        pub const Data = @Tuple(&types);

        pub fn decode(allocator: std.mem.Allocator, input: anytype, reporter: *diagnostic.Reporter, context: anytype) diagnostic.Error!Data {
            const node = ast.view(input);

            if (node.childCount() != schemas.len) return countError(node, reporter, .{ .min = schemas.len, .max = schemas.len });

            var values: Data = undefined;
            var children = node.children();

            inline for (schemas, 0..) |Schema, index| {
                values[index] = try Schema.decode(allocator, children.next().?, reporter, context);
            }

            return values;
        }
    };
}

pub fn choice(comptime schemas: anytype) type {
    const fields = @typeInfo(@TypeOf(schemas)).@"struct".field_names;

    if (fields.len == 0) @compileError("DSL choice requires at least one schema");

    const allowed_names = blk: {
        var names: []const []const u8 = &.{};

        for (fields) |field| {
            for (@field(schemas, field).names) |name| {
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
            types[index] = @field(schemas, field).Data;
        }

        break :blk @Union(.auto, std.meta.FieldEnum(@TypeOf(schemas)), std.meta.fieldNames(@TypeOf(schemas)), &types, &@splat(.{}));
    };

    return struct {
        pub const Data = DataType;
        pub const names = allowed_names;

        pub fn matches(name: []const u8) bool {
            inline for (fields) |field| {
                if (@field(schemas, field).matches(name)) return true;
            }

            return false;
        }
        pub fn decode(allocator: std.mem.Allocator, input: anytype, reporter: *diagnostic.Reporter, context: anytype) diagnostic.Error!Data {
            const node = ast.view(input);

            inline for (fields) |field| {
                const Schema = @field(schemas, field);

                if (Schema.matches(node.name())) return @unionInit(Data, field, try Schema.decode(allocator, input, reporter, context));
            }

            return reporter.fail(.{
                .code = .unexpected_element,
                .location = node.location(),
                .element = node.name(),
                .message = "Element does not match any allowed alternative",
            });
        }
    };
}

fn countError(input: anytype, reporter: *diagnostic.Reporter, bounds: Bounds) diagnostic.Error {
    const node = ast.view(input);

    return reporter.fail(.{
        .code = .child_count,
        .location = if (node.childCount() > bounds.max) ast.view(ast.childAt(node, bounds.max)).location() else node.location(),
        .element = node.name(),
        .child_count = .{ .min = bounds.min, .max = bounds.max, .actual = node.childCount() },
        .message = "Number of child elements does not match the schema",
    });
}
