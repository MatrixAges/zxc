const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const view = @import("../../node/view.zig");
const Lower = @import("../lower.zig");
const rows = @import("../../node/import_rows.zig");

pub fn literal(self: *Lower, type_id: ir.TypeId, values: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    const element = try @import("../state_value/elements.zig").typeExpr(self, type_id);

    if (!@import("genz_options").generated_analysis) return seed(self, element, values);

    const entry = @import("generated_aggregate_list");
    const Input = std.meta.Child(entry.Input);
    const Output = std.meta.Child(entry.Output);
    const Capture = std.meta.Child(@typeInfo(@FieldType(Input, "capture")).optional.child);
    const Array = std.meta.Child(@FieldType(Output, "literal"));
    const Allocation = std.meta.Child(@typeInfo(@FieldType(Output, "allocation")).optional.child);
    const Call = std.meta.Child(@FieldType(Allocation, "nodes"));
    const base = self.builder.nodes.expressions.tags.items.len;
    var capture: Capture = undefined;

    const input: Input = .{
        .values = view.slice(@FieldType(Input, "values"), values),
        .element = @backingInt(element),
        .base = @intCast(base),
        .capture = if (self.capture) |boundary| captured: {
            capture = .{ .name = boundary.name, .label = boundary.label, .failure = @backingInt(boundary.failure) };

            break :captured &capture;
        } else null,
    };

    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.FixedBufferAllocator.init(&buffer);
    const output = zx.columns.invoke(entry.executeValue, memory.allocator(), @as(*const Input, &input)) catch |err| return failure(err);
    const array = zx.columns.view(Array, output.literal);

    try append(self, &array);

    const allocation = output.allocation orelse return @fromBackingInt(@intCast(base + 1));

    if (!allocation.valid) return error.OutOfMemory;

    var call = zx.columns.view(Call, allocation.nodes);
    const arguments = try self.allocator.dupe(u32, call.call_arguments[0]);

    call.call_arguments = &.{arguments};

    try append(self, &call);

    self.uses_allocator = true;

    return @fromBackingInt(allocation.root);
}

fn seed(self: *Lower, element: node.ExpressionId, values: []const node.ExpressionId) Lower.Error!node.ExpressionId {
    const array = try self.builder.expression(.{ .array = .{ .element_type = element, .values = values } });
    const address = try self.builder.expression(.{ .address_of = array });

    return if (values.len == 0) address else self.call(try self.field(try self.builder.identifier("allocator"), "dupe"), &.{ element, address }, true);
}

fn append(self: *Lower, source: anytype) Lower.Error!void {
    rows.appendBorrowed(self.allocator, &self.builder.nodes.expressions, source) catch |err| return failure(err);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
