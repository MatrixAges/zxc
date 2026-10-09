const std = @import("std");
pub const frontend = @import("frontend");
pub const compiler = @import("compiler");
pub const zx = @import("zx");
pub const ir = zx.ir;
pub const Types = frontend.types;
pub const Type = zx.ast.Type;
pub const Declaration = zx.ast.Declaration;
pub const Name = zx.ast.Name;

pub fn name(text: []const u8, position: usize) Name {
    return .{ .text = text, .span = .{ .start = position, .end = position + text.len } };
}

pub fn node(memory: std.mem.Allocator, value: Type) !*const Type {
    const result = try memory.create(Type);

    result.* = value;

    return result;
}

pub fn declaration(text: []const u8, position: usize, value: *const Type) Declaration {
    const label = name(text, position);

    return .{ .name = label, .value = value, .span = label.span };
}

pub fn base(memory: std.mem.Allocator, reporter: *zx.Reporter, declarations: []const Declaration) !Types {
    var result = Types{ .allocator = memory, .reporter = reporter, .declarations = declarations };

    for (std.enums.values(ir.Scalar)) |value| try result.items.append(memory, .{ .scalar = value });

    return result;
}

pub fn scalar(value: ir.Scalar) ir.TypeId {
    return Types.scalarId(value);
}

pub fn diagnostic(reporter: zx.Reporter, code: @FieldType(zx.Diagnostic, "code"), message: []const u8, span: zx.Span) !void {
    try std.testing.expect(reporter.diagnostic != null);

    const actual = reporter.diagnostic.?;

    try std.testing.expectEqual(code, actual.code);
    try std.testing.expectEqualStrings(message, actual.message);
    try std.testing.expectEqual(span.start, actual.span.start);
    try std.testing.expectEqual(span.end, actual.span.end);
}

pub fn held(types: *Types, count: usize) !void {
    for (0..count) |index| {
        const label = try std.fmt.allocPrint(types.allocator, "Held{d}", .{index});

        try types.visiting.put(types.allocator, label, {});
    }
}

pub fn heldUnchanged(types: Types, count: usize) !void {
    try std.testing.expectEqual(@as(u32, @intCast(count)), types.visiting.count());

    var buffer: [32]u8 = undefined;

    for (0..count) |index| {
        const label = try std.fmt.bufPrint(&buffer, "Held{d}", .{index});

        try std.testing.expect(types.visiting.contains(label));
    }
}

pub fn chain(memory: std.mem.Allocator, count: usize, tail: []const u8) ![]const Declaration {
    const labels = try memory.alloc([]const u8, count);
    const declarations = try memory.alloc(Declaration, count);

    for (labels, 0..) |*label, index| label.* = try std.fmt.allocPrint(memory, "Alias{d}", .{index});

    for (declarations, 0..) |*item, index| {
        const target = if (index + 1 == count) tail else labels[index + 1];

        item.* = declaration(labels[index], index * 32, try node(memory, .{ .named = name(target, index * 32 + 16) }));
    }

    return declarations;
}

pub fn prefix(types: Types) !void {
    try std.testing.expect(frontend.validateTypes(types.items.view()));
    for (std.enums.values(ir.Scalar), 0..) |value, index| try std.testing.expectEqual(value, types.items.view().at(index).scalar);
}
