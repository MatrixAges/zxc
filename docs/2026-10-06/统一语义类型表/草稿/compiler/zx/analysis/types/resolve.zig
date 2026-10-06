const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const Types = @import("../types.zig");

pub fn initialize(self: *Types, view: anytype) zx.Error!void {
    const first = self.items.view().count();

    if (first == 0) {
        for (std.enums.values(ir.Scalar)) |scalar| try self.items.append(self.allocator, .{ .scalar = scalar });
    }

    const declarations = view.declarations();

    for (self.aliases, 0..) |alias, index| {
        if (builtin(alias.name) != null or std.mem.eql(u8, alias.name, "Array")) return self.reporter.fail(.name, .{ .start = 0, .end = 0 }, "an imported type cannot replace a built-in type");

        for (self.aliases[0..index]) |previous| {
            if (std.mem.eql(u8, alias.name, previous.name)) return self.reporter.fail(.name, .{ .start = 0, .end = 0 }, "duplicate imported type name");
        }

        var declared = declarations.iterator();

        while (declared.next()) |declaration| {
            if (std.mem.eql(u8, alias.name, declaration.name.text)) return self.reporter.fail(.name, declaration.name.span, "a local type cannot replace an imported type");
        }
    }

    var declared = declarations.iterator();
    var index: usize = 0;

    while (declared.next()) |declaration| : (index += 1) {
        if (builtin(declaration.name.text) != null or std.mem.eql(u8, declaration.name.text, "Array")) return self.reporter.fail(.name, declaration.name.span, "a type cannot replace a built-in scalar");

        var previous = declarations.iterator();

        for (0..index) |_| {
            if (std.mem.eql(u8, previous.next().?.name.text, declaration.name.text)) return self.reporter.fail(.name, declaration.name.span, "duplicate type declaration");
        }
    }

    declared = declarations.iterator();

    while (declared.next()) |declaration| _ = try named(self, view, declaration.name);
    if (self.shared) |shared| try @import("../shared_types.zig").resolve(self, first, shared);
}

pub fn named(self: *Types, view: anytype, name: zx.ast.Name) zx.Error!ir.TypeId {
    if (builtin(name.text)) |scalar| return Types.scalarId(scalar);
    if (self.resolved.get(name.text)) |id| return id;

    for (self.aliases) |alias| {
        if (std.mem.eql(u8, alias.name, name.text)) return alias.type_id;
    }

    if (self.visiting.contains(name.text)) return self.reporter.fail(.type_mismatch, name.span, "recursive type aliases are not supported");
    if (self.visiting.count() >= 256) return self.reporter.fail(.unsupported, name.span, "type alias nesting exceeds 256 levels");

    var declarations = view.declarations().iterator();

    while (declarations.next()) |declaration| {
        if (!std.mem.eql(u8, declaration.name.text, name.text)) continue;
        try self.visiting.put(self.allocator, name.text, {});

        defer _ = self.visiting.remove(name.text);
        const kind = view.kind(declaration.value);

        const id = if (self.native_interface and kind == .named and std.mem.eql(u8, view.name(declaration.value).text, "opaque")) blk: {
            const id: ir.TypeId = @fromBackingInt(@intCast(self.items.view().count()));

            try self.items.append(self.allocator, .{ .native_reference = try self.allocator.dupe(u8, declaration.name.text) });

            break :blk id;
        } else if (kind == .enumeration) try enumeration(self, declaration.name, view.members(declaration.value)) else try node(self, view, declaration.value);

        try self.resolved.put(self.allocator, name.text, id);

        return id;
    }

    return self.reporter.fail(.name, name.span, "unknown or unsupported type");
}

pub fn node(self: *Types, view: anytype, value: @TypeOf(view).Ref) zx.Error!ir.TypeId {
    switch (view.kind(value)) {
        .named => return named(self, view, view.name(value)),
        .optional => return self.wrap(.optional, try node(self, view, view.child(value))),
        .list => return self.wrap(.list, try node(self, view, view.child(value))),
        .tuple => {
            const children = view.children(value);
            const items = try self.allocator.alloc(ir.TypeId, children.count());
            var iterator = children.iterator();

            for (items) |*item| item.* = try node(self, view, iterator.next().?);

            return self.tuple(items);
        },
        .enumeration => return self.reporter.fail(.type_mismatch, .{ .start = 0, .end = 0 }, "enum types require a named declaration"),
        .application => {
            const name = view.name(value);

            if (std.mem.eql(u8, name.text, "Array")) return self.wrap(.list, try node(self, view, view.child(value)));

            return self.reporter.fail(.unsupported, name.span, "generic and database types are not enabled");
        },
        .object => {
            const fields = view.fields(value);
            const resolved_fields = try Types.Fields.init(self.allocator, fields.count());
            var iterator = fields.iterator();

            for (0..fields.count()) |index| {
                const field = iterator.next().?;
                var previous = fields.iterator();

                for (0..index) |_| {
                    if (std.mem.eql(u8, previous.next().?.name.text, field.name.text)) return self.reporter.fail(.name, field.name.span, "duplicate object field");
                }

                const type_id = try node(self, view, field.value);

                if (type_id == Types.scalarId(.void)) return self.reporter.fail(.type_mismatch, field.name.span, "object fields cannot have type void");

                resolved_fields.set(index, try self.allocator.dupe(u8, field.name.text), type_id);
            }

            return self.object(resolved_fields);
        },
    }
}

fn enumeration(self: *Types, name: zx.ast.Name, members: anytype) zx.Error!ir.TypeId {
    if (members.count() == 0) return self.reporter.fail(.type_mismatch, name.span, "an enum must have at least one member");

    const names = try self.allocator.alloc([]const u8, members.count());
    var iterator = members.iterator();

    for (names, 0..) |*text, index| {
        const member = iterator.next().?;

        for (names[0..index]) |previous| {
            if (std.mem.eql(u8, previous, member.text)) return self.reporter.fail(.name, member.span, "duplicate enum member");
        }

        text.* = try self.allocator.dupe(u8, member.text);
    }

    const id: ir.TypeId = @fromBackingInt(@intCast(self.items.view().count()));

    try self.items.append(self.allocator, .{ .enumeration = .{ .name = try self.allocator.dupe(u8, name.text), .members = names } });

    return id;
}

fn builtin(name: []const u8) ?ir.Scalar {
    if (std.mem.eql(u8, name, "number")) return .f64;
    if (std.mem.eql(u8, name, "boolean")) return .bool;

    return std.meta.stringToEnum(ir.Scalar, name);
}
