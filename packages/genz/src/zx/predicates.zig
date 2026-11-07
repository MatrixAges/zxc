const std = @import("std");
const ir = @import("zx").ir;
const node = @import("../node.zig");
const view = @import("../node/view.zig");
const Lower = @import("lower.zig");
const aggregate = @import("aggregate.zig");

pub fn lower(self: *Lower, value: ir.Transform) Lower.Error!node.ExpressionId {
    if (!@import("genz_options").generated_analysis) return @import("predicates/seed.zig").lower(self, value);

    const generated = @import("generated_predicate_emit");
    const Input = std.meta.Child(generated.Input);
    var body: std.ArrayList(node.Statement) = .empty;
    const source = try aggregate.bind(self, &body, try @import("state_value/list.zig").expression(self, value.target));
    const label = try self.fresh("predicate");
    const callback = try self.expr(value.body);

    try @import("transform/context.zig").bind(self, &body, value);

    var loop: std.ArrayList(node.Statement) = .empty;
    const capture = try @import("state_value/elements.zig").captureName(self, &loop, self.program.expression(value.target).type_id, value.parameters[0]);
    var scratch = std.heap.ArenaAllocator.init(self.workspace);

    defer scratch.deinit();

    const input = Input{
        .source = @backingInt(source),
        .label = label,
        .callback = @backingInt(callback),
        .kind = switch (value.kind) {
            .every => .Every,
            .some => .Some,
            else => unreachable,
        },
        .capture = capture,
        .outer_count = body.items.len,
        .element_count = loop.items.len,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
    };

    const output = generated.executeIn(scratch.allocator(), &input) catch |err| switch (err) {
        error.OutOfMemory, error.IntegerOverflow => return error.OutOfMemory,
        else => unreachable,
    };

    if (!output.valid) return error.OutOfMemory;

    const expressions = view.join(output.expressions.*, output.forms.*);

    try append(self, &self.builder.nodes.expressions, &expressions);
    try append(self, &self.builder.nodes.statements, output.stop);

    _ = try self.builder.statements(loop.items);

    try append(self, &self.builder.nodes.statements, output.decision);

    _ = try self.builder.statements(body.items);

    try append(self, &self.builder.nodes.statements, output.main);

    return @fromBackingInt(output.root);
}

fn append(self: *Lower, target: anytype, source: anytype) Lower.Error!void {
    @import("../node/import_rows.zig").appendBorrowingText(self.allocator, target, source) catch |err| switch (err) {
        error.OutOfMemory => return error.OutOfMemory,
        error.InvalidAst => unreachable,
    };
}
