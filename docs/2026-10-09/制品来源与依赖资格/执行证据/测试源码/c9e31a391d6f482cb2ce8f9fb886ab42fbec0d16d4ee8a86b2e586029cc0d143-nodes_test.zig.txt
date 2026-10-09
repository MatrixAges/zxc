const std = @import("std");
const f = @import("fixture.zig");
const Problem = enum { list_void, field_void, duplicate_field, generic, anonymous_enum, empty_enum, duplicate_member, plain_opaque, nested_opaque, optional_task, list_task, tuple_task, object_task, tuple_task_unknown, object_task_unknown };

fn rejected(problem: Problem) !void {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    var types = try f.base(memory, &reporter, &.{});
    const empty = try f.node(memory, .{ .named = f.name("void", 41) });
    const number = try f.node(memory, .{ .named = f.name("u64", 43) });
    const missing = try f.node(memory, .{ .named = f.name("Missing", 51) });
    const opaque_node = try f.node(memory, .{ .named = f.name("opaque", 61) });
    const work = try types.task(f.scalar(.u64), try types.errorSet(&.{"Failure"}));
    types.aliases = &.{.{ .name = "Work", .type_id = work }};

    const task = try f.node(memory, .{ .named = f.name("Work", 71) });
    const field_name = f.name("field", 81);
    const duplicate = f.name("field", 91);
    const generic_name = f.name("Map", 101);
    const declaration_name = f.name("Target", 111);
    const member = f.name("Tag", 121);
    const duplicate_member = f.name("Tag", 131);

    const value = try f.node(memory, switch (problem) {
        .list_void => .{ .list = empty },
        .field_void => .{ .object = &.{.{ .name = field_name, .value = empty }} },
        .duplicate_field => .{ .object = &.{ .{ .name = field_name, .value = number }, .{ .name = duplicate, .value = missing } } },
        .generic => .{ .application = .{ .name = generic_name, .argument = missing } },
        .anonymous_enum, .empty_enum => .{ .enumeration = &.{} },
        .duplicate_member => .{ .enumeration = &.{ member, duplicate_member } },
        .plain_opaque => opaque_node.*,
        .nested_opaque => .{ .optional = opaque_node },
        .optional_task => .{ .optional = task },
        .list_task => .{ .list = task },
        .tuple_task => .{ .tuple = &.{task} },
        .object_task => .{ .object = &.{.{ .name = field_name, .value = task }} },
        .tuple_task_unknown => .{ .tuple = &.{ task, missing } },
        .object_task_unknown => .{ .object = &.{ .{ .name = field_name, .value = task }, .{ .name = f.name("later", 141), .value = missing } } },
    });

    const named = problem == .empty_enum or problem == .duplicate_member or problem == .plain_opaque or problem == .nested_opaque;

    types.native_interface = problem == .nested_opaque;

    if (named) types.declarations = &.{f.declaration(declaration_name.text, declaration_name.span.start, value)};
    try f.held(&types, 2);
    try std.testing.expectError(error.InvalidSource, if (named) types.named(declaration_name) else types.resolve(value));

    const message: []const u8 = switch (problem) {
        .list_void => "lists cannot contain void",
        .field_void => "object fields cannot have type void",
        .duplicate_field => "duplicate object field",
        .generic => "generic and database types are not enabled",
        .anonymous_enum => "enum types require a named declaration",
        .empty_enum => "an enum must have at least one member",
        .duplicate_member => "duplicate enum member",
        .plain_opaque, .nested_opaque, .tuple_task_unknown, .object_task_unknown => "unknown or unsupported type",
        .optional_task, .list_task => "tasks cannot be placed in containers",
        .tuple_task => "tasks cannot be placed in tuples",
        .object_task => "tasks cannot be placed in objects",
    };

    const code: @FieldType(f.zx.Diagnostic, "code") = switch (problem) {
        .duplicate_field, .duplicate_member, .plain_opaque, .nested_opaque, .tuple_task_unknown, .object_task_unknown => .name,
        .generic => .unsupported,
        .optional_task, .list_task, .tuple_task, .object_task => .ownership,
        else => .type_mismatch,
    };

    const span: f.zx.Span = switch (problem) {
        .field_void => field_name.span,
        .duplicate_field => duplicate.span,
        .generic => generic_name.span,
        .empty_enum => declaration_name.span,
        .duplicate_member => duplicate_member.span,
        .plain_opaque, .nested_opaque => opaque_node.named.span,
        .tuple_task_unknown, .object_task_unknown => missing.named.span,
        else => .{ .start = 0, .end = 0 },
    };

    try f.diagnostic(reporter, code, message, span);
    try f.heldUnchanged(types, 2);
    try f.prefix(types);
}

test "list void is rejected after resolving its child" {
    try rejected(.list_void);
}

test "object void reports the field name span" {
    try rejected(.field_void);
}

test "duplicate field precedes resolution of the repeated field value" {
    try rejected(.duplicate_field);
}

test "unsupported generic name precedes unknown argument resolution" {
    try rejected(.generic);
}

test "anonymous enum nodes are rejected even when empty" {
    try rejected(.anonymous_enum);
}

test "empty declared enum uses declaration name span" {
    try rejected(.empty_enum);
}

