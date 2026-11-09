const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub const Request = struct {
    type_id: ir.TypeId,
    source: node.ExpressionId,
    header: node.ExpressionId,
    arguments: []const node.ExpressionId,
    element: node.ExpressionId,
    length: node.ExpressionId,
    retract: bool,
    removed_only: bool,
};

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), args: Request) Lower.Error!node.ExpressionId {
    const entry = @import("generated_collection_splice");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const selected = @import("../state_value/list.zig").selected(self, args.type_id);
    const layout = if (selected) try @import("../types.zig").get(self, self.state_types, args.type_id) else null;
    const ast = zx.columns.view(std.meta.Child(@FieldType(Input, "ast")), @import("../state_value/list_emission.zig").borrow(self));

    const bases: Bases = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{
        .source = @backingInt(args.source),
        .header = @backingInt(args.header),
        .start = @backingInt(args.arguments[0]),
        .count = @backingInt(args.arguments[1]),
        .replacement = @backingInt(args.arguments[2]),
        .element = @backingInt(args.element),
        .length = @backingInt(args.length),
        .selected = selected,
        .layout = if (layout) |value| @backingInt(value) else 0,
        .retract = args.retract,
        .removed_only = args.removed_only,
        .shared = self.shared_types,
        .ast = &ast,
        .bases = &bases,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const output = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const context = output.state.context;
    const expressions = view.join(context.expressions.*, context.forms.*);
    const statements = view.join(context.statements.*, context.variables.*);
    @import("../../node/import_rows.zig").append(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    @import("../../node/import_selected.zig").append(self.allocator, &self.builder.nodes.statements, &statements) catch |err| return failure(err);
    _ = @import("../../node/import_fields.zig").append(self.allocator, &self.builder.nodes.field_columns, output.fields) catch |err| return failure(err);

    var roots = context.statements.*;
    roots.tags = output.state.body.tags;
    roots.offsets = output.state.body.offsets;
    const flat = view.join(roots, context.variables.*);

    @import("../../node/import_statements.zig").appendSelected(self.allocator, body, &flat) catch |err| return failure(err);
    self.serial = @intCast(output.serial);
    self.uses_allocator = self.uses_allocator or output.uses_allocator;

    return @fromBackingInt(output.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
