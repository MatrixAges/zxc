const std = @import("std");
const zx = @import("zx");
const ir = zx.ir;
const node = @import("../../node.zig");
const Lower = @import("../lower.zig");

pub fn append(self: *Lower, body: *std.ArrayList(node.Statement), type_id: ir.TypeId, target: node.ExpressionId, value: node.ExpressionId) Lower.Error!void {
    if (!@import("genz_options").generated_analysis) return @import("assignment_seed.zig").append(self, body, type_id, target, value);

    const entry = @import("generated_iteration_assignment");
    const Input = std.meta.Child(entry.Input);
    const Facts = std.meta.Child(@FieldType(Input, "facts"));
    const types = ir.TypeTable.borrow(std.meta.Child(@FieldType(Facts, "types")), self.program.types);
    const facts: Facts = .{ .types = &types, .selected = self.state_plan.selected };

    const input: Input = .{
        .facts = &facts,
        .active = self.state_active,
        .type_id = @backingInt(type_id),
        .target = @backingInt(target),
        .value = @backingInt(value),
        .base = @intCast(self.builder.nodes.expressions.tags.items.len),
        .serial = self.serial,
    };

    var scratch = std.heap.ArenaAllocator.init(self.workspace);
    var buffer: [std.heap.page_size_min]u8 = undefined;
    var memory = std.heap.BufferFirstAllocator.init(&buffer, scratch.allocator());

    defer scratch.deinit();

    const result = entry.executeIn(memory.allocator(), &input) catch |err| return failure(err);

    if (!result.valid) return error.OutOfMemory;

    var expressions = result.expressions.*;
    var snapshots = result.snapshots.*;
    const names = try memory.allocator().alloc([]const u8, expressions.identifier.len);

    for (expressions.identifier, names) |name, *owned| owned.* = try self.allocator.dupe(u8, name);

    expressions.identifier = names;
    snapshots.constant_name = names;

    const fields = try memory.allocator().dupe([]const u8, expressions.field_name);

    for (result.field_name_source, 0..) |source, index| {
        if (source) |owner| {
            const first: usize = @intCast(owner);
            fields[index] = if (first == index) try self.allocator.dupe(u8, fields[index]) else fields[first];
        }
    }

    expressions.field_name = fields;

    @import("../../node/import_rows.zig").appendBorrowed(self.allocator, &self.builder.nodes.expressions, &expressions) catch |err| return failure(err);
    const statements = @import("../../node/import_statements.zig");

    statements.appendBorrowingText(self.allocator, body, &snapshots) catch |err| return failure(err);
    statements.appendBorrowingText(self.allocator, body, result.assignments) catch |err| return failure(err);

    self.serial = @intCast(result.serial);
}

fn failure(err: anyerror) Lower.Error {
    return switch (err) {
        error.OutOfMemory, error.IntegerOverflow, error.Overflow => error.OutOfMemory,
        else => unreachable,
    };
}
