const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const syntax = zx.syntax.borrow;

pub fn parameters(allocator: std.mem.Allocator, view: anytype, values: anytype, reporter: *zx.Reporter) zx.Error!ir.NativeType {
    const children = try allocator.alloc(ir.NativeType, values.len);

    for (children, 0..) |*child, index| child.* = try resolve(allocator, view, syntax.item(values, index), reporter);

    return if (values.len == 1) children[0] else .{ .children = children };
}

fn resolve(allocator: std.mem.Allocator, view: anytype, value: @TypeOf(view).Ref, reporter: *zx.Reporter) zx.Error!ir.NativeType {
    const kind = view.kind(value);

    switch (kind) {
        .named => {
            const name = view.name(value);
            var declarations = view.declarations().iterator();

            while (declarations.next()) |declaration| {
                if (!std.mem.eql(u8, declaration.name.text, name.text)) continue;

                var result = try resolve(allocator, view, declaration.value, reporter);

                result.name = try allocator.dupe(u8, name.text);

                return result;
            }

            return .{};
        },
        .enumeration => return .{},
        .optional, .list, .application => {
            const child = view.child(value);
            const children = try allocator.alloc(ir.NativeType, 1);
            children[0] = try resolve(allocator, view, child, reporter);

            if (kind != .optional and !addressable(view, child, children[0])) return reporter.fail(.unsupported, .{ .start = 0, .end = 0 }, "native arrays of objects, tuples or enums require a named element type exported by the native module");

            return .{ .children = children };
        },
        .tuple => {
            const items = view.children(value);
            const children = try allocator.alloc(ir.NativeType, items.count());
            var iterator = items.iterator();

            for (children) |*child| child.* = try resolve(allocator, view, iterator.next().?, reporter);

            return .{ .children = children };
        },
        .object => {
            const fields = view.fields(value);
            var scratch = std.heap.ArenaAllocator.init(allocator);

            defer scratch.deinit();

            const ordered = try scratch.allocator().alloc(usize, fields.count());
            var positions = fields.positions();

            for (ordered) |*index| index.* = positions.next().?;

            std.mem.sort(usize, ordered, fields, struct {
                fn lessThan(context: @TypeOf(fields), left: usize, right: usize) bool {
                    return std.mem.lessThan(u8, context.atPosition(left).name.text, context.atPosition(right).name.text);
                }
            }.lessThan);

            const children = try allocator.alloc(ir.NativeType, ordered.len);

            for (ordered, children) |index, *child| child.* = try resolve(allocator, view, fields.atPosition(index).value, reporter);

            return .{ .children = children };
        },
    }
}

fn addressable(view: anytype, value: @TypeOf(view).Ref, shape: ir.NativeType) bool {
    if (shape.name != null) return true;

    return switch (view.kind(value)) {
        .named => true,
        .optional, .list, .application => addressable(view, view.child(value), shape.children[0]),
        else => false,
    };
}