test "duplicate enum member uses the later member span" {
    try rejected(.duplicate_member);
}

test "ordinary declaration cannot resolve opaque as a native reference" {
    try rejected(.plain_opaque);
}

test "native declaration does not enable opaque inside a container" {
    try rejected(.nested_opaque);
}

test "optional task is rejected through imported alias" {
    try rejected(.optional_task);
}

test "list task is rejected through imported alias" {
    try rejected(.list_task);
}

test "tuple task is rejected after all children resolve" {
    try rejected(.tuple_task);
}

test "object task is rejected after all fields resolve" {
    try rejected(.object_task);
}

test "tuple unknown later child precedes earlier task containment error" {
    try rejected(.tuple_task_unknown);
}

test "object unknown later field precedes earlier task containment error" {
    try rejected(.object_task_unknown);
}

test "optional void and empty tuple and object remain valid" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    var types = try f.base(memory, &reporter, &.{});
    const value = try f.node(memory, .{ .named = f.name("void", 0) });
    const optional = try types.resolve(try f.node(memory, .{ .optional = value }));
    const tuple = try types.resolve(try f.node(memory, .{ .tuple = &.{} }));
    const object = try types.resolve(try f.node(memory, .{ .object = &.{} }));

    try std.testing.expectEqual(f.scalar(.void), types.get(optional).optional);
    try std.testing.expectEqual(@as(usize, 0), types.get(tuple).tuple.len);
    try std.testing.expectEqual(@as(usize, 0), types.get(object).object.len);
    try f.prefix(types);
}

test "object order is canonical and equivalent field permutations intern once" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    var types = try f.base(memory, &reporter, &.{});
    const number = try f.node(memory, .{ .named = f.name("u64", 0) });
    const text = try f.node(memory, .{ .named = f.name("string", 0) });
    const a = f.zx.ast.TypeField{ .name = f.name("a", 20), .value = number };
    const z = f.zx.ast.TypeField{ .name = f.name("z", 10), .value = text };
    const left = try types.resolve(try f.node(memory, .{ .object = &.{ z, a } }));
    const right = try types.resolve(try f.node(memory, .{ .object = &.{ a, z } }));

    try std.testing.expectEqual(left, right);

    const fields = types.get(left).object;

    try std.testing.expectEqual(@as(usize, 2), fields.len);
    try std.testing.expectEqualStrings("a", fields.at(0).name);
    try std.testing.expectEqual(f.scalar(.u64), fields.at(0).type_id);
    try std.testing.expectEqualStrings("z", fields.at(1).name);
    try std.testing.expectEqual(f.scalar(.string), fields.at(1).type_id);
    try std.testing.expectEqual(@as(usize, 12), types.items.count());
}

test "Array application and list syntax intern the same ordered child type" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    var types = try f.base(memory, &reporter, &.{});
    const number = try f.node(memory, .{ .named = f.name("u64", 0) });
    const list = try types.resolve(try f.node(memory, .{ .list = number }));
    const application = try types.resolve(try f.node(memory, .{ .application = .{ .name = f.name("Array", 20), .argument = number } }));

    try std.testing.expectEqual(list, application);
    try std.testing.expectEqual(f.scalar(.u64), types.get(list).list);
    try std.testing.expectEqual(@as(usize, 12), types.items.count());
}

test "same enum members under different declaration names retain nominal identity" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    const value = try f.node(memory, .{ .enumeration = &.{ f.name("Second", 20), f.name("First", 30) } });
    var types = try f.base(memory, &reporter, &.{ f.declaration("Left", 0, value), f.declaration("Right", 40, value) });
    const left = try types.named(f.name("Left", 0));
    const right = try types.named(f.name("Right", 40));

    try std.testing.expect(left != right);
    try std.testing.expectEqualStrings("Left", types.get(left).enumeration.name);
    try std.testing.expectEqualStrings("Right", types.get(right).enumeration.name);

    for ([_]f.ir.TypeId{ left, right }) |id| {
        try std.testing.expectEqualStrings("Second", types.get(id).enumeration.members[0]);
        try std.testing.expectEqualStrings("First", types.get(id).enumeration.members[1]);
    }

    try std.testing.expectEqual(left, try types.named(f.name("Left", 70)));
    try std.testing.expectEqual(@as(usize, 13), types.items.count());
}

test "direct native opaque declaration and alias share one native row" {
    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);

    defer arena.deinit();

    var reporter: f.zx.Reporter = .{};
    const memory = arena.allocator();
    const opaque_node = try f.node(memory, .{ .named = f.name("opaque", 20) });
    var types = try f.base(memory, &reporter, &.{ f.declaration("Node", 0, opaque_node), f.declaration("Alias", 30, try f.node(memory, .{ .named = f.name("Node", 40) })) });
    types.native_interface = true;

    const node = try types.named(f.name("Node", 0));

    try std.testing.expectEqualStrings("Node", types.get(node).native_reference);
    try std.testing.expectEqual(node, try types.named(f.name("Alias", 30)));
    try std.testing.expectEqual(@as(usize, 12), types.items.count());
    try std.testing.expectEqual(@as(u32, 0), types.visiting.count());
}
