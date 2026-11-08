const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const policy = @import("policy.zig");
const view = @import("../../node/view.zig");
const entry = @import("generated_value_call_emit");
const Input = std.meta.Child(entry.Input);
const Context = std.meta.Child(@FieldType(Input, "context"));
const Capture = std.meta.Child(@typeInfo(@FieldType(Context, "capture")).optional.child);
const Plan = std.meta.Child(@typeInfo(@FieldType(Input, "plan")).optional.child);
pub const Operation = @FieldType(Input, "operation");

pub const Arguments = struct {
    value: node.ExpressionId = @fromBackingInt(0),
    callee: node.ExpressionId = @fromBackingInt(0),
    condition: node.ExpressionId = @fromBackingInt(0),
    yes: node.ExpressionId = @fromBackingInt(0),
    no: node.ExpressionId = @fromBackingInt(0),
    plan: ?policy.Plan = null,
};

pub fn emit(self: *Lower, body: ?*std.ArrayList(node.Statement), operation: Operation, arguments: Arguments) Lower.Error!node.ExpressionId {
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const allocator = buffered.allocator();
    const first: u32 = @intCast(self.builder.nodes.statements.tags.items.len);
    const count: u32 = if (operation == .Block) @intCast(body.?.items.len) else 0;
    const statement_base = std.math.add(u32, first, count) catch return error.OutOfMemory;
    var boundary: Capture = undefined;

    const capture = if (self.capture) |captured| capture: {
        boundary = .{ .name = captured.name, .label = captured.label, .failure = @backingInt(captured.failure) };

        break :capture &boundary;
    } else null;

    const context: Context = .{
        .capture = capture,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = statement_base,
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const plan: Plan = if (arguments.plan) |selected| zx.columns.view(Plan, selected) else undefined;

    const input: Input = .{
        .context = &context,
        .operation = operation,
        .value = @backingInt(arguments.value),
        .callee = @backingInt(arguments.callee),
        .condition = @backingInt(arguments.condition),
        .yes = @backingInt(arguments.yes),
        .no = @backingInt(arguments.no),
        .body_first = first,
        .body_count = count,
        .plan = if (arguments.plan != null) &plan else null,
    };

    const output = entry.executeIn(allocator, &input) catch |err| return failure(err);

    if (!output.context.valid) return error.OutOfMemory;

    var expressions = output.context.expressions.*;
    var statements = output.context.statements.*;
    var selected_body = output.body.*;
    const name = if (output.name.len == 0) &.{} else try self.allocator.dupe(u8, output.name);
    const names = [_][]const u8{name};

    if (name.len != 0) {
        if (expressions.identifier.len != 0) {
            const identifiers = try allocator.dupe([]const u8, expressions.identifier);

            std.debug.assert(output.name_index < identifiers.len);

            identifiers[@intCast(output.name_index)] = name;

            expressions.identifier = identifiers;
        }

        if (expressions.block_label.len != 0) expressions.block_label = &names;
        if (statements.break_value_label.len != 0) statements.break_value_label = &names;
        if (selected_body.constant_name.len != 0) selected_body.constant_name = &names;
    }

    if (operation == .Block) {
        std.debug.assert(self.builder.nodes.statements.tags.items.len == first);

        const span = try self.builder.statements(body.?.items);

        std.debug.assert(span.start == first and span.len == count);
    }

    const joined = view.join(expressions, output.context.forms.*);

    @import("../../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &joined) catch |err| return failure(err);

    if (statements.tags.len != 0) {
        const global = view.join(statements, output.context.variables.*);
        @import("../../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.statements, &global) catch |err| return failure(err);
    }

    if (selected_body.tags.len != 0) {
        const local = view.join(selected_body, output.context.variables.*);

        @import("../../node/import_statements.zig").appendSelectedBorrowingText(self.allocator, body.?, &local) catch |err| return failure(err);
    }

    self.serial = @intCast(output.context.serial);
    self.uses_allocator = self.uses_allocator or output.uses_allocator;

    return @fromBackingInt(output.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => @panic("invalid value call emission"),
    };
}
