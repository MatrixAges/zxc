const std = @import("std");
pub const compiler = @import("compiler");
pub const ir = compiler.ir;
pub const Origins = @FieldType(compiler.project.artifact.type_link.Table, "origins");
pub const Nominal = struct { id: ir.TypeId, name: []const u8 };
pub const Input = struct { types: ir.TypeTable, nominal: []const Nominal };

pub fn scalar(value: ir.Scalar) ir.TypeId {
    return @fromBackingInt(@intCast(@backingInt(value)));
}

fn append(items: *ir.TypeStorage, memory: std.mem.Allocator, value: ir.TypeValue) !ir.TypeId {
    const id: ir.TypeId = @fromBackingInt(@intCast(items.count()));

    try items.append(memory, value);

    return id;
}

pub fn create(memory: std.mem.Allocator, native: bool) !Input {
    var items: ir.TypeStorage = .{};
    var nominal: std.ArrayList(Nominal) = .empty;

    for (std.enums.values(ir.Scalar)) |value| _ = try append(&items, memory, .{ .scalar = value });

    const before = try append(&items, memory, .{ .enumeration = .{ .name = "Before", .members = &.{ "First", "Second" } } });

    try nominal.append(memory, .{ .id = before, .name = "Before" });

    const optional = try append(&items, memory, .{ .optional = before });
    const errors = try append(&items, memory, .{ .error_set = &.{ "Alpha", "Omega" } });
    const later = try append(&items, memory, .{ .enumeration = .{ .name = "Later", .members = &.{ "Left", "Right" } } });

    try nominal.append(memory, .{ .id = later, .name = "Later" });

    const list = try append(&items, memory, .{ .list = optional });

    if (native) {
        const node = try append(&items, memory, .{ .native_reference = "Node" });

        try nominal.append(memory, .{ .id = node, .name = "Node" });
    }

    for (0..17) |index| {
        const label = try std.fmt.allocPrint(memory, "Choice{d}", .{index});
        const id = try append(&items, memory, .{ .enumeration = .{ .name = label, .members = &.{ "First", "Second" } } });

        try nominal.append(memory, .{ .id = id, .name = label });
    }

    const pair = try append(&items, memory, .{ .tuple = &.{ list, later, scalar(.u64) } });
    const record = try append(&items, memory, .{ .object = .{ .names = &.{ "items", "pair" }, .types = &.{ @backingInt(list), @backingInt(pair) }, .len = 2 } });

    _ = try append(&items, memory, .{ .task = .{ .result = record, .errors = errors } });

    try std.testing.expect(items.view().validStructure());

    return .{ .types = items.view(), .nominal = nominal.items };
}

pub fn origin(kind: enum { source, native, external }) Origins.Origin {
    return switch (kind) {
        .source => .{ .source = "/current/source.zx" },
        .native => .{ .native = "zig:current" },
        .external => .{ .external = .{ .module = "library@2", .member = "public" } },
    };
}
