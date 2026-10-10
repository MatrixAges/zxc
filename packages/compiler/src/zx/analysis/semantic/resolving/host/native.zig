const std = @import("std");
const ast = @import("zx").ast;
const model = @import("model.zig");
const Self = @This();
const Pending = struct { value: *const ast.Type, node: *model.Node };

allocator: std.mem.Allocator,
nodes: std.ArrayList(*const model.Node) = .empty,
fields: std.ArrayList(*const model.Field) = .empty,
items: std.ArrayList(*const model.Item) = .empty,
declarations: std.ArrayList(*const model.Entry) = .empty,
enumerations: std.ArrayList(*const model.Enumeration) = .empty,
members: std.ArrayList(*const model.Name) = .empty,
references: std.AutoHashMapUnmanaged(*const ast.Type, *const model.Reference) = .empty,
pending: std.ArrayList(Pending) = .empty,
pub fn prepare(self: *Self, declarations: []const ast.Declaration, root: ?*const ast.Type) std.mem.Allocator.Error!struct { source: *const model.Native, reference: model.Reference } {
    for (declarations) |declaration| {
        const name = try self.keep(model.Name, named(declaration.name));
        const declared = try self.reference(declaration.value);

        try self.declarations.append(self.allocator, try self.keep(model.Entry, .{ .name = name, .value = declared }));
    }

    const root_reference = if (root) |value| (try self.reference(value)).* else model.empty_reference;

    while (self.pending.pop()) |pending| try self.fill(pending);

    return .{ .source = try self.keep(model.Native, .{
        .nodes = self.nodes.items,
        .fields = self.fields.items,
        .items = self.items.items,
        .declarations = self.declarations.items,
        .enumerations = self.enumerations.items,
        .members = self.members.items,
    }), .reference = root_reference };
}

pub fn reference(self: *Self, value: *const ast.Type) std.mem.Allocator.Error!*const model.Reference {
    if (self.references.get(value)) |found| return found;

    const enumeration = value.* == .enumeration;
    const result = try self.keep(model.Reference, .{ .enumeration = enumeration, .index = if (enumeration) self.enumerations.items.len else self.nodes.items.len });

    try self.references.put(self.allocator, value, result);

    if (enumeration) {
        const first = self.members.items.len;

        for (value.enumeration) |member| try self.members.append(self.allocator, try self.keep(model.Name, named(member)));
        try self.enumerations.append(self.allocator, try self.keep(model.Enumeration, .{ .first = first, .count = value.enumeration.len }));
    } else {
        const node = try self.allocator.create(model.Node);

        try self.nodes.append(self.allocator, node);
        try self.pending.append(self.allocator, .{ .value = value, .node = node });
    }

    return result;
}

fn fill(self: *Self, pending: Pending) std.mem.Allocator.Error!void {
    var result: model.Node = .{ .kind = .Named, .name = &model.empty_name, .child = &model.empty_reference, .count = 0, .position = 0 };

    switch (pending.value.*) {
        .named => |name| result.name = try self.keep(model.Name, named(name)),
        .optional, .list => |child| {
            result.kind = if (pending.value.* == .optional) .Optional else .List;
            result.child = try self.reference(child);
        },
        .application => |application| {
            result.kind = .Application;
            result.name = try self.keep(model.Name, named(application.name));
            result.child = try self.reference(application.argument);
        },
        .object => |fields| {
            result.kind = .Object;
            result.count = fields.len;
            result.position = if (fields.len == 0) 0 else self.fields.items.len + 1;

            for (fields, 0..) |field, index| {
                const name = try self.keep(model.Name, named(field.name));
                const child = try self.reference(field.value);
                const next = if (index + 1 == fields.len) 0 else self.fields.items.len + 2;

                try self.fields.append(self.allocator, try self.keep(model.Field, .{ .name = name, .value = child, .next = next }));
            }
        },
        .tuple => |items| {
            result.kind = .Tuple;
            result.count = items.len;
            result.position = if (items.len == 0) 0 else self.items.items.len + 1;

            for (items, 0..) |item, index| {
                const child = try self.reference(item);
                const next = if (index + 1 == items.len) 0 else self.items.items.len + 2;

                try self.items.append(self.allocator, try self.keep(model.Item, .{ .value = child, .next = next }));
            }
        },
        .enumeration => unreachable,
    }

    pending.node.* = result;
}

fn keep(self: *Self, comptime T: type, value: T) std.mem.Allocator.Error!*const T {
    const result = try self.allocator.create(T);

    result.* = value;

    return result;
}

pub fn named(name: ast.Name) model.Name {
    return .{ .text = name.text, .start = name.span.start, .end = name.span.end };
}
