const std = @import("std");
const zx = @import("zx");
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");

pub fn lower(self: *Lower, callee: node.ExpressionId, arguments: []const node.ExpressionId, fallible: bool) Lower.Error!node.ExpressionId {
    const generated = @import("generated_invocation_call");
    const Input = std.meta.Child(generated.Input);
    const Output = std.meta.Child(generated.Output);
    const Expressions = std.meta.Child(@FieldType(Input, "expressions"));
    const Capture = std.meta.Child(@typeInfo(@FieldType(Input, "capture")).optional.child);
    const rows = &self.builder.nodes.expressions;

    const expressions: Expressions = .{
        .tags = view.slice(@FieldType(Expressions, "tags"), rows.tags.items),
        .offsets = rows.offsets.items,
        .identifier = rows.payloads.identifier.values.items,
        .field_target = view.slice(@FieldType(Expressions, "field_target"), rows.payloads.field.fields.target.values.items),
    };

    const owned = try self.allocator.dupe(node.ExpressionId, arguments);
    var capture: Capture = undefined;

    const input: Input = .{
        .expressions = &expressions,
        .callee = @backingInt(callee),
        .arguments = view.slice(@FieldType(Input, "arguments"), owned),
        .expression_base = @intCast(rows.tags.items.len),
        .fallible = fallible,
        .capture = if (self.capture) |boundary| captured: {
            capture = .{ .name = boundary.name, .label = boundary.label, .failure = @backingInt(boundary.failure) };

            break :captured &capture;
        } else null,
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);
    const output = zx.columns.invoke(generated.executeValue, memory.allocator(), @as(*const Input, &input)) catch |err| return failure(err);

    if (!output.valid) return error.OutOfMemory;

    const nodes = zx.columns.view(std.meta.Child(@FieldType(Output, "nodes")), output.nodes);
    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, rows, &nodes) catch |err| return failure(err);

    self.uses_allocator = self.uses_allocator or output.uses_allocator;

    return @fromBackingInt(output.root);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow => error.OutOfMemory,
        else => unreachable,
    };
}
