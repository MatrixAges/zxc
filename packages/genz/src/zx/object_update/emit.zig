const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const rows = @import("../../node/import_rows.zig");
const Lower = @import("../lower.zig");
const Change = @import("../object_update.zig").Change;

pub fn expression(self: *Lower, change: Change, body: *std.ArrayList(node.Statement)) Lower.Error!node.ExpressionId {
    const generated = @import("generated_object_update_expression");
    const Input = std.meta.Child(generated.Input);
    const Write = std.meta.Child(@FieldType(Input, "source"));
    const Changes = std.meta.Child(std.meta.Child(@FieldType(Write, "changes")));
    const name = try self.fresh("updated");
    const layout = try self.layoutExpr(change.type_id);
    const selected = self.state_plan.selected[@backingInt(change.type_id)];
    const reference = try self.expr(change.reference);
    const initial = if (selected) reference else try self.builder.expression(.{ .dereference = reference });
    const value: node.ExpressionId = if (change.multiple) @fromBackingInt(0) else try operand(self, body, change.field.value, selected);
    const value_name = try self.fresh("operand");
    const label = try self.fresh("block");
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Write, "types")), self.program.types);
    var changes: Changes = undefined;

    if (change.multiple) {
        const object = self.program.expression(change.object.?).value.object;
        const values = try self.allocator.alloc(u32, object.fields.len);

        for (values, 0..) |*item, index| {
            const field = object.fields.at(index);

            if (@import("matching.zig").unchanged(self, change.reference, field)) {
                item.* = 0;
            } else {
                item.* = @backingInt(try operand(self, body, field.value, selected));
            }
        }

        const program: *const ir.Program = &self.program;
        const flags = self.plan.flags;

        comptime std.debug.assert(@sizeOf(std.meta.Child(@TypeOf(flags))) == @sizeOf(u8));

        changes = .{
            .expressions = zx.columns.pointer(@FieldType(Changes, "expressions"), &program.expressions),
            .flags = @as([*]const u8, @ptrCast(flags.ptr))[0..flags.len],
            .reference = @backingInt(change.reference),
            .object = @backingInt(change.object.?),
            .values = values,
        };
    }

    const source: Write = .{
        .types = &types,
        .type_id = @backingInt(change.type_id),
        .field = change.field.index,
        .target_name = name,
        .value_name = value_name,
        .value = @backingInt(value),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .clear_origin = selected,
        .changes = if (change.multiple) &changes else null,
    };

    const input: Input = .{ .source = &source, .layout = @backingInt(layout), .initial = @backingInt(initial), .label = label };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);
    const emitted = view.join(output.statements.*, output.variables.*);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, &emitted);

    return @fromBackingInt(output.root);
}

pub fn statements(self: *Lower, target: *std.ArrayList(node.Statement), change: Change) Lower.Error!void {
    const generated = @import("generated_object_update_statements");
    const Input = std.meta.Child(generated.Input);
    const value = try self.expr(change.field.value);
    const name = try self.fresh("operand");
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Input, "types")), self.program.types);

    const input: Input = .{
        .types = &types,
        .type_id = @backingInt(change.type_id),
        .field = change.field.index,
        .target_name = self.names[@backingInt(change.previous)],
        .value_name = name,
        .value = @backingInt(value),
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .clear_origin = true,
        .changes = null,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);
    const flat = view.join(output.statements.*, output.variables.*);

    try append(self, &self.builder.nodes.expressions, &expressions);

    @import("../../node/import_statements.zig").appendBorrowingText(self.allocator, target, &flat) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    self.used[@backingInt(change.previous)] = true;
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    rows.append(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}

fn operand(self: *Lower, body: *std.ArrayList(node.Statement), id: ir.ExprId, selected: bool) Lower.Error!node.ExpressionId {
    const lowered = try self.expr(id);

    if (selected) return lowered;

    const bound = try @import("../aggregate.zig").bind(self, body, lowered);

    return @import("../state_value/conversion.zig").convert(self, body, self.program.expression(id).type_id, bound, .pointer);
}
