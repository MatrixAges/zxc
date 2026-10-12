const std = @import("std");
const node = @import("../node.zig");
const Storage = @import("../node/storage.zig");
const view = @import("../node/view.zig");
const generated = @import("generated_printer");
const Input = @typeInfo(generated.Input).pointer.child;
const Source = @typeInfo(@FieldType(Input, "source")).pointer.child;

pub fn render(allocator: std.mem.Allocator, nodes: *Storage, declarations: []const node.Declaration) std.mem.Allocator.Error![]u8 {
    const selected = try nodes.declarations(nodes.allocator, declarations);
    const expressions = view.rows(@typeInfo(@FieldType(Source, "expressions")).pointer.child, &nodes.expressions);
    const statements = view.rows(@typeInfo(@FieldType(Source, "statements")).pointer.child, &nodes.statements);
    const declaration_rows = view.rows(@typeInfo(@FieldType(Source, "declarations")).pointer.child, &nodes.declaration_rows);
    const fields = view.members(@typeInfo(@FieldType(Source, "fields")).pointer.child, &nodes.field_columns);
    const arms = view.members(@typeInfo(@FieldType(Source, "arms")).pointer.child, &nodes.arm_columns);

    const source = Source{
        .expressions = &expressions,
        .statements = &statements,
        .declarations = &declaration_rows,
        .fields = &fields,
        .arms = &arms,
        .first = selected.start,
        .count = selected.len,
    };

    var arena = @import("zx").Arena.init(nodes.allocator);

    defer arena.deinit();

    const output = generated.executeIn(arena.allocator(), &.{ .source = &source, .output = &.{} }) catch |err| switch (err) {
        error.OutOfMemory, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    return allocator.dupe(u8, output);
}
