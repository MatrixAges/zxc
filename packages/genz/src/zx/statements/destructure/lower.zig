const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../../node.zig");
const rows = @import("../../../node/import_rows.zig");
const statements = @import("../../../node/import_statements.zig");
const Lower = @import("../../lower.zig");
const generated = @import("genz_options").generated_analysis;

pub fn append(self: *Lower, output: *std.ArrayList(node.Statement), binding: @FieldType(ir.StatementRow, "destructure")) Lower.Error!void {
    if (!generated) return @import("seed.zig").append(self, output, binding);

    const entry = @import("generated_destructure_emit");
    const Input = std.meta.Child(entry.Input);
    const Output = std.meta.Child(entry.Output);
    const Expressions = std.meta.Child(@FieldType(Output, "expressions"));
    const name = try fresh(self);
    const value = self.program.expression(binding.value);
    const tuple = if (value.value == .capture) try @import("../../capture.zig").lowerValue(self, value.type_id, value.value.capture) else try self.expr(binding.value);

    const input: Input = .{
        .name = name,
        .value = @backingInt(tuple),
        .symbols = binding.symbols.values[0..binding.symbols.len],
        .names = self.names,
        .used = self.used,
        .expression_base = @intCast(self.builder.nodes.expressions.tags.items.len),
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const allocator = memory.allocator();
    const result = entry.executeIn(allocator, &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    var expressions = zx.columns.view(Expressions, result.expressions);
    const names = try allocator.alloc(std.meta.Child(@FieldType(Expressions, "field_name")), expressions.field_name.len);

    for (expressions.field_name, names) |text, *target| target.* = try self.allocator.dupe(u8, text);

    expressions.field_name = names;

    rows.appendBorrowed(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    statements.appendBorrowingText(self.allocator, output, result.statements) catch |err| return failure(err);
}

fn fresh(self: *Lower) Lower.Error![]const u8 {
    const entry = @import("generated_destructure_name");
    const Input = std.meta.Child(entry.Input);
    const input: Input = .{ .serial = self.serial };
    const result = zx.columns.invoke(entry.executeValue, self.allocator, @as(*const Input, &input)) catch |err| return failure(err);

    self.serial = @intCast(result.serial);

    return result.name;
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
