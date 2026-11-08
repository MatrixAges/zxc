const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, invocation: @FieldType(@FieldType(ir.ExpressionRow, "value"), "call")) Lower.Error!node.ExpressionId {
    self.uses_context = true;

    const entry = @import("generated_store_adapter");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const slots = self.program.functions.at(@backingInt(invocation.function)).stores;

    const bases: Bases = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .mapping = invocation.stores,
        .readable = slots.readable,
        .store_count = self.program.stores.count(),
        .pending_name = self.pending_name,
        .bases = &bases,
        .declaration_base = @intCast(self.builder.nodes.declaration_rows.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const output = entry.executeIn(scratch.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(view.join(output.expressions.*, output.forms.*), output.extra.*);
    const statements = view.join(output.statements.*, output.variables.*);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, &statements);
    try append(self, &self.builder.nodes.declaration_rows, output.declarations);
    @import("../../node/import_fields.zig").append(self.allocator, &self.builder.nodes.field_columns, output.fields) catch |err| return failure(err);
    self.serial = @intCast(output.serial);

    return @fromBackingInt(output.root);
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    @import("../../node/import_rows.zig").append(self.allocator, target, source) catch |err| return failure(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory => error.OutOfMemory,
        else => unreachable,
    };
}
