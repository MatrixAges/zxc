const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const syntax = zx.syntax.borrow;

pub fn parameters(allocator: std.mem.Allocator, view: anytype, values: anytype, reporter: *zx.Reporter) zx.Error!ir.NativeType {
    var names: std.ArrayList(?[]const u8) = .empty;

    if (values.len != 1) try names.append(allocator, null);
    for (0..values.len) |index| try resolve(allocator, view, syntax.item(values, index), &names, reporter);

    return .{ .names = try names.toOwnedSlice(allocator) };
}

fn resolve(allocator: std.mem.Allocator, view: anytype, value: @TypeOf(view).Ref, names: *std.ArrayList(?[]const u8), reporter: *zx.Reporter) zx.Error!void {
    const kind = view.kind(value);

    if (kind == .named) {
        const name = view.name(value);
        var declarations = view.declarations().iterator();

        while (declarations.next()) |declaration| {
            if (!std.mem.eql(u8, declaration.name.text, name.text)) continue;

            const start = names.items.len;

            try resolve(allocator, view, declaration.value, names, reporter);

            names.items[start] = try allocator.dupe(u8, name.text);

            return;
        }

        try names.append(allocator, null);

        return;
    }

    try names.append(allocator, null);

    switch (kind) {
        .named => unreachable,
        .enumeration => {},
        .optional, .list, .application => {
            const child = view.child(value);

            try resolve(allocator, view, child, names, reporter);

            if (kind != .optional and !addressable(view, child)) return reporter.fail(.unsupported, .{ .start = 0, .end = 0 }, "native arrays of objects, tuples or enums require a named element type exported by the native module");
        },
        .tuple => {
            var iterator = view.children(value).iterator();

            while (iterator.next()) |child| try resolve(allocator, view, child, names, reporter);
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

            for (ordered) |index| try resolve(allocator, view, fields.atPosition(index).value, names, reporter);
        },
    }
}

fn addressable(view: anytype, value: @TypeOf(view).Ref) bool {
    return switch (view.kind(value)) {
        .named => true,
        .optional, .list, .application => addressable(view, view.child(value)),
        else => false,
    };
}
