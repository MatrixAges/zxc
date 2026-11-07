const std = @import("std");
const zx = @import("zx");
const Context = @import("context.zig");
const model = @import("model.zig");

pub fn append(context: *Context, source: *const zx.ast.BindingPattern, previous: u64, key: ?zx.ast.Name) std.mem.Allocator.Error!u64 {
    var head: u64 = 0;
    var count: u64 = 0;
    var name: []const u8 = "";

    const kind: @FieldType(model.Name, "kind") = switch (source.value) {
        .name => |binding| value: {
            name = binding.text;

            break :value .Name;
        },
        .object => |fields| value: {
            for (fields) |field| {
                head = try append(context, field.pattern, head, field.key) + 1;
                count += 1;
            }

            break :value .Object;
        },
        .sequence => |items| value: {
            for (items) |item| {
                if (item) |child| {
                    head = try append(context, child, head, null) + 1;
                } else {
                    try context.names.append(context.allocator, try context.keep(model.Name, .{
                        .span = try context.span(source.span),
                        .previous = head,
                        .kind = .Hole,
                        .key = &model.empty_span,
                        .head = 0,
                        .count = 0,
                    }));

                    try context.destructure_names.append(context.allocator, "_");
                    try context.binding_keys.append(context.allocator, "");

                    head = context.names.items.len;
                }

                count += 1;
            }

            break :value .Sequence;
        },
    };

    const index = context.names.items.len;

    try context.names.append(context.allocator, try context.keep(model.Name, .{
        .span = try context.span(source.span),
        .previous = previous,
        .kind = kind,
        .key = if (key) |field| try context.span(field.span) else &model.empty_span,
        .head = head,
        .count = count,
    }));

    try context.destructure_names.append(context.allocator, name);
    try context.binding_keys.append(context.allocator, if (key) |field| field.text else "");

    return index;
}
