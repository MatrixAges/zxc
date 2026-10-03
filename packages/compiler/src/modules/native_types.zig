const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;

pub fn parameters(allocator: std.mem.Allocator, declarations: []const zx.ast.Declaration, values: []const *const zx.ast.Type, reporter: *zx.Reporter) zx.Error!ir.NativeType {
    const children = try allocator.alloc(ir.NativeType, values.len);

    for (values, children) |value, *child| child.* = try resolve(allocator, declarations, value, reporter);

    return if (values.len == 1) children[0] else .{ .children = children };
}

fn resolve(allocator: std.mem.Allocator, declarations: []const zx.ast.Declaration, value: *const zx.ast.Type, reporter: *zx.Reporter) zx.Error!ir.NativeType {
    switch (value.*) {
        .named => |name| {
            for (declarations) |declaration| {
                if (!std.mem.eql(u8, declaration.name.text, name.text)) continue;

                var result = try resolve(allocator, declarations, declaration.value, reporter);

                result.name = try allocator.dupe(u8, name.text);

                return result;
            }

            return .{};
        },
        .enumeration => return .{},
        .optional, .list, .application => {
            const child = switch (value.*) {
                .optional => |item| item,
                .list => |item| item,
                .application => |item| item.argument,
                else => unreachable,
            };

            const children = try allocator.alloc(ir.NativeType, 1);

            children[0] = try resolve(allocator, declarations, child, reporter);

            if (value.* != .optional and !addressable(child, children[0])) return reporter.fail(.unsupported, .{ .start = 0, .end = 0 }, "native arrays of objects, tuples or enums require a named element type exported by the native module");

            return .{ .children = children };
        },
        .tuple => |items| {
            const children = try allocator.alloc(ir.NativeType, items.len);

            for (items, children) |item, *child| child.* = try resolve(allocator, declarations, item, reporter);

            return .{ .children = children };
        },
        .object => |fields| {
            const ordered = try allocator.dupe(zx.ast.TypeField, fields);

            std.mem.sort(zx.ast.TypeField, ordered, {}, lessThan);

            const children = try allocator.alloc(ir.NativeType, ordered.len);

            for (ordered, children) |field, *child| child.* = try resolve(allocator, declarations, field.value, reporter);

            return .{ .children = children };
        },
    }
}

fn addressable(value: *const zx.ast.Type, shape: ir.NativeType) bool {
    if (shape.name != null) return true;

    return switch (value.*) {
        .named => true,
        .optional, .list => |child| addressable(child, shape.children[0]),
        .application => |item| addressable(item.argument, shape.children[0]),
        else => false,
    };
}

fn lessThan(_: void, left: zx.ast.TypeField, right: zx.ast.TypeField) bool {
    return std.mem.lessThan(u8, left.name.text, right.name.text);
}
