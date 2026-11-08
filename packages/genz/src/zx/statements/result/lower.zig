const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../../node.zig");
const rows = @import("../../../node/import_rows.zig");
const statements = @import("../../../node/import_statements.zig");
const Lower = @import("../../lower.zig");
const generated = @import("genz_options").generated_analysis;

pub fn append(self: *Lower, output: *std.ArrayList(node.Statement), values: ir.Block, offset: usize, value: ?ir.ExprId) Lower.Error!bool {
    if (!generated) return @import("seed.zig").append(self, output, values, offset, value);

    var returned: ?node.ExpressionId = null;
    var consumed_previous = false;

    if (try eligible(values, offset, value != null)) {
        const binding = values.at(offset - 1).constant;
        returned = try @import("../../iteration_consumer.zig").lower(self, binding.symbol, binding.value, value.?, self.value_output);
        consumed_previous = returned != null;
    }

    if (value) |id| {
        if (returned == null) returned = if (self.value_output) try @import("../../value_call/root.zig").expression(self, id) else try self.expr(id);
        if (self.state_active) returned = try @import("../../state_value/ownership.zig").clip(self, output, id, returned.?);
    }

    if (self.public_value_output and self.state_active) if (returned) |result| {
        const boundary = try @import("../../aggregate.zig").bind(self, output, result);
        returned = try @import("../../state_value/conversion.zig").convert(self, output, self.program.output_type, boundary, .view_layout);
    };

    try emit(self, output, returned);

    return consumed_previous;
}

fn eligible(values: ir.Block, offset: usize, has_value: bool) Lower.Error!bool {
    const entry = @import("generated_result_eligible");
    const Input = std.meta.Child(entry.Input);

    const input: Input = .{
        .control = zx.columns.pointer(@FieldType(Input, "control"), values.control),
        .first = values.first,
        .count = values.len,
        .offset = offset,
        .has_value = has_value,
    };

    var memory = std.heap.FixedBufferAllocator.init(&.{});

    return zx.columns.invoke(entry.executeValue, memory.allocator(), &input) catch |err| return failure(err);
}

fn emit(self: *Lower, output: *std.ArrayList(node.Statement), value: ?node.ExpressionId) Lower.Error!void {
    const entry = @import("generated_result_emit");
    const Input = std.meta.Child(entry.Input);
    const Output = std.meta.Child(entry.Output);
    const Bases = std.meta.Child(@FieldType(Input, "bases"));
    const Expressions = std.meta.Child(@typeInfo(@FieldType(Output, "expressions")).optional.child);

    const bases: Bases = .{
        .capture = if (self.capture) |capture| &.{ .name = capture.name, .label = capture.label, .failure = @backingInt(capture.failure) } else null,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .statement_base = @intCast(self.builder.nodes.statements.tags.items.len),
        .field_base = @intCast(self.builder.nodes.field_columns.count()),
        .serial = self.serial,
    };

    const input: Input = .{ .value = if (value) |id| @backingInt(id) else null, .transaction = self.transaction(), .bases = &bases };
    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const allocator = memory.allocator();
    const result = entry.executeIn(allocator, &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    const name = if (result.name) |text| try self.allocator.dupe(u8, text) else null;
    var body = zx.columns.view(std.meta.Child(@FieldType(Output, "statements")), result.statements);

    if (result.expressions) |emitted| {
        var expressions = zx.columns.view(Expressions, emitted);

        if (name) |text| {
            const identifiers = try allocator.dupe(std.meta.Child(@FieldType(Expressions, "identifier")), expressions.identifier);

            identifiers[0] = text;
            expressions.identifier = identifiers;
        }

        rows.appendBorrowingText(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    }

    if (name) |text| {
        const names = try allocator.dupe(std.meta.Child(@TypeOf(body.constant_name)), body.constant_name);

        names[0] = text;
        body.constant_name = names;
    }

    statements.appendBorrowingText(self.allocator, output, &body) catch |err| return failure(err);

    self.serial = @intCast(result.serial);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
