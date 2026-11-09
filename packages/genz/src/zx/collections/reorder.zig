const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");
const emission = @import("emission.zig");

pub const Request = struct {
    type_id: ir.TypeId,
    source: node.ExpressionId,
    header: node.ExpressionId,
    element: node.ExpressionId,
    length: node.ExpressionId,
    unit: node.ExpressionId,
    in_place: bool,
    grow: bool,
    sort: bool,
};

pub fn lower(self: *Lower, body: *std.ArrayList(node.Statement), args: Request) Lower.Error!node.ExpressionId {
    const entry = @import("generated_collection_reorder");
    const Input = std.meta.Child(entry.Input);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const serial = self.serial;
    const declarations = self.task_declarations.count();
    const compare = if (args.sort) try comparison(self, self.program.typeOf(args.type_id).list) else &.{};
    const selected = @import("../state_value/list.zig").selected(self, args.type_id);
    const layout = if (selected) try @import("../types.zig").get(self, self.state_types, args.type_id) else null;
    const ast = zx.columns.view(std.meta.Child(@FieldType(Input, "ast")), @import("../state_value/list_emission.zig").borrow(self));

    std.debug.assert(serial == self.serial and declarations == self.task_declarations.count());

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
        .element = @backingInt(args.element),
        .length = @backingInt(args.length),
        .unit = @backingInt(args.unit),
        .in_place = args.in_place,
        .grow = args.grow,
        .sort = args.sort,
        .compare = compare,
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

fn comparison(self: *Lower, child: ir.TypeId) Lower.Error![]const u8 {
    var found = false;

    for (self.comparisons.items) |previous| {
        if (previous == child) found = true;
    }

    if (!found) try self.comparisons.append(self.allocator, child);

    return @import("../comparison.zig").name(self, child);
}
