const std = @import("std");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn apply(self: *Lower, body: *std.ArrayList(node.Statement), output: anytype) Lower.Error!node.ExpressionId {
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

pub fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
