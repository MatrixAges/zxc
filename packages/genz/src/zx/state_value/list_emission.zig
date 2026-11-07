const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const view = @import("../../node/view.zig");
const generated = @import("generated_state_list");
const Input = std.meta.Child(generated.Input);
const Query = std.meta.Child(@FieldType(Input, "request"));
const Operation = @FieldType(Query, "operation");
const Ast = std.meta.Child(@FieldType(Query, "ast"));

const Request = struct {
    value: node.ExpressionId = @fromBackingInt(0),
    condition: node.ExpressionId = @fromBackingInt(0),
    unique: node.ExpressionId = @fromBackingInt(0),
    storage: @FieldType(Input, "storage") = .Plain,
    selected: bool = false,
    flag: bool = false,
};

pub fn lower(self: *Lower, id: ?ir.TypeId, operation: Operation, request: Request) Lower.Error!node.ExpressionId {
    const before = borrow(self);

    const query: Query = .{
        .operation = operation,
        .selected = request.selected,
        .value = @backingInt(request.value),
        .ast = &before,
    };

    var fixed = std.heap.FixedBufferAllocator.init(&.{});
    const plan = zx.columns.invoke(@import("generated_state_list_query").executeValue, fixed.allocator(), &query) catch unreachable;

    if (plan.passthrough) |value| return @fromBackingInt(value);

    const layout: ?node.ExpressionId = if (plan.layout) try @import("../types.zig").get(self, self.state_types, id.?) else null;
    const ast = borrow(self);

    const current: Query = .{
        .operation = operation,
        .selected = request.selected,
        .value = @backingInt(request.value),
        .ast = &ast,
    };

    const input: Input = .{
        .request = &current,
        .construct = plan.layout,
        .condition = @backingInt(request.condition),
        .unique = @backingInt(request.unique),
        .storage = request.storage,
        .flag = request.flag,
        .layout = if (layout) |value| @backingInt(value) else 0,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var buffered = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = generated.executeIn(buffered.allocator(), &input) catch |err| switch (@as(anyerror, err)) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);

    @import("../../node/import_rows.zig").appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };

    try self.builder.nodes.field_columns.reserve(self.allocator, output.fields.len);

    for (output.fields) |field| self.builder.nodes.field_columns.append(.{
        .name = field.name,
        .value = @fromBackingInt(field.value),
        .default_value = if (field.default_value) |value| @fromBackingInt(value) else null,
        .comptime_parameter = field.comptime_parameter,
    });

    return @fromBackingInt(output.root);
}

pub fn borrow(self: *const Lower) Ast {
    const rows = &self.builder.nodes.expressions;
    const object = &rows.payloads.object.fields.fields.fields;
    const fields = &self.builder.nodes.field_columns.fields;

    return .{
        .tags = view.slice(@FieldType(Ast, "tags"), rows.tags.items),
        .offsets = rows.offsets.items,
        .boolean = rows.payloads.boolean.values.items,
        .object_start = object.start.values.items,
        .object_count = object.len.values.items,
        .field_name = view.slice(@FieldType(Ast, "field_name"), fields.name.values.items),
        .field_value = view.slice(@FieldType(Ast, "field_value"), fields.value.values.items),
    };
}
