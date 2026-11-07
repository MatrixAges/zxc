const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");

pub fn lower(context: *Context, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, source: node.ExpressionId) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("transfer_seed.zig").lower(context, body, type_id, source);

    const self = context.lowering;
    const kind = try self.typeExpr(type_id);
    const element = try self.typeExpr(self.program.typeOf(type_id).list);
    const generated = @import("generated_iteration_transfer");
    const Input = std.meta.Child(generated.Input);
    const history = context.transfers.view(std.meta.Child(@FieldType(Input, "history")));

    const input: Input = .{
        .type_id = @backingInt(type_id),
        .kind = @backingInt(kind),
        .element = @backingInt(element),
        .value = @backingInt(source),
        .history = &history,
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .serial = self.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const view = @import("../../node/view.zig");
    const rows = @import("../../node/import_rows.zig");
    const expressions = view.join(output.expressions.*, output.forms.*);

    rows.append(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    rows.append(self.allocator, &self.builder.nodes.statements, output.statements) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    const prefix = view.join(output.prefix.*, output.variables.*);

    @import("../../node/import_statements.zig").append(self.allocator, body, &prefix) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    try context.transfers.append(self.allocator, .{
        .type_id = @fromBackingInt(output.record.type_id),
        .owner = @fromBackingInt(output.record.owner),
        .value = @fromBackingInt(output.record.value),
        .ready = @fromBackingInt(output.record.ready),
    });

    self.serial = output.serial;
    self.uses_allocator = true;

    return @fromBackingInt(output.root);
}
