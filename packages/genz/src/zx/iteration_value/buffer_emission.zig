const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../../node.zig");
const Context = @import("root.zig");
const Lower = @import("../lower.zig");
const rows = @import("../../node/import_rows.zig");

pub fn view(context: *Context, id: ir.TypeId, owner: node.ExpressionId, items: node.ExpressionId, owned: bool) Lower.Error!node.ExpressionId {
    const self = context.lowering;
    const layout = try @import("types.zig").get(context, id);
    const generated = @import("generated_iteration_buffer_view");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .layout = @backingInt(layout),
        .owner = @backingInt(owner),
        .items = @backingInt(items),
        .owned = owned,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
    };

    return emitObject(self, generated, &input);
}

pub fn redirect(context: *Context, id: ir.TypeId, source: node.ExpressionId) Lower.Error!node.ExpressionId {
    const self = context.lowering;
    const layout = try @import("types.zig").get(context, id);
    const generated = @import("generated_iteration_buffer_redirect");
    const Input = std.meta.Child(generated.Input);
    const history = context.transfers.view(std.meta.Child(@FieldType(Input, "history")));

    const input: Input = .{
        .type_id = @backingInt(id),
        .layout = @backingInt(layout),
        .value = @backingInt(source),
        .history = &history,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
    };

    return emitObject(self, generated, &input);
}

fn emitObject(self: *Lower, comptime generated: type, input: anytype) Lower.Error!node.ExpressionId {
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expressions = @import("../../node/view.zig").join(output.expressions.*, output.forms.*);

    try importRows(self, &self.builder.nodes.expressions, &expressions);
    try self.builder.nodes.field_columns.reserve(self.allocator, output.fields.len);

    for (output.fields) |field| {
        self.builder.nodes.field_columns.append(.{
            .name = field.name,
            .value = @fromBackingInt(field.value),
            .default_value = if (field.default_value) |value| @fromBackingInt(value) else null,
            .comptime_parameter = field.comptime_parameter,
        });
    }

    return @fromBackingInt(output.root);
}

pub fn prepare(context: *Context, body: *std.ArrayList(node.Statement), source: node.ExpressionId) Lower.Error!void {
    const self = context.lowering;
    const generated = @import("generated_iteration_buffer_prepare");
    const Input = std.meta.Child(generated.Input);

    const input: Input = .{
        .value = @backingInt(source),
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
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

    const expressions = @import("../../node/view.zig").join(output.expressions.*, output.forms.*);

    try importRows(self, &self.builder.nodes.expressions, &expressions);
    try importRows(self, &self.builder.nodes.statements, output.statements);

    @import("../../node/import_statements.zig").append(self.allocator, body, output.roots) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    self.uses_allocator = true;
}

fn importRows(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    rows.appendBorrowingText(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
