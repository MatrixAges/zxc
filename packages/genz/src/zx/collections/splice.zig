const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
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

    const output = entry.executeIn(memory.allocator(), &input) catch |err| return @import("emission.zig").failure(err);

    return @import("emission.zig").apply(self, body, output);
}
