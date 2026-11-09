const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const emission = @import("emission.zig");

pub const Request = struct {
    operation: ir.ExprId,
    type_id: ir.TypeId,
    items: node.ExpressionId,
    value: node.ExpressionId,
    argument: node.ExpressionId,
    element: node.ExpressionId,
    length: node.ExpressionId,
    unit: node.ExpressionId,
    push: bool,
    frontier: bool,
    lazy: bool,
};

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), args: Request) Lower.Error!node.ExpressionId {
    const entry = @import("generated_collection_append");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const serial = self.serial;
    const declarations = self.task_declarations.count();
    const statements = self.builder.nodes.statements.tags.items.len;
    const roots = body.items.len;
    const minimum = if (self.loop_fields) |context| try context.minimum(self, args.operation) else null;
    const selected = @import("../state_value/list.zig").selected(self, args.type_id);
    const layout = if (selected) try @import("../types.zig").get(self, self.state_types, args.type_id) else null;
    const ast = zx.columns.view(std.meta.Child(@FieldType(Input, "ast")), @import("../state_value/list_emission.zig").borrow(self));

    std.debug.assert(serial == self.serial and declarations == self.task_declarations.count());
    std.debug.assert(statements == self.builder.nodes.statements.tags.items.len and roots == body.items.len);

    const bases: Bases = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .items = @backingInt(args.items),
        .value = @backingInt(args.value),
        .argument = @backingInt(args.argument),
        .element = @backingInt(args.element),
        .length = @backingInt(args.length),
        .unit = @backingInt(args.unit),
        .push = args.push,
        .frontier = args.frontier,
        .lazy = args.lazy,
        .minimum = if (minimum) |value| @backingInt(value) else null,
        .selected = selected,
        .layout = if (layout) |value| @backingInt(value) else 0,
        .shared = self.shared_types,
        .ast = &ast,
        .bases = &bases,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = entry.executeIn(memory.allocator(), &input) catch |err| return emission.failure(err);

    return emission.apply(self, body, output);
}
