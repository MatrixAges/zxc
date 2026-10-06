const zx = @import("zx");
const Context = @import("context.zig");

pub fn arguments(context: Context, node: anytype) ![]*const zx.ast.Expression {
    const values = try context.allocator.alloc(*const zx.ast.Expression, @intCast(node.count));
    var head = node.head;
    var remaining = values.len;

    while (remaining != 0) {
        remaining -= 1;
        const edge = context.program.body.expression.tree.items[@intCast(head - 1)];
        values[remaining] = context.expression(edge.value);
        head = edge.previous;
    }

    return values;
}

pub fn parameters(context: Context, node: anytype) ![]zx.ast.Name {
    const values = try context.allocator.alloc(zx.ast.Name, @intCast(node.count));
    var head = node.head;
    var remaining = values.len;

    while (remaining != 0) {
        remaining -= 1;
        const edge = context.program.body.expression.tree.parameters[@intCast(head - 1)];
        values[remaining] = context.name(edge.name);
        head = edge.previous;
    }

    return values;
}

pub fn parts(context: Context, node: anytype) ![]zx.ast.TemplatePart {
    const values = try context.allocator.alloc(zx.ast.TemplatePart, @intCast(node.count));
    var head = node.head;
    var remaining = values.len;

    while (remaining != 0) {
        remaining -= 1;
        const edge = context.program.body.expression.tree.parts[@intCast(head - 1)];
        values[remaining] = if (edge.expression) .{ .expression = context.expression(edge.value) } else .{ .text = context.text(edge.span) };
        head = edge.previous;
    }

    return values;
}

pub fn arms(context: Context, node: anytype) ![]zx.ast.MatchArm {
    const values = try context.allocator.alloc(zx.ast.MatchArm, @intCast(node.count));
    var head = node.head;
    var remaining = values.len;

    while (remaining != 0) {
        remaining -= 1;
        const edge = context.program.body.expression.tree.arms[@intCast(head - 1)];
        values[remaining] = .{ .condition = context.expression(edge.condition), .result = context.expression(edge.result) };
        head = edge.previous;
    }

    return values;
}

pub fn fields(context: Context, node: anytype) ![]zx.ast.Field {
    const values = try context.allocator.alloc(zx.ast.Field, @intCast(node.count));
    var head = node.head;
    var remaining = values.len;

    while (remaining != 0) {
        remaining -= 1;
        const edge = context.program.body.expression.tree.fields[@intCast(head - 1)];
        values[remaining] = .{ .name = if (edge.spread) .{ .text = "", .span = Context.span(edge.name) } else context.name(edge.name), .value = context.expression(edge.value), .spread = edge.spread };
        head = edge.previous;
    }

    return values;
}
