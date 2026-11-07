const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../../node.zig");
const Lower = @import("../../lower.zig");
const rows = @import("../../../node/import_rows.zig");
const view = @import("../../../node/view.zig");

pub fn append(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, type_id: ir.TypeId, slot: u32, type_expr: node.ExpressionId, name: []const u8, value: node.ExpressionId) Lower.Error!void {
    const generated = @import("generated_ownership_helper");
    const Input = std.meta.Child(generated.Input);
    const Outline = std.meta.Child(@FieldType(Input, "source"));
    const Query = std.meta.Child(@FieldType(Outline, "source"));
    const Facts = std.meta.Child(@FieldType(Query, "facts"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Facts, "types")), self.program.types);

    const facts: Facts = .{
        .types = &types,
        .selected = self.state_plan.selected,
        .counts = self.slot_counts,
        .first = self.plan.slot_first,
        .transfers = self.plan.transfers,
    };

    const query: Query = .{ .facts = &facts, .node = @backingInt(id), .type_id = @backingInt(type_id), .slot = slot };
    const outline: Outline = .{ .source = &query, .referenced = self.state_plan.borrowed };
    const ast = zx.columns.view(std.meta.Child(@FieldType(Input, "ast")), @import("../list_emission.zig").borrow(self));

    const input: Input = .{
        .source = &outline,
        .name = name,
        .existing_names = self.task_declarations.functionNames(),
        .type_expr = @backingInt(type_expr),
        .value = @backingInt(value),
        .ast = &ast,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .declaration_base = @intCast(self.task_declarations.count()),
        .serial = self.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    for (output.segments) |segment| {
        const expressions = view.join(segment.expressions.*, segment.forms.*);

        if (segment.borrow_text) {
            rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return imported(err);
        } else {
            rows.append(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return imported(err);
        }
    }

    const statements = view.join(output.statements.*, output.variables.*);
    const storage = view.join(output.storage.*, output.variables.*);
    const importing = @import("../../../node/import_statements.zig");

    @import("../../../node/import_selected.zig").append(self.allocator, &self.builder.nodes.statements, &statements) catch |err| return imported(err);

    importing.appendSelected(self.allocator, &self.reference_storage, &storage) catch |err| return imported(err);

    if (output.declaration) |declaration| {
        const parameters = @import("../../../node/import_fields.zig").appendBorrowingText(self.allocator, &self.builder.nodes.field_columns, declaration.parameters) catch |err| return imported(err);

        try self.task_declarations.appendFunction(self.allocator, declaration.columns, parameters.start);
    }

    importing.appendBorrowingText(self.allocator, body, output.body) catch |err| return imported(err);

    self.serial = @intCast(output.serial);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid ownership helper generation"),
    };
}

fn imported(err: rows.Error) Lower.Error {
    return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        error.InvalidAst => @panic("invalid ownership helper AST"),
    };
}
