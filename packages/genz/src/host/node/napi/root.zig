const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../../node.zig");
const Builder = @import("../../../builder.zig");
const Types = @import("types.zig");
const common = @import("common.zig");
pub const Error = Types.Error;

pub fn render(allocator: std.mem.Allocator, values: []const ir.Type, input: ir.TypeId, output: ir.TypeId) Error![]u8 {
    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = Builder{ .allocator = arena.allocator() };
    const types = try Types.init(builder, values);
    var declarations: std.ArrayList(node.Declaration) = .empty;

    try types.mark(input, try builder.path(&.{ "application", "Input" }), true);
    try types.mark(output, try builder.path(&.{ "application", "Output" }), false);

    for ([_][]const u8{ "std", "application", "api.zig" }, [_][]const u8{ "std", "application", "api" }) |module, name| {
        try declarations.append(builder.allocator, .{ .constant = .{ .name = name, .value = try builder.builtin(.import, &.{try builder.string(module)}), .exported = std.mem.eql(u8, name, "api") } });
    }

    try declarations.appendSlice(builder.allocator, try @import("value.zig").declarations(builder));

    for (types.aliases, 0..) |alias, index| {
        const source = alias orelse continue;
        const id: ir.TypeId = @fromBackingInt(@intCast(index));

        try declarations.append(builder.allocator, .{ .constant = .{ .name = try types.name("Type", id), .value = source } });
        if (types.reads[index]) try declarations.append(builder.allocator, try @import("read.zig").lower(types, id));
        if (types.writes[index]) try declarations.append(builder.allocator, try @import("write.zig").lower(types, id));
    }

    const env = try builder.identifier("env");
    const value = try builder.identifier("value");

    var read = try common.function(builder, "read", try common.parameters(builder, true), try types.typeExpression(input), &.{
        .{ .result = try builder.call(try builder.identifier(try types.name("read_", input)), &.{ try builder.identifier("allocator"), env, value }) },
    });

    var write = try common.function(builder, "write", try builder.allocator.dupe(node.Field, &.{
        .{ .name = "env", .value = try builder.path(&.{ "api", "Env" }) },
        .{ .name = "value", .value = try types.typeExpression(output) },
    }), try builder.path(&.{ "api", "Value" }), &.{
        .{ .result = try builder.call(try builder.identifier(try types.name("write_", output)), &.{ env, value }) },
    });

    read.function.exported = true;
    write.function.exported = true;

    try declarations.appendSlice(builder.allocator, &.{ read, write });

    return @import("../../../render.zig").render(allocator, declarations.items);
}
