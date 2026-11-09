const std = @import("std");
const node = @import("../node.zig");
const Builder = @import("../builder.zig");

pub fn render(allocator: std.mem.Allocator, modules: []const []const u8) std.mem.Allocator.Error![]u8 {
    if (comptime !@import("genz_options").generated_analysis) return @import("storage_seed.zig").render(allocator, modules);

    var arena = std.heap.ArenaAllocator.init(allocator);

    defer arena.deinit();

    const builder = try Builder.init(arena.allocator());
    const entry = @import("generated_gateway_storage");
    const Input = @typeInfo(@TypeOf(entry.executeValue)).@"fn".param_types[1].?;
    const Bases = std.meta.Child(@FieldType(Input, "bases"));

    const bases: Bases = .{
        .capture = null,
        .expression_base = @intCast(builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(builder.nodes.statements.tags.items.len),
        .field_base = @intCast(builder.nodes.field_columns.count()),
        .serial = 0,
    };

    const input: Input = .{ .bases = &bases, .modules = modules };
    const output = entry.executeValue(builder.allocator, input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const Value = @TypeOf(output);
    const Module = if (@typeInfo(Value) == .pointer) std.meta.Child(Value) else Value;

    @import("../node/import_module.zig").appendBorrowed(builder.allocator, builder.nodes, Module, output) catch |err| return failure(err);

    const Constants = @TypeOf(output.constants);
    const constants = if (@typeInfo(Constants) == .@"struct") output.constants.items else output.constants;
    var declarations: std.ArrayList(node.Declaration) = .empty;

    @import("../node/import_constants.zig").appendValuesBorrowingText(builder.allocator, &declarations, constants) catch |err| return failure(err);

    return @import("../render.zig").render(allocator, builder.nodes, declarations.items);
}

fn failure(err: anyerror) std.mem.Allocator.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid Gateway storage AST"),
    };
}
